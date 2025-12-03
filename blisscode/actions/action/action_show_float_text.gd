class_name ActionShowFloatText extends Action

@export var interaction_position_var: StringName = &"interaction_position"
@export var text: String
@export var offset: Vector2
@export var stay: bool = false

func process(_delta: float) -> Status:
	var interaction_position = blackboard.get_var(interaction_position_var)
	if interaction_position:
		if stay:
			SpawnManager.float_text_stay(text, interaction_position + offset)
		else:
			SpawnManager.float_text(text, interaction_position + offset)
	return Status.SUCCESS
