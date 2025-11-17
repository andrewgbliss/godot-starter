extends Node

enum WeatherType {
	NONE,
	RAIN,
	SNOW,
	HAIL,
}

enum WeatherIntensity {
	LIGHT,
	HEAVY,
}

enum FogIntensity {
	NONE,
	LIGHT,
	HEAVY,
}

@export var weather_type: WeatherType = WeatherType.NONE:
	set = set_weather_type, get = get_weather_type
func set_weather_type(value: WeatherType) -> void:
	weather_type = value
	weather_changed.emit(weather_type, weather_intensity, fog_intensity, wind_direction)
	_update_debug_label()

func get_weather_type() -> WeatherType:
	return weather_type

@export var weather_intensity: WeatherIntensity = WeatherIntensity.LIGHT:
	set = set_weather_intensity, get = get_weather_intensity

func set_weather_intensity(value: WeatherIntensity) -> void:
	weather_intensity = value
	weather_changed.emit(weather_type, weather_intensity, fog_intensity, wind_direction)
	_update_debug_label()

func get_weather_intensity() -> WeatherIntensity:
	return weather_intensity

@export var fog_intensity: FogIntensity = FogIntensity.NONE:
	set = set_fog_intensity, get = get_fog_intensity
	
func set_fog_intensity(value: FogIntensity) -> void:
	fog_intensity = value
	weather_changed.emit(weather_type, weather_intensity, fog_intensity, wind_direction)
	_update_debug_label()

func get_fog_intensity() -> FogIntensity:
	return fog_intensity

@export var wind_direction: Vector2 = Vector2.LEFT:
	set = set_wind_direction, get = get_wind_direction

func set_wind_direction(value: Vector2) -> void:
	wind_direction = value
	weather_changed.emit(weather_type, weather_intensity, fog_intensity, wind_direction)
	_update_debug_label()

func get_wind_direction() -> Vector2:
	return wind_direction

@export var debug_panel: Panel
@export var debug_label: Label

signal weather_changed(weather_type: WeatherType, weather_intensity: WeatherIntensity, fog_intensity: FogIntensity, wind_direction: Vector2)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		if debug_panel.visible:
			debug_panel.hide()
		else:
			debug_panel.show()

func _ready() -> void:
	debug_panel.hide()
	call_deferred("_after_ready")

func _after_ready() -> void:
	_update_debug_label()
	weather_changed.emit(weather_type, weather_intensity, fog_intensity, wind_direction)

func _update_debug_label():
	if debug_label:
		var weather_type_string = ""
		match weather_type:
			WeatherType.NONE:
				weather_type_string = ""
			WeatherType.RAIN:
				weather_type_string = "Rain"
			WeatherType.SNOW:
				weather_type_string = "Snow"
			WeatherType.HAIL:
				weather_type_string = "Hail"
		var weather_intensity_string = ""
		match weather_intensity:
			WeatherIntensity.LIGHT:
				weather_intensity_string = "Breezy"
			WeatherIntensity.HEAVY:
				weather_intensity_string = "Windy"
		var fog_intensity_string = ""
		match fog_intensity:
			FogIntensity.NONE:
				fog_intensity_string = ""
			FogIntensity.LIGHT:
				fog_intensity_string = "Light Fog"
			FogIntensity.HEAVY:
				fog_intensity_string = "Heavy Fog"
		var wind_direction_string = ""
		match wind_direction:
			Vector2.LEFT:
				wind_direction_string = "Left Wind"
			Vector2.RIGHT:
				wind_direction_string = "Right Wind"
		debug_label.text = "%s %s %s %s" % [weather_intensity_string, weather_type_string, fog_intensity_string, wind_direction_string]

func _on_none_button_pressed() -> void:
	set_weather_type(WeatherType.NONE)

func _on_rain_button_pressed() -> void:
	set_weather_type(WeatherType.RAIN)

func _on_snow_button_pressed() -> void:
	set_weather_type(WeatherType.SNOW)

func _on_hail_button_pressed() -> void:
	set_weather_type(WeatherType.HAIL)

func _on_breezy_button_pressed() -> void:
	set_weather_intensity(WeatherIntensity.LIGHT)

func _on_windy_button_pressed() -> void:
	set_weather_intensity(WeatherIntensity.HEAVY)

func _on_no_fog_button_pressed() -> void:
	set_fog_intensity(FogIntensity.NONE)

func _on_light_fog_button_pressed() -> void:
	set_fog_intensity(FogIntensity.LIGHT)

func _on_heavy_fog_button_pressed() -> void:
	set_fog_intensity(FogIntensity.HEAVY)

func _on_left_wind_button_pressed() -> void:
	set_wind_direction(Vector2.LEFT)

func _on_right_wind_button_pressed() -> void:
	set_wind_direction(Vector2.RIGHT)

func _on_down_wind_button_pressed() -> void:
	set_wind_direction(Vector2.ZERO)
