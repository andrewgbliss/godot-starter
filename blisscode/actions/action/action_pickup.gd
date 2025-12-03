class_name ActionPickup extends Action

@export var interaction_item: InteractionItem
@export var body_var: StringName = &"body"

func process(_delta: float) -> Status:
	var body = blackboard.get_var(body_var)
	if body and body.has_method("item_pickup"):
		if interaction_item and interaction_item.item:
			body.item_pickup(interaction_item.item)
		return Status.SUCCESS
	return Status.FAILURE
