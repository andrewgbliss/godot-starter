class_name Weather extends Node2D

@export var weather_service_type: WeatherService.WeatherType = WeatherService.WeatherType.NONE
@export var particles: GPUParticles2D
@export var light_material: ParticleProcessMaterial
@export var heavy_material: ParticleProcessMaterial

func _ready() -> void:
	stop()
	WeatherService.weather_changed.connect(_on_weather_changed)

func _on_weather_changed(weather_type: WeatherService.WeatherType, weather_intensity: WeatherService.WeatherIntensity, fog_intensity: WeatherService.FogIntensity, wind_direction: Vector2) -> void:
	if weather_service_type == weather_type:
		start()
	else:
		stop()

	match wind_direction:
		Vector2.LEFT:
			light_material.direction.x = -1
			heavy_material.direction.x = -1
		Vector2.RIGHT:
			light_material.direction.x = 1
			heavy_material.direction.x = 1
		Vector2.ZERO:
			light_material.direction.x = 0
			heavy_material.direction.x = 0

	match weather_intensity:
		WeatherService.WeatherIntensity.LIGHT:
			particles.process_material = light_material
		WeatherService.WeatherIntensity.HEAVY:
			particles.process_material = heavy_material

	print("fog_intensity: ", fog_intensity)
	
func start():
	particles.emitting = true

func stop():
	particles.emitting = false
	
func toggle():
	particles.emitting = !particles.emitting
