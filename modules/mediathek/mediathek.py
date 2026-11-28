#!/usr/bin/env python3
"""Simple TUI for searching, streaming (via mpv), and downloading German public media (MediathekViewWeb)."""

import argparse
import curses
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import textwrap
import threading
import time
import urllib.error
import urllib.parse
import urllib.request

API_URL = "https://mediathekviewweb.de/api/query"
USER_AGENT = "mediathek-tui/1.0"
PAGE_SIZE = 50

CHANNELS = [
    "All",
    "ARD",
    "ZDF",
    "ARTE.DE",
    "3Sat",
    "BR",
    "NDR",
    "WDR",
    "SWR",
    "HR",
    "MDR",
    "RBB",
    "SR",
    "PHOENIX",
    "KiKA",
    "ORF",
    "SRF",
]

QUALITIES = ["HD", "SD", "Low"]

SORTS = [
    ("Newest", "timestamp", "desc"),
    ("Oldest", "timestamp", "asc"),
    ("Longest", "duration", "desc"),
]


def default_download_dir() -> str:
    env_dir = os.environ.get("MEDIATHEK_DOWNLOAD_DIR")
    if env_dir:
        return os.path.expanduser(env_dir)
    videos_dir = os.environ.get("XDG_VIDEOS_DIR")
    if videos_dir:
        return os.path.join(os.path.expanduser(videos_dir), "mediathek")
    return os.path.join(os.path.expanduser("~"), "Videos", "mediathek")


def format_duration(seconds) -> str:
    if not seconds or seconds <= 0:
        return "--:--"
    seconds = int(seconds)
    h, rem = divmod(seconds, 3600)
    m, s = divmod(rem, 60)
    if h > 0:
        return f"{h:d}:{m:02d}:{s:02d}"
    return f"{m:02d}:{s:02d}"


def format_date(timestamp) -> str:
    if not timestamp:
        return "----.--.--"
    try:
        dt = datetime.datetime.fromtimestamp(int(timestamp))
        return dt.strftime("%Y-%m-%d")
    except (ValueError, OSError):
        return "----.--.--"


def format_size(size_bytes) -> str:
    if not size_bytes or size_bytes <= 0:
        return "Unknown"
    mb = size_bytes / (1024 * 1024)
    if mb >= 1024:
        return f"{mb / 1024:.2f} GB"
    return f"{mb:.1f} MB"


def sanitize_filename(name: str) -> str:
    name = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "_", name)
    name = re.sub(r"\s+", " ", name).strip(" .")
    return name[:180] or "video"


def pick_video_url(item: dict, preferred_quality: str) -> tuple[str | None, str]:
    hd = item.get("url_video_hd") or ""
    sd = item.get("url_video") or ""
    low = item.get("url_video_low") or ""

    if preferred_quality == "HD":
        order = [("HD", hd), ("SD", sd), ("Low", low)]
    elif preferred_quality == "SD":
        order = [("SD", sd), ("HD", hd), ("Low", low)]
    else:
        order = [("Low", low), ("SD", sd), ("HD", hd)]

    for label, url in order:
        if url:
            return url, label
    return None, "None"


def query_api(
    search_text: str,
    channel: str,
    sort_by: str,
    sort_order: str,
    offset: int = 0,
    size: int = PAGE_SIZE,
) -> tuple[list[dict], int]:
    queries = []
    if search_text.strip():
        queries.append(
            {
                "fields": ["title", "topic", "description"],
                "query": search_text.strip(),
            }
        )
    if channel and channel != "All":
        queries.append(
            {
                "fields": ["channel"],
                "query": channel,
            }
        )

    payload = {
        "queries": queries,
        "sortBy": sort_by,
        "sortOrder": sort_order,
        "future": False,
        "offset": offset,
        "size": size,
    }

    req = urllib.request.Request(
        API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "User-Agent": USER_AGENT,
        },
        method="POST",
    )

    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode("utf-8"))

    if data.get("err"):
        raise RuntimeError(str(data["err"]))

    result = data.get("result") or {}
    results = result.get("results") or []
    total = (result.get("queryInfo") or {}).get("totalResults", len(results))
    return results, int(total)


class DownloadState:
    def __init__(self):
        self.lock = threading.Lock()
        self.active = False
        self.cancel_event = threading.Event()
        self.title = ""
        self.downloaded = 0
        self.total = 0
        self.speed = 0.0
        self.message = ""

    def snapshot(self) -> dict:
        with self.lock:
            return {
                "active": self.active,
                "title": self.title,
                "downloaded": self.downloaded,
                "total": self.total,
                "speed": self.speed,
                "message": self.message,
            }


