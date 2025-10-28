class_name DeathState extends AnimationState

func process_frame(_delta: float):
	super.process_frame(_delta)
	parent.die()
