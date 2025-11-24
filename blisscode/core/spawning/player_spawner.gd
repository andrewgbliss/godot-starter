class_name PlayerSpawner extends Node2D

var parent: World
var player: CharacterController

func _ready():
	parent = get_parent()
	call_deferred("_after_ready")

func _after_ready():
	spawn()
	
func spawn():
	player = SpawnManager.spawn_player("player", global_position, parent)
	EventBus.player_spawned.emit(player)
