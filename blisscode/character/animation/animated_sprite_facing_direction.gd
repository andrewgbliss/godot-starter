class_name AnimatedSpriteFacingDirection extends Node2D

@export var agent: CharacterController
@export var animated_sprite: AnimatedSprite2D
@export var flip_offset: Vector2 = Vector2.ZERO

var default_offset: Vector2 = Vector2.ZERO

func _ready():
	default_offset = animated_sprite.offset

func _process(_delta: float) -> void:
	_update_facing_direction()
	_update_gravity_dir()

func _update_gravity_dir():
	var dir = agent.gravity_dir
	if not agent.flip_v_lock:
		animated_sprite.flip_v = dir.y == -1
	if dir.y == -1:
		animated_sprite.offset = flip_offset
	else:
		animated_sprite.offset = default_offset

func _update_facing_direction():
	if not agent.flip_h_lock:
		match GameManager.user_config.facing_type:
			UserConfig.FacingType.MOUSE:
				var mouse_pos = get_global_mouse_position()
				agent.is_facing_right = mouse_pos.x > agent.position.x
			UserConfig.FacingType.TOUCH:
				agent.is_facing_right = agent.controls.touch_position.x > agent.global_position.x
			UserConfig.FacingType.KEYBOARD:
				agent.is_facing_right = agent.velocity.x > 0
			UserConfig.FacingType.JOYSTICK:
				agent.is_facing_right = agent.controls.get_aim_direction().x > 0
			UserConfig.FacingType.DEFAULT:
				agent.is_facing_right = agent.velocity.x > 0
	_handle_flip()

func _handle_flip():
	animated_sprite.flip_h = not agent.is_facing_right