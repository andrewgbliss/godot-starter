extends Control

@export var bus_idx: int = 0
@export var label_text: String = ""
@export var show_label: bool = true

@onready var label: Label = $VBoxContainer/Label
@onready var slider: Slider = $VBoxContainer/HSlider

func _ready():
	call_deferred("_after_ready")
	
func _after_ready():
	label.text = label_text
	if not show_label:
		label.hide()
	var percent = GameManager.user_config.get_volume(bus_idx)
	slider.set_value_no_signal(percent)

func _on_h_slider_value_changed(value: float):
	EventBus.audio_volume_changed.emit(bus_idx, value)
