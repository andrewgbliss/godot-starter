extends Node

@export var user_profiles: Array[UserProfile] = []

var current_user_profile_index: int = 0

func _ready():
	restore()

func get_current_user_profile():
	return get_user_profile(current_user_profile_index)

func get_user_profile(user_profile_index: int):
	return user_profiles[user_profile_index]

func select_user_profile(user_profile_index: int):
	current_user_profile_index = user_profile_index
	var user_profile = get_current_user_profile()
	if user_profile.character_skins.size() == 0:
		GameManager.game_character_create()
	else:
		GameManager.game_start()

func save():
	for i in range(user_profiles.size()):
		var user_profile = user_profiles[i]
		user_profile.save()
		var path = "user://user_profile_" + str(i) + ".json"
		FilesUtil.save(path, user_profile.save())

func restore():
	for i in range(user_profiles.size()):
		var path = "user://user_profile_" + str(i) + ".json"
		var data = FilesUtil.restore(path)
		if data != null:
			user_profiles[i].restore(data)
