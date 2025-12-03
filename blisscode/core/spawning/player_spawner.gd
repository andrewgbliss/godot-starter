class_name PlayerSpawner extends Node2D

@export var default_skin: CharacterSkin

var parent: World
var player: CharacterController

func _ready():
	parent = get_parent()
	call_deferred("_after_ready")

func _after_ready():
	spawn()
	
func spawn():
	var user_profile = UserManager.get_current_user_profile()
	var skin = user_profile.current_character_skin
	if not skin:
		skin = default_skin
	player = CharacterManager.instantiate_character_from_skin(skin, parent)
	player.spawn_position = global_position
	player.focus()
	player.state_machine.enabled = true
	player.state_machine.start()
	EventBus.player_spawned.emit(player)
