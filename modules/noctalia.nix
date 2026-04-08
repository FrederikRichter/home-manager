{config, inputs, lib, ...}:
{
    imports = [
        inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
        enable = true;
        settings = {
# configure noctalia here
            bar = {
                density = "default";
                position = "bottom";
                showCapsule = true;
                widgets = {
                    left = [
                    {
                        id = "ControlCenter";
                        useDistroLogo = true;
                    }
                    {
                        hideUnoccupied = true;
                        id = "Workspace";
                        labelMode = "index";
                    }
                    ];
                    center = [
                    {
                        id = "MediaMini";
                    }
                    ];
                    right = [
                    {
                        id = "SystemMonitor";
                    }
                    {
                        id = "Volume";
                    }
                    {
                        id = "Battery";
                        batteryWarningThreshold = 20;
                        batteryCriticalThreshold = 5; 
                        displayMode = "graphic";
                    }
                    {
                        formatHorizontal = "HH:mm";
                        formatVertical = "HH mm";
                        id = "Clock";
                        useMonospacedFont = true;
                        usePrimaryColor = true;
                    }
                    {
                        id = "Network";
                    }
                    {
                        id = "Bluetooth";
                        displayMode = "alwaysShow";
                    }
                    {
                        id = "Tray";
                    }
                    ];
                };
            };
            location = {
                name = "Brunswick";
                weatherEnabled = true;
                weatherShowEffects = false;
                useFahrenheit = false;
                use12hourFormat = false;
                showWeekNumberInCalendar = false;
                showCalendarEvents = false;
                showCalendarWeather = false;
                analogClockInCalendar = false;
                firstDayOfWeek = 0;
                hideWeatherTimezone = false;
                hideWeatherCityName = false;
            };
        };
    };
}

