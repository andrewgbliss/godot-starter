class_name ActionShowNode2D extends Action

@export var node: Node2D

func process(_delta: float) -> Status:
	node.show()
	return Status.SUCCESS