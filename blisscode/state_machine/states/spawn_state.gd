class_name SpawnState extends AnimationState

func enter() -> void:
	super.enter()
	parent.spawn()

func process_frame(_delta: float) -> void:
	if is_animation_finished:
		dispatch()
