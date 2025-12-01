extends Node

@export var character_skins: Array[CharacterSkin] = []

func get_character_skin(character_size: CharacterSkin.CharacterSkinSize, character_type: CharacterSkin.CharacterSkinType, character_skin_name: String) -> CharacterSkin:
	# print("get_character_skin: ", character_size, character_type, character_skin_name)
	for character_skin in character_skins:
		if character_skin.character_size == character_size and character_skin.character_type == character_type and character_skin.character_skin_name.to_lower() == character_skin_name.to_lower():
			return character_skin
	return null

func find_character_skin(character_size: String, character_type: String, character_skin_name: String):
	# print("find_character_skin: ", character_size, character_type, character_skin_name)
	var size = CharacterSkin.CharacterSkinSize.SMALL
	var type = CharacterSkin.CharacterSkinType.SIDE
	match character_size:
		"small":
			size = CharacterSkin.CharacterSkinSize.SMALL
		"medium":
			size = CharacterSkin.CharacterSkinSize.MEDIUM
		"large":
			size = CharacterSkin.CharacterSkinSize.LARGE
		"xlarge":
			size = CharacterSkin.CharacterSkinSize.XLARGE
	match character_type:
		"topdown":
			type = CharacterSkin.CharacterSkinType.TOPDOWN
		"side":
			type = CharacterSkin.CharacterSkinType.SIDE
	return get_character_skin(size, type, character_skin_name)

func instantiate_character_from_skin(skin: CharacterSkin, character_container: Node2D):
	var character = skin.character_body.instantiate()
	character_container.add_child(character)
	if character is CharacterController:
		character.position = Vector2.ZERO
		character.set_skin(skin.sprite_frames)
		character.paralyze()
	return character
