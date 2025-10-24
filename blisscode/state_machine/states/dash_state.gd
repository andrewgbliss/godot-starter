class_name DashState extends State

var dash_time_elapsed: float = 0
var direction = Vector2.ZERO

func enter():
	super ()
	dash_time_elapsed = 0
	if parent.controls.double_tap_direction != parent.controls.DOUBLE_TAP_DIRECTION.NONE:
		direction = parent.controls.get_double_tap_direction()
		parent.controls.double_tap_direction = parent.controls.DOUBLE_TAP_DIRECTION.NONE
	else:
		direction = parent.controls.get_aim_direction()
	parent.stop()
	parent.velocity += direction * parent.character.speed * parent.character.dash_speed_multiplier

func process_physics(delta: float):
	parent.move(direction, delta)
	dash_time_elapsed += delta
	if dash_time_elapsed >= parent.character.dash_time:
		if parent.character.stop_on_end:
			parent.stop()
		state_machine.dispatch("move")
