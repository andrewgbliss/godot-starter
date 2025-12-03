class_name ActionPrint extends Action

@export var text: String

func process(_delta: float) -> Status:
	print(text)
	return Status.SUCCESS
