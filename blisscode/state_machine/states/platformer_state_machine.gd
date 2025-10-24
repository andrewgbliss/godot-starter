class_name PlatformerStateMachine extends StateMachine

@export var character: CharacterController

func _ready() -> void:
	init(character)
	add_transition(states["GroundState"], states["DashState"], "dash")
	add_transition(states["AirState"], states["DashState"], "dash_air")
	add_transition(states["DashState"], states["GroundState"], "move")
	add_transition(states["GroundState"], states["AirState"], "jump")
	add_transition(states["AirState"], states["AirState"], "jump_air")
	add_transition(states["GroundState"], states["AirState"], "falling")
	add_transition(states["AirState"], states["GroundState"], "land")
	
func _unhandled_input(event: InputEvent) -> void:
	process_input(event)

func _physics_process(delta: float) -> void:
	process_physics(delta)

func _process(delta: float) -> void:
	process_frame(delta)
