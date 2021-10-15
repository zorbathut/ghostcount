data:extend({
  {
    type = "int-setting",
    name = "ghost-count-refresh",
    localised_name = "Refresh Interval",
	localised_description = "Time in seconds between updates when the ghost count window is open.\n\nDefault is 5 seconds.\n\nLower values will reduce game performance depending on map size.\n\nInteger values only.",
    setting_type = "runtime-global",
    default_value = 5,
	minimum_value = 1,
	maximum_value = 60,
  }
})