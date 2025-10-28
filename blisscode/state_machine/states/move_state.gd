class_name MoveState extends AnimationState

func process_input(event: InputEvent) -> void:
	if parent.paralyzed:
		return
	if event.is_action_pressed("dash"):
		state_machine.dispatch("dash")
	if event.is_action_pressed("jump"):
		state_machine.dispatch("jump")
	if event.is_action_pressed("change_gravity_dir"):
		GameManager.toggle_anti_gravity()
	if event.is_action_pressed("attack_left_hand") or event.is_action_pressed("attack_right_hand"):
		_attack()

func process_physics(delta: float) -> void:
	var direction = parent.controls.get_movement_direction()
	parent.move(direction, delta)

func _attack():
	if parent.controls.is_attacking_left_hand():
		state_machine.shared_data["hand_direction"] = "left"
		state_machine.dispatch("attack")
	if parent.controls.is_attacking_right_hand():
		state_machine.shared_data["hand_direction"] = "right"
		state_machine.dispatch("attack")
