extends Node

@export_range(0.0, 1.0) var moisture: float = 0.0:
	set = set_moisture, get = get_moisture

func get_moisture() -> float:
	return moisture

func set_moisture(value: float) -> void:
	moisture = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

@export_range(0.0, 1.0) var altitude: float = 0.0:
	set = set_altitude, get = get_altitude

func get_altitude() -> float:
	return altitude

func set_altitude(value: float) -> void:
	altitude = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

@export_range(0.0, 1.0) var temperature: float = 0.0:
	set = set_temperature, get = get_temperature

func get_temperature() -> float:
	return temperature

func set_temperature(value: float) -> void:
	temperature = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

@export_range(0.0, 1.0) var barometer: float = 0.0:
	set = set_barometer, get = get_barometer

func get_barometer() -> float:
	return barometer

func set_barometer(value: float) -> void:
	barometer = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

@export_range(0.0, 1.0) var wind_speed: float = 0.0:
	set = set_wind_speed, get = get_wind_speed

func get_wind_speed() -> float:
	return wind_speed

func set_wind_speed(value: float) -> void:
	wind_speed = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

@export var weather_direction: Vector2 = Vector2.LEFT:
	set = set_weather_direction, get = get_weather_direction

func set_weather_direction(value: Vector2) -> void:
	weather_direction = value
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

func get_weather_direction() -> Vector2:
	return weather_direction

@export var debug_panel: Panel

signal weather_changed(moisture: float, altitude: float, temperature: float, barometer: float, wind_speed: float, weather_direction: Vector2)

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
	weather_changed.emit(moisture, altitude, temperature, barometer, wind_speed, weather_direction)

func _on_right_weather_button_pressed() -> void:
	set_weather_direction(Vector2.RIGHT)

func _on_down_weather_button_pressed() -> void:
	set_weather_direction(Vector2.ZERO)

func _on_left_weather_button_pressed() -> void:
	set_weather_direction(Vector2.LEFT)

func _on_moisture_h_slider_value_changed(value: float) -> void:
	set_moisture(value)

func _on_altitude_h_slider_value_changed(value: float) -> void:
	set_altitude(value)

func _on_temp_h_slider_value_changed(value: float) -> void:
	set_temperature(value)

func _on_barometer_h_slider_value_changed(value: float) -> void:
	set_barometer(value)

func _on_wind_h_slider_value_changed(value: float) -> void:
	set_wind_speed(value)
