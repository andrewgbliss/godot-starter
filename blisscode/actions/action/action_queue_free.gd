class_name ActionQueueFree extends Action

@export var node: Node

func process(_delta: float) -> Status:
	node.queue_free()
	return Status.SUCCESS