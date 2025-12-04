class_name ActionWait extends Action

@export var wait_time: float = 1.0

var elapsed_time: float = 0.0

func process(delta: float) -> Status:
	elapsed_time += delta
	if elapsed_time >= wait_time:
		return Status.SUCCESS
	return Status.RUNNING