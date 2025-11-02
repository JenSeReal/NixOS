{delib, ...}:
delib.module {
  name = "programs.activity-monitor";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    system.defaults.ActivityMonitor = {
      ShowCategory = 100;
      IconType = 5;
      SortColumn = "CPUUsage";
      SortDirection = 1;
    };
  };
}
