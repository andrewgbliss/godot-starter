class_name ActionPlayer extends Node

@export var agent: Node
@export var blackboard: ActionBlackboard
@export var root_node: Node
@export var one_shot: bool = false

var current_child_index: int = 0
var running_child: Action = null
var is_running: bool = false
var has_entered: bool = false

func _ready():
	if blackboard == null:
		blackboard = ActionBlackboard.new()
		add_child(blackboard)
	if not root_node:
		print("No root node found")
		return

	_assign_to_tree(root_node)

func _assign_to_tree(node: Node):
	if node is Action:
		node.blackboard = blackboard
		node.agent = agent

	for child in node.get_children():
		_assign_to_tree(child)

func _process(delta: float) -> void:
	if not is_running:
		return
	if root_node:
		if not has_entered:
			root_node.enter()
			has_entered = true
			
		var result = root_node.process(delta)
		if result != Action.Status.RUNNING:
			root_node.exit()
			if one_shot:
				stop()
			else:
				root_node.enter()

func start() -> void:
	is_running = true
	has_entered = false

func stop() -> void:
	is_running = false
	has_entered = false

func save():
	return blackboard.save()

func restore(new_data):
	blackboard.restore(new_data)
