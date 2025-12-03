class_name ActionSequence extends Action

var current_child_index: int = 0
var running_child: Action = null # Track which child is currently running

func enter():
	current_child_index = 0 # Reset sequence when it starts
	running_child = null

func process(delta: float) -> Status:
	while current_child_index < get_child_count():
		var child = get_child(current_child_index)

		if child is Action: # Ensure it's a behavior node
			if running_child != child: # Call enter() only if it's a new child
				child.enter()
				running_child = child

			var result = child.process(delta)

			if result == Action.Status.FAILURE:
				child.exit()
				running_child = null
				return Action.Status.FAILURE # Sequence fails if any child fails
			elif result == Action.Status.RUNNING:
				return Action.Status.RUNNING # Keep running the current child
			else: # SUCCESS
				child.exit()
				running_child = null
				current_child_index += 1 # Move to the next child
		else:
			# Skip non-BTNode children
			current_child_index += 1

	# Reset for next time this sequence is run
	current_child_index = 0
	return Action.Status.SUCCESS # If all children succeed, return SUCCESS

func exit():
	if running_child != null:
		running_child.exit()
	running_child = null
