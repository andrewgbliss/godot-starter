class_name PlayerSave extends Resource

enum PlayerType {
  SIDE,
  TOPDOWN
}

@export var player_type: PlayerType = PlayerType.SIDE

enum PlayerSize {
  SMALL, # 16x16
  MEDIUM, # 32x32
  LARGE, # 64x64
  XLARGE, # 128x128
}

@export var player_size: PlayerSize = PlayerSize.MEDIUM

@export var player_name: String = "Player"
@export var sprite_frames: SpriteFrames
