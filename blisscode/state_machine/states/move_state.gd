class_name MoveState extends State

func process_physics(delta: float) -> void:
	var direction = parent.controls.get_movement_direction()
	parent.move(direction, delta)
