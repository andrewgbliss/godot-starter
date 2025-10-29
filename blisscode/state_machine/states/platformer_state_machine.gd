class_name PlatformerStateMachine extends StateMachine

@export var character: CharacterController

func _ready() -> void:
	init(character)

	add_transition(states["SpawnState"], states["IdleState"], "spawn")

	add_transition(null, states["IdleState"], "idle")
	add_transition(null, states["WalkState"], "walk")
	add_transition(null, states["RunState"], "run")

	add_transition(null, states["DashState"], "dash")
	add_transition(states["DashState"], states["IdleState"], "dash_stop")

	add_transition(null, states["JumpState"], "jump")
	add_transition(states["RunState"], states["JumpFlipState"], "jump_flip")
	add_transition(null, states["FallingState"], "falling")
	add_transition(null, states["LandState"], "land")

	add_transition(states["JumpState"], states["WallClingState"], "wall_cling")
	add_transition(states["WallClingState"], states["WallJumpState"], "wall_jump")

	add_transition(null, states["AttackState"], "attack")
	add_transition(states["AttackState"], null, "attack_finished")

	add_transition(null, states["DeathState"], "death")

	call_deferred("_after_ready")

func _after_ready() -> void:
	start()

func _unhandled_input(event: InputEvent) -> void:
	process_input(event)

func _physics_process(delta: float) -> void:
	process_physics(delta)

func _process(delta: float) -> void:
	process_frame(delta)
