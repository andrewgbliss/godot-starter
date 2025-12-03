class_name ActionHideNode2D extends Action

@export var node: Node2D

func process(_delta: float) -> Status:
	node.hide()
	return Status.SUCCESS