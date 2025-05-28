{
    programs.vesktop = {
        enable = true;
        vencord.settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
            disableMinSize = true;
            plugins = {
                MessageLogger.enabled = true;
                FakeNitro.enabled = true;
            };
        };
    };
}
