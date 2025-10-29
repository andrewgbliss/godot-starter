class_name Hitbox extends Area2D

@export var damage: int = 1
@export var facing_left_position: Vector2 = Vector2.ZERO
@export var facing_right_position: Vector2 = Vector2.ZERO
@export var animated_sprite: AnimatedSprite2D

var parent: CharacterController

func _ready() -> void:
	parent = get_parent()
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if animated_sprite:
		if animated_sprite.flip_h:
			position = facing_left_position
		else:
			position = facing_right_position

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterController:
		body.take_damage(damage)
	if body is RigidBody2D:
		# Get the collision point from the area detection
		var collision_point = get_collision_point(body)
		apply_knockback(body, collision_point)

func get_collision_point(body: Node2D) -> Vector2:
	# Try to get collision point from area detection
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, body.global_position)
	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	# Fallback to body position if no collision point found
	return body.global_position

func apply_knockback(rigidbody: RigidBody2D, collision_point: Vector2) -> void:
	# Direction AWAY from hitbox - flip it
	var direction = (global_position - collision_point).normalized()
	var impulse = direction * parent.character.push_force * 2.0
	# print("Knockback direction: ", direction, " impulse: ", impulse)
	rigidbody.apply_central_impulse(impulse)
