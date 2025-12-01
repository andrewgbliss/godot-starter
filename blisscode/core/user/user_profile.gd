class_name UserProfile extends Resource

var character_skins: Array[CharacterSkin] = []
var current_character_skin: CharacterSkin = null

func set_current_character_skin(skin: CharacterSkin):
	current_character_skin = skin
  
func add_character_skin(skin: CharacterSkin):
	character_skins.append(skin)

func save():
	var character_skin_names = []
	for character_skin in character_skins:
		character_skin_names.append(character_skin.get_skin_name())
	var data = {}
	data["character_skin_names"] = character_skin_names
	if current_character_skin:
		data["current_character_skin_name"] = current_character_skin.get_skin_name()
	else:
		data["current_character_skin_name"] = null
	return data

func restore(data):
	if data.has("character_skin_names"):
		var character_skin_names = data["character_skin_names"]
		for character_skin_name in character_skin_names:
			var parts = character_skin_name.split("_")
			var character_size = parts[2]
			var character_type = parts[1]
			var character_skin_name_part = parts[3]
			var skin = CharacterManager.find_character_skin(character_size, character_type, character_skin_name_part)
			if skin:
				character_skins.append(skin)
	if data.has("current_character_skin_name"):
		var current_character_skin_name = data["current_character_skin_name"]
		if current_character_skin_name:
			var parts = current_character_skin_name.split("_")
			var character_size = parts[2]
			var character_type = parts[1]
			var character_skin_name_part = parts[3]
			var skin = CharacterManager.find_character_skin(character_size, character_type, character_skin_name_part)
			if skin:
				set_current_character_skin(skin)
