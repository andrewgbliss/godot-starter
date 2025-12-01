class_name PlayerProfileSelectMenu extends Menu

@export var container: VBoxContainer

func _ready():
	super ()
	call_deferred("_after_ready")
	
func _after_ready():
	_build_user_profiles_list()

func _build_user_profiles_list():
	for i in range(4):
		var user_profile = UserManager.user_profiles[i]
		var hboxcontainer = HBoxContainer.new()
		var label = Label.new()
		label.text = "Player " + str(i + 1)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hboxcontainer.add_child(label)
		var menu_game_start_button = MenuGameStartButton.new()
		menu_game_start_button.user_profile_index = i
		menu_game_start_button.text = "Start" if user_profile.character_skins.size() == 0 else "Continue"
		hboxcontainer.add_child(menu_game_start_button)
		container.add_child(hboxcontainer)
