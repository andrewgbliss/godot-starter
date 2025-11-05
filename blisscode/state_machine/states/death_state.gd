class_name DeathState extends AnimationState

func enter() -> void:
	super.enter()
	parent.die(false)

func process_frame(_delta: float) -> void:
	if is_animation_finished:
		parent.hide()
		dispatch()
