class_name AnimatedSpriteFacingDirection extends Node2D

@export var agent: CharacterController
@export var animated_sprite: AnimatedSprite2D
@export var flip_offset: Vector2 = Vector2.ZERO

var is_facing_right = true
var default_offset: Vector2 = Vector2.ZERO

func _ready():
	default_offset = animated_sprite.offset

func _process(_delta: float) -> void:
	_update_facing_direction()
	_update_gravity_dir()

func _update_gravity_dir():
	var dir = agent.gravity_dir
	animated_sprite.flip_v = dir.y == -1
	if dir.y == -1:
		animated_sprite.offset = flip_offset
	else:
		animated_sprite.offset = default_offset

func _update_facing_direction():
	match GameManager.user_config.facing_type:
		UserConfig.FacingType.MOUSE:
			var mouse_pos = get_global_mouse_position()
			is_facing_right = mouse_pos.x > agent.position.x
		UserConfig.FacingType.TOUCH:
			is_facing_right = agent.controls.touch_position.x > agent.global_position.x
		UserConfig.FacingType.KEYBOARD:
			is_facing_right = agent.velocity.x > 0
		UserConfig.FacingType.JOYSTICK:
			is_facing_right = agent.velocity.x > 0
		UserConfig.FacingType.DEFAULT:
			is_facing_right = agent.velocity.x > 0
	_handle_flip()

func _handle_flip():
	animated_sprite.flip_h = not is_facing_right

func save():
	var data = {
		"filename": get_scene_file_path(),
		"path": get_path(),
		"parent": get_parent().get_path(),
		"is_facing_right": is_facing_right,
	}
	return data
	
func restore(data):
	if data.has("is_facing_right"):
		is_facing_right = data.get("is_facing_right")
