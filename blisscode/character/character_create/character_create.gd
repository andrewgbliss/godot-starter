extends Node2D

@export var character_name: String = "silo"

@export var character_container: Node2D = null
@export var camera: Camera2D = null

@export var character_type_options: OptionButton = null
@export var character_size_options: OptionButton = null
@export var character_skin_options: OptionButton = null
@export var create_button: Button = null

var current_skin: CharacterSkin = null

func _ready() -> void:
	character_type_options.item_selected.connect(_on_character_type_option_selected)
	character_size_options.item_selected.connect(_on_character_size_option_selected)
	character_skin_options.item_selected.connect(_on_character_skin_option_selected)
	create_button.pressed.connect(_on_create_button_pressed)
	call_deferred("_after_ready")

func _after_ready() -> void:
	_change_template()
	_focus_camera()

func _on_create_button_pressed() -> void:
	var skin = _get_selected_character_skin()
	if not skin:
		print("No skin selected")
		return
	var user_profile = UserManager.get_current_user_profile()
	user_profile.add_character_skin(skin)
	user_profile.set_current_character_skin(skin)
	UserManager.save()
	GameManager.game_start()

func _on_character_type_option_selected(_index: int) -> void:
	_change_template()

func _on_character_size_option_selected(_index: int) -> void:
	_change_template()

func _on_character_skin_option_selected(_index: int) -> void:
	_change_template()

func _focus_camera() -> void:
	if camera:
		camera.enabled = true
		camera.make_current()

func _change_template() -> void:
	_build_character()

func _get_selected_character_skin() -> CharacterSkin:
	var character_size = character_size_options.get_selected_id()
	var character_type = character_type_options.get_selected_id()
	var character_skin_name = character_skin_options.get_item_text(character_skin_options.get_selected_id())
	return CharacterManager.get_character_skin(character_size, character_type, character_skin_name)

func _build_character() -> void:
	for child in character_container.get_children():
		character_container.remove_child(child)
		child.queue_free()
	var skin = _get_selected_character_skin()
	if not skin:
		create_button.disabled = true
		return
	create_button.disabled = false
	CharacterManager.instantiate_character_from_skin(skin, character_container)
