extends Node

@export var weather: Dictionary[String, bool] = {
	"rain": false,
	"snow": false,
	"hail": false,
	"wind_trails": false,
	"leaves": false,
	"fog": false,
}:
	set = set_weather, get = get_weather

func set_weather(value: Dictionary[String, bool]) -> void:
	weather = value
	weather_changed.emit(weather, weather_intensity, wind_direction)

func get_weather() -> Dictionary[String, bool]:
	return weather

func set_weather_key(key: String, value: bool) -> void:
	weather[key] = value
	weather_changed.emit(weather, weather_intensity, wind_direction)

func get_weather_key(key: String) -> bool:
	return weather[key]

enum WeatherIntensity {
	LIGHT,
	HEAVY,
}

@export var weather_intensity: WeatherIntensity = WeatherIntensity.LIGHT:
	set = set_weather_intensity, get = get_weather_intensity

func set_weather_intensity(value: WeatherIntensity) -> void:
	weather_intensity = value
	weather_changed.emit(weather, weather_intensity, wind_direction)

func get_weather_intensity() -> WeatherIntensity:
	return weather_intensity

@export var wind_direction: Vector2 = Vector2.LEFT:
	set = set_wind_direction, get = get_wind_direction

func set_wind_direction(value: Vector2) -> void:
	wind_direction = value
	weather_changed.emit(weather, weather_intensity, wind_direction)

func get_wind_direction() -> Vector2:
	return wind_direction

@export var debug_panel: Panel
@export var debug_label: Label

signal weather_changed(weather: Dictionary[String, bool], weather_intensity: WeatherIntensity, wind_direction: Vector2)

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
	weather_changed.emit(weather, weather_intensity, wind_direction)

func _on_none_button_pressed() -> void:
	set_weather({
		"rain": false,
		"snow": false,
		"hail": false,
		"wind_trails": false,
		"leaves": false,
	})

func _on_rain_button_pressed() -> void:
	set_weather_key("rain", not get_weather_key("rain"))

func _on_snow_button_pressed() -> void:
	set_weather_key("snow", not get_weather_key("snow"))

func _on_hail_button_pressed() -> void:
	set_weather_key("hail", not get_weather_key("hail"))

func _on_breezy_button_pressed() -> void:
	set_weather_intensity(WeatherIntensity.LIGHT)

func _on_windy_button_pressed() -> void:
	set_weather_intensity(WeatherIntensity.HEAVY)

func _on_left_wind_button_pressed() -> void:
	set_wind_direction(Vector2.LEFT)

func _on_right_wind_button_pressed() -> void:
	set_wind_direction(Vector2.RIGHT)

func _on_down_wind_button_pressed() -> void:
	set_wind_direction(Vector2.ZERO)
	
func _on_wind_check_button_toggled(toggled_on: bool) -> void:
	set_weather_key("wind_trails", toggled_on)

func _on_fog_check_button_toggled(toggled_on: bool) -> void:
	set_weather_key("fog", toggled_on)

func _on_heavy_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		set_weather_intensity(WeatherIntensity.HEAVY)
	else:
		set_weather_intensity(WeatherIntensity.LIGHT)
