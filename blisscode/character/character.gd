class_name Character extends Resource

@export var character_sheet: CharacterSheet
@export var inventory: Inventory
@export var equipment: Equipment
@export var weapon_belt: WeaponBelt

@export_group("Movement")
@export var speed: float = 100.0
@export var walk_multiplier: float = 1.0
@export var run_multiplier: float = 3.0
@export var crouch_multiplier: float = 0.5
@export var jump_force: float = 100.0
@export var has_navigation: bool = false
@export var allow_y_controls: bool = false
@export var movement_percent: float = 1.0
@export var movement_lerp: bool = true

@export_group("Physics")
@export var gravity_percent: float = 1.0
@export var acceleration: float = 50.0
@export var friction: float = 15.0
@export var push_force: float = 300.0
@export var knockback_force: float = 200.0
@export var knockback_resistance: float = 0.5
@export var max_velocity: Vector2 = Vector2(1000.0, 1000.0)

@export_group("Dash")
@export var dash_time: float = 0.5
@export var dash_speed_multiplier: float = 10.0
@export var stop_on_end: bool = false

@export_group("Slide")
@export var slide_time: float = 0.5
@export var slide_speed_multiplier: float = 10.0
@export var slide_stop_on_end: bool = false
