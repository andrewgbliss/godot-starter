class_name Weather extends Node2D

enum WeatherType {
	RAIN,
	SNOW,
	HAIL,
	WIND_TRAILS,
	LEAVES,
	FOG,
}

@export var weather_type: WeatherType = WeatherType.RAIN
@export var particles: GPUParticles2D
@export var light_material: ParticleProcessMaterial
@export var heavy_material: ParticleProcessMaterial
@export var gravity_x: float = 0.0

func _ready() -> void:
	stop()
	WeatherService.weather_changed.connect(_on_weather_changed)

func _get_weather_type() -> String:
	match weather_type:
		WeatherType.RAIN:
			return "rain"
		WeatherType.SNOW:
			return "snow"
		WeatherType.HAIL:
			return "hail"
		WeatherType.WIND_TRAILS:
			return "wind_trails"
		WeatherType.LEAVES:
			return "leaves"
		WeatherType.FOG:
			return "fog"
		_:
			return ""

func _on_weather_changed(weather: Dictionary[String, bool], weather_intensity: WeatherService.WeatherIntensity, wind_direction: Vector2) -> void:
	if weather[_get_weather_type()]:
		start()
	else:
		stop()

	match wind_direction:
		Vector2.LEFT:
			light_material.gravity.x = - gravity_x
			heavy_material.gravity.x = - gravity_x
		Vector2.RIGHT:
			light_material.gravity.x = gravity_x
			heavy_material.gravity.x = gravity_x
		Vector2.ZERO:
			light_material.gravity.x = 0
			heavy_material.gravity.x = 0

	match weather_intensity:
		WeatherService.WeatherIntensity.LIGHT:
			particles.process_material = light_material
		WeatherService.WeatherIntensity.HEAVY:
			particles.process_material = heavy_material
	
func start():
	particles.emitting = true

func stop():
	particles.emitting = false
	
func toggle():
	particles.emitting = !particles.emitting
