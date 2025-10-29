class_name JumpState extends MoveState

func enter() -> void:
	super.enter()
	parent.jump()

func process_physics(delta: float) -> void:
	var direction = parent.controls.get_movement_direction()
	parent.move(direction, delta)
	if parent.is_on_floor():
		state_machine.dispatch("land")
		return
	if parent.is_wall_clinging():
		state_machine.dispatch("wall_cling")
		return
	if parent.is_falling():
		state_machine.dispatch("falling")
		return