class MediathekTUI:
    def __init__(self, stdscr, initial_query: str, download_dir: str):
        self.stdscr = stdscr
        self.download_dir = download_dir
        self.query = initial_query
        self.channel_idx = 0
        self.quality_idx = 0
        self.sort_idx = 0
        self.offset = 0
        self.total_results = 0
        self.results: list[dict] = []
        self.selected = 0
        self.scroll_top = 0
        self.status = "Press / to search, Enter to play in mpv, d to download"
        self.loading = False
        self.search_mode = False
        self.search_buf = initial_query
        self.show_help = False
        self.dl = DownloadState()
        self.dl_thread: threading.Thread | None = None
        self.fetch_lock = threading.Lock()
        self.fetch_gen = 0

    @property
    def channel(self) -> str:
        return CHANNELS[self.channel_idx]

    @property
    def quality(self) -> str:
        return QUALITIES[self.quality_idx]

    @property
    def sort_info(self) -> tuple[str, str, str]:
        return SORTS[self.sort_idx]

    def init_colors(self):
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_CYAN)    # Header / selected
        curses.init_pair(2, curses.COLOR_CYAN, -1)                    # Accent / channel
        curses.init_pair(3, curses.COLOR_YELLOW, -1)                  # Topic / warning
        curses.init_pair(4, curses.COLOR_GREEN, -1)                   # Success / HD
        curses.init_pair(5, curses.COLOR_WHITE, curses.COLOR_BLUE)    # Status bar
        curses.init_pair(6, curses.COLOR_RED, -1)                     # Error

    def trigger_search(self, reset_offset: bool = True):
        if reset_offset:
            self.offset = 0
        self.loading = True
        self.status = "Searching MediathekViewWeb..."
        with self.fetch_lock:
            self.fetch_gen += 1
            gen = self.fetch_gen

        q = self.query
        ch = self.channel
        _, sort_by, sort_order = self.sort_info
        off = self.offset

        def worker():
            try:
                items, total = query_api(q, ch, sort_by, sort_order, offset=off, size=PAGE_SIZE)
                with self.fetch_lock:
                    if gen != self.fetch_gen:
                        return
                    self.results = items
                    self.total_results = total
                    self.selected = 0
                    self.scroll_top = 0
                    self.loading = False
                    if items:
                        page = (off // PAGE_SIZE) + 1
                        self.status = f"Found {total} results (page {page}, showing {len(items)})"
                    else:
                        self.status = "No results found."
            except Exception as exc:
                with self.fetch_lock:
                    if gen != self.fetch_gen:
                        return
                    self.loading = False
                    self.status = f"Search error: {exc}"

        threading.Thread(target=worker, daemon=True).start()

    def play_selected(self):
        if not self.results:
            return
        item = self.results[self.selected]
        url, actual_q = pick_video_url(item, self.quality)
        if not url:
            self.status = "No playable video URL available for this item."
            return

        mpv_bin = shutil.which("mpv")
        if not mpv_bin:
            self.status = "Error: 'mpv' not found in PATH."
            return

        title = f"{item.get('channel', '')} - {item.get('topic', '')}: {item.get('title', '')}"
        cmd = [mpv_bin, f"--force-media-title={title}"]
        sub_url = item.get("url_subtitle") or ""
        if sub_url:
            cmd.append(f"--sub-file={sub_url}")
        cmd.append(url)

        try:
            subprocess.Popen(
                cmd,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                stdin=subprocess.DEVNULL,
                start_new_session=True,
            )
            self.status = f"Launched mpv ({actual_q}): {item.get('title', '')[:60]}"
        except Exception as exc:
            self.status = f"Failed to launch mpv: {exc}"

    def download_selected(self):
        if not self.results:
            return
        with self.dl.lock:
            if self.dl.active:
                self.status = "A download is already in progress. Press 'x' to cancel it."
                return

        item = self.results[self.selected]
        url, actual_q = pick_video_url(item, self.quality)
        if not url:
            self.status = "No downloadable video URL available for this item."
            return

        os.makedirs(self.download_dir, exist_ok=True)
        parsed = urllib.parse.urlparse(url)
        _, ext = os.path.splitext(parsed.path)
        if not ext or len(ext) > 6:
            ext = ".mp4"

        date_str = format_date(item.get("timestamp"))
        base = sanitize_filename(
            f"{item.get('channel', 'Mediathek')} - {item.get('topic', '')} - {item.get('title', '')} ({date_str})"
        )
        dest_path = os.path.join(self.download_dir, f"{base}{ext}")
        sub_url = item.get("url_subtitle") or ""

        self.dl.cancel_event.clear()
        with self.dl.lock:
            self.dl.active = True
            self.dl.title = item.get("title", "video")
            self.dl.downloaded = 0
            self.dl.total = 0
            self.dl.speed = 0.0
            self.dl.message = f"Starting download ({actual_q})..."

        def worker():
            tmp_path = dest_path + ".part"
            try:
                req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
                with urllib.request.urlopen(req, timeout=30) as resp:
                    total = int(resp.headers.get("Content-Length") or 0)
                    with self.dl.lock:
                        self.dl.total = total

                    start_time = time.monotonic()
                    downloaded = 0
                    with open(tmp_path, "wb") as f:
                        while True:
                            if self.dl.cancel_event.is_set():
                                raise InterruptedError("Download cancelled")
                            chunk = resp.read(65536)
                            if not chunk:
                                break
                            f.write(chunk)
                            downloaded += len(chunk)
                            elapsed = max(time.monotonic() - start_time, 0.001)
                            with self.dl.lock:
                                self.dl.downloaded = downloaded
                                self.dl.speed = downloaded / elapsed

                os.replace(tmp_path, dest_path)

                # Best-effort subtitle download
                if sub_url:
                    try:
                        sub_parsed = urllib.parse.urlparse(sub_url)
                        _, sub_ext = os.path.splitext(sub_parsed.path)
                        if not sub_ext or len(sub_ext) > 6:
                            sub_ext = ".ttml"
                        sub_dest = os.path.join(self.download_dir, f"{base}{sub_ext}")
                        sub_req = urllib.request.Request(sub_url, headers={"User-Agent": USER_AGENT})
                        with urllib.request.urlopen(sub_req, timeout=15) as sresp, open(sub_dest, "wb") as sf:
                            shutil.copyfileobj(sresp, sf)
                    except Exception:
                        pass

                with self.dl.lock:
                    self.dl.active = False
                    self.dl.message = f"Saved: {dest_path}"
                self.status = f"Downloaded: {dest_path}"
            except InterruptedError:
                try:
                    if os.path.exists(tmp_path):
                        os.remove(tmp_path)
                except OSError:
                    pass
                with self.dl.lock:
                    self.dl.active = False
                    self.dl.message = "Download cancelled."
                self.status = "Download cancelled."
            except Exception as exc:
                try:
                    if os.path.exists(tmp_path):
                        os.remove(tmp_path)
                except OSError:
                    pass
                with self.dl.lock:
                    self.dl.active = False
                    self.dl.message = f"Download failed: {exc}"
                self.status = f"Download failed: {exc}"

        self.dl_thread = threading.Thread(target=worker, daemon=True)
        self.dl_thread.start()

    def cancel_download(self):
        with self.dl.lock:
            if self.dl.active:
                self.dl.cancel_event.set()
                self.status = "Cancelling download..."

    def shutdown(self):
        self.dl.cancel_event.set()
        if self.dl_thread and self.dl_thread.is_alive():
            self.dl_thread.join(timeout=1.5)

    def safe_addstr(self, y: int, x: int, text: str, attr: int = 0):
        h, w = self.stdscr.getmaxyx()
        if y < 0 or y >= h or x >= w:
            return
        max_len = w - x - 1
        if max_len <= 0:
            return
        try:
            self.stdscr.addstr(y, x, text[:max_len], attr)
        except curses.error:
            pass

    def draw_help(self):
        h, w = self.stdscr.getmaxyx()
        lines = [
            " Mediathek TUI - Keybindings ",
            "",
            "  / or s       Search shows",
            "  Enter        Play selected show in mpv",
            "  d            Download selected show",
            "  x            Cancel active download",
            "  j / k / ↑↓   Move selection",
            "  PgUp / PgDn  Page up / down",
            "  g / G        Jump to top / bottom",
            "  n / p        Next / previous API result page",
            "  c            Cycle channel filter (All, ARD, ZDF, ...)",
            "  q            Cycle quality (HD, SD, Low)",
            "  o            Cycle sort order (Newest, Oldest, Longest)",
            "  r            Refresh results",
            "  ?            Toggle this help",
            "  Q / Esc      Quit",
            "",
            f"  Download dir: {self.download_dir}",
            "  Press any key to close help.",
        ]
        box_h = min(len(lines) + 2, h - 2)
        box_w = min(max(len(line) for line in lines) + 4, w - 2)
        top = max((h - box_h) // 2, 0)
        left = max((w - box_w) // 2, 0)

        for row in range(box_h):
            self.safe_addstr(top + row, left, " " * box_w, curses.color_pair(5))
        for idx, line in enumerate(lines[: box_h - 2]):
            attr = curses.color_pair(5) | (curses.A_BOLD if idx == 0 else 0)
            self.safe_addstr(top + 1 + idx, left + 1, line, attr)

    def draw(self):
        self.stdscr.erase()
        h, w = self.stdscr.getmaxyx()
        if h < 10 or w < 40:
            self.safe_addstr(0, 0, "Terminal too small (min 40x10)")
            self.stdscr.refresh()
            return

        # 1. Header bar
        sort_label = self.sort_info[0]
        header = f" Mediathek TUI  |  Channel: {self.channel}  |  Quality: {self.quality}  |  Sort: {sort_label}"
        self.safe_addstr(0, 0, header.ljust(w - 1), curses.color_pair(1) | curses.A_BOLD)

        # 2. Search bar
        if self.search_mode:
            prompt = f" Search: {self.search_buf}_"
            self.safe_addstr(1, 0, prompt, curses.A_BOLD | curses.color_pair(3))
        else:
            q_display = self.query if self.query else "(latest broadcasts — press / to search)"
            self.safe_addstr(1, 0, f" Query: {q_display}", curses.color_pair(2))

        self.safe_addstr(2, 0, "─" * (w - 1))

        # Layout split: list pane + details pane + status bar
        details_h = min(8, max(5, h // 4))
        list_top = 3
        list_h = max(1, h - list_top - details_h - 2)
        details_top = list_top + list_h + 1

        # Adjust scroll_top
        if self.selected < self.scroll_top:
            self.scroll_top = self.selected
        elif self.selected >= self.scroll_top + list_h:
            self.scroll_top = self.selected - list_h + 1

        # 3. Results list
        if self.loading and not self.results:
            self.safe_addstr(list_top, 2, "Loading...", curses.color_pair(3))
        elif not self.results:
            self.safe_addstr(list_top, 2, "No results.", curses.color_pair(3))
        else:
            for row in range(list_h):
                idx = self.scroll_top + row
                if idx >= len(self.results):
                    break
                item = self.results[idx]
                ch = (item.get("channel") or "")[:9].ljust(9)
                dt = format_date(item.get("timestamp"))
                dur = format_duration(item.get("duration")).rjust(7)
                topic = item.get("topic") or ""
                title = item.get("title") or ""
                label = f"{topic} — {title}" if topic and topic.lower() not in title.lower() else title
                line = f" {ch} {dt} {dur}  {label}"
                if idx == self.selected:
                    self.safe_addstr(list_top + row, 0, line.ljust(w - 1), curses.color_pair(1) | curses.A_BOLD)
                else:
                    self.safe_addstr(list_top + row, 0, line)

        # Separator
        self.safe_addstr(details_top - 1, 0, "─" * (w - 1))

        # 4. Details pane
        if self.results and 0 <= self.selected < len(self.results):
            item = self.results[self.selected]
            avail = []
            if item.get("url_video_hd"):
                avail.append("HD")
            if item.get("url_video"):
                avail.append("SD")
            if item.get("url_video_low"):
                avail.append("Low")
            sub_str = "Yes" if item.get("url_subtitle") else "No"

            meta = (
                f" {item.get('channel', '')} | {format_date(item.get('timestamp'))} | "
                f"{format_duration(item.get('duration'))} | {format_size(item.get('size'))} | "
                f"Qualities: {'/'.join(avail) or 'None'} | Subtitles: {sub_str}"
            )
            self.safe_addstr(details_top, 0, meta, curses.color_pair(2) | curses.A_BOLD)

            title_line = f" {item.get('topic', '')} — {item.get('title', '')}"
            self.safe_addstr(details_top + 1, 0, title_line, curses.color_pair(3) | curses.A_BOLD)

            desc = (item.get("description") or "No description available.").replace("\n", " ")
            wrapped = textwrap.wrap(desc, width=max(20, w - 3))
            for i, wline in enumerate(wrapped[: max(0, details_h - 3)]):
                self.safe_addstr(details_top + 2 + i, 1, wline)

        # 5. Status / Download bar
        dl_snap = self.dl.snapshot()
        if dl_snap["active"]:
            if dl_snap["total"] > 0:
                pct = (dl_snap["downloaded"] / dl_snap["total"]) * 100
                dl_mb = dl_snap["downloaded"] / (1024 * 1024)
                tot_mb = dl_snap["total"] / (1024 * 1024)
                spd_mb = dl_snap["speed"] / (1024 * 1024)
                status_text = f" Downloading: {pct:5.1f}% ({dl_mb:.1f}/{tot_mb:.1f} MB, {spd_mb:.1f} MB/s) [x: cancel]"
            else:
                dl_mb = dl_snap["downloaded"] / (1024 * 1024)
                status_text = f" Downloading: {dl_mb:.1f} MB [x: cancel]"
        else:
            status_text = f" {self.status}"

        self.safe_addstr(h - 2, 0, status_text.ljust(w - 1), curses.color_pair(5))

        hints = " Enter:Play  d:Download  /:Search  c:Channel  q:Quality  o:Sort  n/p:Page  ?:Help  Q:Quit"
        self.safe_addstr(h - 1, 0, hints)

        if self.show_help:
            self.draw_help()

        self.stdscr.refresh()

    def handle_search_key(self, ch: int):
        if ch in (10, 13, curses.KEY_ENTER):
            self.query = self.search_buf.strip()
            self.search_mode = False
            self.trigger_search(reset_offset=True)
        elif ch == 27:  # Esc
            self.search_mode = False
            self.search_buf = self.query
        elif ch in (curses.KEY_BACKSPACE, 127, 8):
            self.search_buf = self.search_buf[:-1]
        elif ch == 21:  # Ctrl-U
            self.search_buf = ""
        elif 32 <= ch <= 126 or ch >= 160:
            try:
                self.search_buf += chr(ch)
            except ValueError:
                pass

    def run(self):
        curses.curs_set(0)
        self.stdscr.timeout(150)
        self.init_colors()
        self.trigger_search(reset_offset=True)

        try:
            while True:
                self.draw()
                ch = self.stdscr.getch()
                if ch == -1:
                    continue

                if self.show_help:
                    self.show_help = False
                    continue

                if self.search_mode:
                    self.handle_search_key(ch)
                    continue

                if ch in (ord("Q"), 27):
                    break
                elif ch == ord("?"):
                    self.show_help = True
                elif ch in (ord("/"), ord("s")):
                    self.search_mode = True
                    self.search_buf = self.query
                elif ch in (curses.KEY_DOWN, ord("j")):
                    if self.results and self.selected < len(self.results) - 1:
                        self.selected += 1
                elif ch in (curses.KEY_UP, ord("k")):
                    if self.selected > 0:
                        self.selected -= 1
                elif ch == curses.KEY_NPAGE:
                    if self.results:
                        self.selected = min(len(self.results) - 1, self.selected + 15)
                elif ch == curses.KEY_PPAGE:
                    self.selected = max(0, self.selected - 15)
                elif ch in (ord("g"), curses.KEY_HOME):
                    self.selected = 0
                elif ch in (ord("G"), curses.KEY_END):
                    if self.results:
                        self.selected = len(self.results) - 1
                elif ch in (10, 13, curses.KEY_ENTER):
                    self.play_selected()
                elif ch == ord("d"):
                    self.download_selected()
                elif ch == ord("x"):
                    self.cancel_download()
                elif ch == ord("c"):
                    self.channel_idx = (self.channel_idx + 1) % len(CHANNELS)
                    self.trigger_search(reset_offset=True)
                elif ch == ord("q"):
                    self.quality_idx = (self.quality_idx + 1) % len(QUALITIES)
                    self.status = f"Preferred quality set to {self.quality}"
                elif ch == ord("o"):
                    self.sort_idx = (self.sort_idx + 1) % len(SORTS)
                    self.trigger_search(reset_offset=True)
                elif ch == ord("r"):
                    self.trigger_search(reset_offset=False)
                elif ch == ord("n"):
                    if self.offset + PAGE_SIZE < self.total_results:
                        self.offset += PAGE_SIZE
                        self.trigger_search(reset_offset=False)
                    else:
                        self.status = "Already on the last page."
                elif ch == ord("p"):
                    if self.offset >= PAGE_SIZE:
                        self.offset -= PAGE_SIZE
                        self.trigger_search(reset_offset=False)
                    else:
                        self.status = "Already on the first page."
        except KeyboardInterrupt:
            pass
        finally:
            self.shutdown()


def main():
    parser = argparse.ArgumentParser(
        prog="mediathek",
        description="TUI for searching, playing (via mpv), and downloading German public media shows.",
    )
    parser.add_argument("query", nargs="*", help="Optional initial search query")
    parser.add_argument(
        "-d",
        "--download-dir",
        default=default_download_dir(),
        help="Directory for downloaded videos (default: $XDG_VIDEOS_DIR/mediathek)",
    )
    args = parser.parse_args()
    initial_query = " ".join(args.query)

    try:
        curses.wrapper(lambda stdscr: MediathekTUI(stdscr, initial_query, args.download_dir).run())
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
