class_name Character extends Resource

enum CharacterType {
  SIDE,
  TOPDOWN
}

@export var character_type: CharacterType = CharacterType.SIDE

enum CharacterSize {
  SMALL, # 16x16
  MEDIUM, # 32x32
  LARGE, # 64x64
  XLARGE, # 128x128
}

@export var character_size: CharacterSize = CharacterSize.MEDIUM

@export var character_name: String = "Character"
@export var skin: SpriteFrames

@export var character_sheet: CharacterSheet
@export var inventory: Inventory
@export var equipment: Equipment
@export var weapon_belt: WeaponBelt
@export var physics_group: PhysicsGroup
@export var physics_group_override: PhysicsGroup

signal physics_group_override_changed

func set_physics_group_override(group: PhysicsGroup) -> void:
	physics_group_override = group
	physics_group_override_changed.emit()

func get_physics_group() -> PhysicsGroup:
	if physics_group_override:
		return physics_group_override
	return physics_group

func reset_physics_group_override() -> void:
	physics_group_override = null
	physics_group_override_changed.emit()

func get_character_key() -> String:
	var type = ""
	match character_type:
		CharacterType.SIDE:
			type = "side"
		CharacterType.TOPDOWN:
			type = "topdown"
	var size = ""
	match character_size:
		CharacterSize.SMALL:
			size = "16"
		CharacterSize.MEDIUM:
			size = "32"
		CharacterSize.LARGE:
			size = "64"
		CharacterSize.XLARGE:
			size = "128"
	return "character_" + type + "_" + size