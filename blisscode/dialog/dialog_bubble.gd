class_name DialogBubble extends Node2D

@export var dialog_text: Label
@export var animation_player: AnimationPlayer
@export var typewriter_style: bool = true

signal dialogue_shown
signal dialogue_hidden

var is_showing: bool = false

# func _input(_event: InputEvent) -> void:
# 	if dialog_text.visible and Input.is_anything_pressed():
# 		hide_dialog()

func show_dialog(text: String, duration: float = 3.0):
	if is_showing:
		return
	is_showing = true
	dialogue_shown.emit()
	dialog_text.text = text
	animation_player.play("show_dialog")
	if not typewriter_style:
		dialog_text.visible_ratio = 1.0
	await get_tree().create_timer(duration).timeout
	hide_dialog()

func hide_dialog():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	dialogue_hidden.emit()
	is_showing = false
