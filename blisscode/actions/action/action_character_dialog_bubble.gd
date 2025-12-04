class_name ActionCharacterDialogBubble extends Action

@export var character_spawner: CharacterSpawner
@export var character_controller: CharacterController

@export var show: bool = true
@export var text: String

func _ready():
	character_spawner.spawned.connect(on_character_spawned)

func on_character_spawned(cc: CharacterController):
	character_controller = cc

func enter():
	if not character_controller:
		return
	if show:
		character_controller.dialog_bubble.show_dialog(text)
	else:
		character_controller.dialog_bubble.hide_dialog()

func process(_delta: float) -> Status:
	if not character_controller:
		return Status.SUCCESS
	if character_controller.dialog_bubble.is_showing:
		return Status.RUNNING
	return Status.SUCCESS
