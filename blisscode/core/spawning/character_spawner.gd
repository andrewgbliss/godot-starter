class_name CharacterSpawner extends Node2D

@export var default_skin: CharacterSkin
@export var sprite_offset: Vector2 = Vector2.ZERO

var parent: World

signal spawned(character_controller: CharacterController)

func _ready():
	parent = get_parent()
	call_deferred("_after_ready")

func _after_ready():
	spawn()
	
func spawn():
	var skin = default_skin
	var c = CharacterManager.instantiate_character_from_skin(skin, parent)
	c.spawn_position = global_position
	if c.animated_sprite and sprite_offset != Vector2.ZERO:
		c.animated_sprite.offset = sprite_offset
	if c.state_machine:
		c.state_machine.enabled = true
		c.state_machine.start()
	spawned.emit(c)