#version 300 es

/*
 * hdr_brightness.frag — color-accurate HDR software brightness for Hyprland
 * ============================================================================
 *
 * Why this exists
 * ---------------
 * Many HDR monitors reject DDC/CI hardware-brightness commands while they are
 * in HDR mode. This shader therefore performs the brightness change in the
 * display's *luminance* domain on the GPU.
 *
 * Hyprland 0.56+ color-management pipeline
 * ----------------------------------------
 * With `monitor = ..., bitdepth, 10, cm, hdr` Hyprland renders the desktop into
 * a linear scRGB/BT.2020 work buffer, then color-manages it to the monitor's
 * image description (BT.2020 primaries, SMPTE ST 2084 / PQ transfer function)
 * BEFORE the `decoration:screen_shader` pass runs. The final screen shader thus
 * receives a *PQ-encoded* signal V in [0, 1] (10-bit XBGR2101010 in this setup),
 * not scene-linear light. That is exactly the assumption made below.
 *
 * Pipeline implemented here
 * -------------------------
 *   V (PQ signal)
 *     -- ST 2084 EOTF (PQ decode) -->  L  in nits, [0, 10000]
 *     -- linear scale by k         -->  L*k        (exact per-channel ratio,
 *                                                  i.e. hue/saturation kept)
 *     -- highlight soft-clip (k>1) -->  L'         (BT.2390-style rational knee,
 *                                                  never hard-clips)
 *     -- inverse ST 2084 (PQ encode)--> V'         (display output)
 *
 * Round-trip note
 * ---------------
 * The task brief lists `m2 = 2523/4096 * 128 = 78.640625`. The literal decimal
 * is a typo: the ST 2084 definition `(2523/4096)*128` evaluates to 78.84375,
 * which is also what Hyprland's own CM (`PQ_M2`) uses. We use the *formula* so
 * that encode(decode(V)) == V and no tint is introduced. Using 78.640625 would
 * make this shader disagree with the compositor's PQ coding.
 *
 * The value `HDR_BRIGHTNESS` is rewritten in place by the `hypr-hdr-control`
 * helper. The file stays valid GLSL at all times (default k = 1.0, identity).
 */

precision highp float;

in vec2      v_texcoord; // 0..1 screen UV, provided by Hyprland
uniform sampler2D tex;   // compositor output, PQ-encoded
layout(location = 0) out vec4 fragColor;

// ---------------------------------------------------------------------------
// Managed by hypr-hdr-control: replace the numeric literals on these lines.
// ---------------------------------------------------------------------------
#define HDR_BRIGHTNESS 1.0   // k in [0.05, 2.0]
#define HDR_SOFTCLIP   0     // 1 while k > 1.0, else 0 (keeps dimming exact)
#define HDR_KNEE_RATIO 0.85  // top fraction of the range where roll-off starts

// ---------------------------------------------------------------------------
// SMPTE ST 2084 (PQ) constants — exact rational definitions.
// ---------------------------------------------------------------------------
#define PQ_M1 (2610.0 / 16384.0)            // 0.1593017578125
#define PQ_M2 ((2523.0 / 4096.0) * 128.0)   // 78.84375
#define PQ_C1 (3424.0 / 4096.0)             // 0.8359375
#define PQ_C2 ((2413.0 / 4096.0) * 32.0)    // 18.8515625
#define PQ_C3 ((2392.0 / 4096.0) * 32.0)    // 18.6875

#define PQ_PEAK_NITS 10000.0

// EOTF: PQ signal [0,1] -> linear light in nits [0, 10000].
vec3 pqToNits(vec3 v) {
    vec3   E = pow(clamp(v, 0.0, 1.0), vec3(1.0 / PQ_M2));
    vec3   L = pow(max(E - PQ_C1, 0.0) / (PQ_C2 - PQ_C3 * E), vec3(1.0 / PQ_M1));
    return clamp(L, 0.0, 1.0) * PQ_PEAK_NITS;
}

// OETF: linear light in nits -> PQ signal [0,1].
vec3 nitsToPq(vec3 nits) {
    vec3 E = pow(clamp(nits / PQ_PEAK_NITS, 0.0, 1.0), vec3(PQ_M1));
    return pow((PQ_C1 + PQ_C2 * E) / (1.0 + PQ_C3 * E), vec3(PQ_M2));
}

// BT.2390-inspired rational highlight roll-off, applied to a scalar in nits.
// Identity below `knee`, C1-continuous at the knee, and maps the scaled source
// peak exactly onto PQ_PEAK_NITS without ever overshooting or hard-clipping.
float softClipNits(float x) {
#if HDR_SOFTCLIP
    // Peak of the scaled signal: k * 10000 nits (only reached when k > 1).
    const float sourcePeak = PQ_PEAK_NITS * HDR_BRIGHTNESS;
    const float targetPeak = PQ_PEAK_NITS;
    const float knee       = targetPeak * HDR_KNEE_RATIO;
    if (x <= knee)
        return x;
    const float alpha = (sourcePeak - targetPeak) / ((sourcePeak - knee) * (targetPeak - knee));
    return knee + (x - knee) / (1.0 + alpha * (x - knee));
#else
    return x;
#endif
}

void main() {
    vec4 src = texture(tex, v_texcoord);

    // 1) PQ decode -> absolute linear luminance (nits).
    vec3 nits = pqToNits(src.rgb);

    // 2) Uniform linear scaling. Applying one scalar to every channel is what
    //    preserves the chromaticity (hue and saturation) exactly.
    vec3 scaled = nits * HDR_BRIGHTNESS;

    // 3) Highlight preservation for k > 1. We derive a *single* compression
    //    factor from the brightest channel and apply it to all channels, so the
    //    RGB ratios (hue/sat) remain untouched while no channel can exceed the
    //    display peak. Without this, per-channel PQ clipping would desaturate
    //    or shift blown-out highlights.
    float peak    = max(scaled.r, max(scaled.g, scaled.b));
    float peakOut = softClipNits(peak);
    scaled *= (peak > 1e-6) ? (peakOut / peak) : 1.0;

    // 4) PQ encode for display output. Alpha is passed through unchanged.
    fragColor = vec4(nitsToPq(scaled), src.a);
}
