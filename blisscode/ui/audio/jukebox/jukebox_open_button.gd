class_name JukeboxOpenButton extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	GameUi.jukebox.show_panel()
