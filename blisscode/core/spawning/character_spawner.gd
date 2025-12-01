class_name CharacterSpawner extends Node2D

@export var default_skin: CharacterSkin

var parent: World

func _ready():
	parent = get_parent()
	call_deferred("_after_ready")

func _after_ready():
	spawn()
	
func spawn():
	var skin = default_skin
	var c = CharacterManager.instantiate_character_from_skin(skin, parent)
	c.spawn_position = global_position
	if c.state_machine:
		c.state_machine.enabled = true
		c.state_machine.start()
