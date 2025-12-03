class_name ActionDisableInteraction extends Action

@export var interaction: Interaction

func process(_delta: float) -> Status:
	interaction.disable()
	return Status.SUCCESS
