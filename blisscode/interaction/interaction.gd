class_name Interaction extends Node2D

# In range means you are within the vicinty of the interaction
# Interact means you are within distance to interact
# Collision means you have collided with the interaction

# Example: You can read a sign from a distance, you can interact by touching the sign, and collide with it

@export_group("Areas")
@export var interact_area: Area2D
@export var in_range_area: Area2D
@export var collision_area: Area2D

@export_group("Actions")
@export var on_ready_actions: ActionPlayer
@export var in_range_actions: ActionPlayer
@export var out_of_range_actions: ActionPlayer
@export var mouse_over_actions: ActionPlayer
@export var mouse_out_actions: ActionPlayer
@export var mouse_click_actions: ActionPlayer
@export var keyboard_take_actions: ActionPlayer
@export var collision_actions: ActionPlayer

@export_group("Flags")
@export var use_keyboard_take: bool = false
@export var use_mouse: bool = false
@export var use_collision: bool = false

var in_range: bool = false
var local_collision_pos: Vector2
var keyboard_take_body
var on_ready_body
var in_range_body
var collision_body
var mouse_over_body
var mouse_click_body
var has_interacted = false
var is_mouse_over = false
var enabled = true

func _ready():
	if in_range_area:
		in_range_area.body_entered.connect(_on_in_range_body_entered)
		in_range_area.body_exited.connect(_on_in_range_body_exited)
	if interact_area:
		interact_area.body_entered.connect(_on_body_entered)
		interact_area.input_event.connect(_on_input_event)
		interact_area.mouse_entered.connect(_on_mouse_entered)
		interact_area.mouse_exited.connect(_on_mouse_exited)
	if collision_area:
		collision_area.body_entered.connect(_on_body_entered)
	call_deferred("_after_ready")

func _after_ready():
	if on_ready_actions != null:
		on_ready_body = get_tree().get_first_node_in_group("player")
		on_ready_actions.blackboard.set_var("body", on_ready_body)
		on_ready_actions.blackboard.set_var("interaction_position", global_position)
		on_ready_actions.blackboard.set_var("collision_position", global_position)
		on_ready_actions.blackboard.set_var("in_range", in_range)
		on_ready_actions.start()

func _input(event):
	if not enabled or not use_keyboard_take or keyboard_take_actions == null:
		return
	if event is InputEventKey:
		if event.is_action_pressed("take"):
			keyboard_take_body = get_tree().get_first_node_in_group("player")
			keyboard_take_actions.blackboard.set_var("body", keyboard_take_body)
			keyboard_take_actions.blackboard.set_var("interaction_position", global_position)
			keyboard_take_actions.blackboard.set_var("collision_position", global_position)
			keyboard_take_actions.blackboard.set_var("in_range", in_range)
			keyboard_take_actions.start()

func _on_input_event(_viewport, _event, _shape_idx):
	if not enabled or not use_mouse or mouse_click_actions == null:
		return
	if Input.is_action_just_pressed("take"):
		mouse_click_body = get_tree().get_first_node_in_group("player")
		mouse_click_actions.blackboard.set_var("body", mouse_click_body)
		mouse_click_actions.blackboard.set_var("interaction_position", global_position)
		mouse_click_actions.blackboard.set_var("collision_position", global_position)
		mouse_click_actions.blackboard.set_var("in_range", in_range)
		mouse_click_actions.start()

func _on_mouse_entered():
	if not enabled or not use_mouse:
		return
	is_mouse_over = true
	mouse_over_body = get_tree().get_first_node_in_group("player")
	if mouse_over_actions != null:
		mouse_over_actions.blackboard.set_var("body", mouse_over_body)
		mouse_over_actions.blackboard.set_var("interaction_position", global_position)
		mouse_over_actions.blackboard.set_var("collision_position", get_global_mouse_position())
		mouse_over_actions.blackboard.set_var("in_range", in_range)
		mouse_over_actions.start()

func _on_mouse_exited():
	if not enabled or not use_mouse:
		return
	is_mouse_over = false
	if mouse_out_actions != null:
		mouse_out_actions.blackboard.set_var("body", null)
		mouse_out_actions.blackboard.set_var("interaction_position", null)
		mouse_out_actions.blackboard.set_var("collision_position", null)
		mouse_out_actions.blackboard.set_var("in_range", in_range)
		mouse_out_actions.start()

func _on_in_range_body_entered(body):
	if not enabled:
		return
	in_range = true
	in_range_body = body
	if in_range_actions != null:
		in_range_actions.blackboard.set_var("body", in_range_body)
		in_range_actions.blackboard.set_var("interaction_position", global_position)
		in_range_actions.blackboard.set_var("in_range", in_range)
		in_range_actions.start()

func _on_in_range_body_exited(_body):
	if not enabled:
		return
	in_range = false
	in_range_body = null
	has_interacted = false
	if out_of_range_actions != null:
		out_of_range_actions.blackboard.set_var("body", in_range_body)
		out_of_range_actions.blackboard.set_var("interaction_position", null)
		out_of_range_actions.blackboard.set_var("in_range", in_range)
		out_of_range_actions.start()

func _on_body_entered(body):
	if not enabled:
		return
	if not use_collision:
		return
	collision_body = body
	var collision_position = local_collision_pos + get_position()
	if collision_actions != null:
		collision_actions.blackboard.set_var("body", collision_body)
		collision_actions.blackboard.set_var("interaction_position", global_position)
		collision_actions.blackboard.set_var("collision_position", collision_position)
		collision_actions.blackboard.set_var("in_range", in_range)
		collision_actions.start()

func enable():
	enabled = true

func disable():
	enabled = false
	if on_ready_actions:
		on_ready_actions.stop()
	if collision_actions:
		collision_actions.stop()
	if in_range_actions:
		in_range_actions.stop()
	if out_of_range_actions:
		out_of_range_actions.stop()
	if mouse_over_actions:
		mouse_over_actions.stop()
	if mouse_out_actions:
		mouse_out_actions.stop()
	if mouse_click_actions:
		mouse_click_actions.stop()
	if keyboard_take_actions:
		keyboard_take_actions.stop()
