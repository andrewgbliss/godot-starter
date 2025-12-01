class_name CharacterSkin extends Resource

@export var character_skin_name: String = "silo"

enum CharacterSkinType {
  SIDE,
  TOPDOWN
}

@export var character_type: CharacterSkinType = CharacterSkinType.SIDE

enum CharacterSkinSize {
  SMALL,
  MEDIUM,
  LARGE,
  XLARGE,
}

@export var character_size: CharacterSkinSize = CharacterSkinSize.MEDIUM
@export var sprite_frames: SpriteFrames
@export var character_body: PackedScene

# Name character skin like this: character_side_small_kungfury
# character_type: side or topdown
# character_size: small, medium, large, xlarge
# character_skin: kungfury, silo, tom, snowman, santa
func get_skin_name() -> String:
	var type = "side"
	var size = "medium"
	match character_type:
		CharacterSkinType.SIDE:
			type = "side"
		CharacterSkinType.TOPDOWN:
			type = "topdown"
	match character_size:
		CharacterSkinSize.SMALL:
			size = "small"
		CharacterSkinSize.MEDIUM:
			size = "medium"
		CharacterSkinSize.LARGE:
			size = "large"
		CharacterSkinSize.XLARGE:
			size = "xlarge"
	return "character_" + type + "_" + size + "_" + character_skin_name.to_lower()
