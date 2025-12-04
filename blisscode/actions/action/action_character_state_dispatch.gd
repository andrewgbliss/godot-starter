class_name ActionCharacterStateDispatch extends Action

@export var player_spawner: PlayerSpawner
@export var state: String

var character_controller: CharacterController

func _ready():
	player_spawner.spawned.connect(on_player_spawned)

func on_player_spawned(cc: CharacterController):
	character_controller = cc

func process(_delta: float) -> Status:
	if not character_controller:
		return Status.SUCCESS
	character_controller.state_machine.dispatch(state)
	return Status.SUCCESS
