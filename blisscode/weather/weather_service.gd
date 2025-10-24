extends Node2D

@export_group("Rain")
@export var rain_particles: GPUParticles2D
@export var light_rain: ParticleProcessMaterial
@export var heavy_rain: ParticleProcessMaterial

func _ready() -> void:
	stop_all()

func stop_all():
	rain_particles.emitting = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == 49:
		toggle_rain()
	if event is InputEventKey and event.pressed and event.keycode == 50:
		if rain_particles.process_material == light_rain:
			set_rain_particle_material(heavy_rain)
		else:
			set_rain_particle_material(light_rain)

func toggle_rain():
	rain_particles.emitting = !rain_particles.emitting

func set_rain_particle_material(m: ParticleProcessMaterial):
	rain_particles.process_material = m
