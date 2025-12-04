class_name ActionStartFlameThrower extends Action

@export var flame_thrower: FlameThrower

func enter():
	flame_thrower.start()

func process(_delta: float) -> Status:
	# if flame_thrower.is_active:
	# 	return Status.RUNNING
	return Status.SUCCESS
