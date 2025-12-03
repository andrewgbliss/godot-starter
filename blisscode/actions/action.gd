class_name Action extends Node

enum Status {RUNNING, SUCCESS, FAILURE}

@export var action_name: String = "action"

var blackboard: ActionBlackboard
var agent

func enter():
	pass # Called when the node starts execution

func process(_delta: float) -> Status:
	return Status.SUCCESS # Each node overrides this

func exit():
	pass # Called when the node stops execution
