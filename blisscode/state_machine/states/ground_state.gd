class_name GroundState extends MoveState

func process_physics(delta: float) -> void:
	if parent.velocity.y > 0 and not parent.is_on_floor():
		state_machine.dispatch("falling")
		return
	var direction = parent.controls.get_movement_direction()
	parent.move(direction, delta)
