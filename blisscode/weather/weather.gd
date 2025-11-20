class_name Weather extends Node2D

@export var particles: GPUParticles2D
@export var light_material: ParticleProcessMaterial
@export var heavy_material: ParticleProcessMaterial
@export var gravity_x: float = 0.0
@export var color_rect_overlay: ColorRect

@export_range(0.0, 1.0) var moisture_min: float = 0.0
@export_range(0.0, 1.0) var moisture_max: float = 0.0
@export_range(0.0, 1.0) var temperature_min: float = 0.0
@export_range(0.0, 1.0) var temperature_max: float = 0.0
@export_range(0.0, 1.0) var altitude_min: float = 0.0
@export_range(0.0, 1.0) var altitude_max: float = 0.0
@export_range(0.0, 1.0) var barometer_min: float = 0.0
@export_range(0.0, 1.0) var barometer_max: float = 0.0
@export_range(0.0, 1.0) var wind_speed_min: float = 0.0
@export_range(0.0, 1.0) var wind_speed_max: float = 0.0

func _ready() -> void:
	stop()
	if color_rect_overlay:
			color_rect_overlay.hide()
	WeatherService.weather_changed.connect(_on_weather_changed)

func _on_weather_changed(moisture: float, altitude: float, temperature: float, barometer: float, wind_speed: float, weather_direction: Vector2) -> void:
	var matches: bool = (
		moisture >= moisture_min and moisture <= moisture_max and
		temperature >= temperature_min and temperature <= temperature_max and
		altitude >= altitude_min and altitude <= altitude_max and
		barometer >= barometer_min and barometer <= barometer_max and
		wind_speed >= wind_speed_min and wind_speed <= wind_speed_max
	)
	
	if matches:
		if color_rect_overlay:
			color_rect_overlay.show()
		start()
	else:
		if color_rect_overlay:
			color_rect_overlay.hide()
		stop()

	match weather_direction:
		Vector2.LEFT:
			if light_material:
				light_material.gravity.x = - gravity_x
			if heavy_material:
				heavy_material.gravity.x = - gravity_x
			if color_rect_overlay:
				color_rect_overlay.material.set_shader_parameter("speed", Vector2(wind_speed / 10.0, 0.0))
		Vector2.RIGHT:
			if light_material:
				light_material.gravity.x = gravity_x
			if heavy_material:
				heavy_material.gravity.x = gravity_x
			if color_rect_overlay:
				color_rect_overlay.material.set_shader_parameter("speed", Vector2(-wind_speed / 10.0, 0.0))
		Vector2.ZERO:
			if light_material:
				light_material.gravity.x = 0
			if heavy_material:
				heavy_material.gravity.x = 0
			if color_rect_overlay:
				color_rect_overlay.material.set_shader_parameter("speed", Vector2(0.0, 0.0))
	
func start():
	if particles:
		particles.emitting = true

func stop():
	if particles:
		particles.emitting = false
	
func toggle():
	if particles:
		particles.emitting = !particles.emitting
