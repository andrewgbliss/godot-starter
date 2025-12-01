class_name MenuGameStartButton extends Button

@export var user_profile_index: int

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
func _on_button_pressed() -> void:
	UserManager.select_user_profile(user_profile_index)
