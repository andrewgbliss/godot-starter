class_name FlameThrower extends Node2D

@onready var flame : Node2D = $Flame

var is_active: bool = false

func _ready():
	flame.hide()

func start():
	is_active = true
	flame.show()
