class_name WallClingState extends MoveState

func enter() -> void:
	super.enter()
	parent.flip_h_lock = true
	parent.stop()

func process_input(event: InputEvent) -> void:
	if parent.paralyzed:
		return
	if event.is_action_pressed("jump"):
		state_machine.dispatch("wall_jump")
		return
	super.process_input(event)

func process_physics(_delta: float) -> void:
	var collision_point = parent.is_wall_clinging()
	if collision_point == null:
		state_machine.dispatch("falling")
		return
	if collision_point.x > parent.global_position.x:
		parent.is_facing_right = true
	else:
		parent.is_facing_right = false

func exit() -> void:
	super.exit()
	parent.flip_h_lock = false