class_name RayCast2DAdvanced extends RayCast2D

@export var animated_sprite: AnimatedSprite2D
@export var facing_left_position: Vector2 = Vector2.ZERO
@export var facing_right_position: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if animated_sprite:
		if animated_sprite.flip_h:
			position = facing_left_position
		else:
			position = facing_right_position