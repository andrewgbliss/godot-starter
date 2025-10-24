class_name AirState extends MoveState

func process_physics(delta: float) -> void:
	if parent.is_on_floor():
		state_machine.dispatch("land")
		return
	var direction = parent.controls.get_movement_direction()
	parent.move(direction, delta)
