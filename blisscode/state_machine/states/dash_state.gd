class_name DashState extends AnimationState

var dash_time_elapsed: float = 0

var direction = Vector2.ZERO

func enter():
	super ()
	dash_time_elapsed = 0
	direction = parent.dash()
	play_animation()

func process_physics(delta: float):
	parent.move(direction, delta)
	dash_time_elapsed += delta
	if dash_time_elapsed >= parent.character.dash_time:
		if parent.character.stop_on_end:
			parent.stop()
		if parent.is_on_floor():
			state_machine.dispatch("dash_stop_ground")
		else:
			state_machine.dispatch("dash_stop_falling")
