@tool
class_name PlayerControls extends CharacterControls

@export var state_machine: StateMachine
@export var handle_weapon_belt: bool = true

@export_group("Debug")
@export var aim_sprite: Sprite2D
@export var show_aim_sprite: bool = true
@export var touch_sprite: Sprite2D
@export var show_touch_sprite: bool = true

var cooldown_left_hand = false
var cooldown_right_hand = false
var attack_rate_time_elapsed_left_hand = 0
var attack_rate_time_elapsed_right_hand = 0
var attack_rate_left_hand = 0
var attack_rate_right_hand = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super ()
	double_tap_timer = Timer.new()
	double_tap_timer.one_shot = true
	double_tap_timer.wait_time = double_tap_time
	double_tap_timer.connect("timeout", _on_double_tap_timeout)
	add_child(double_tap_timer)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		if parent.is_on_floor():
			state_machine.dispatch("dash")
		else:
			state_machine.dispatch("dash_air")
	if event.is_action_pressed("jump"):
		parent.jump()
		if parent.is_on_floor():
			state_machine.dispatch("jump")
		else:
			state_machine.dispatch("jump_air")

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if event is InputEventScreenTouch and event.double_tap and GameManager.user_config.attack_type == UserConfig.AttackType.TOUCH:
		touch_position = to_world_position(event.position)
		#_attack_right_hand()
	elif event is InputEventScreenDrag:
		touch_position = to_world_position(event.position)
		if touch_sprite != null:
			touch_sprite.global_position = touch_position
		is_touching = true
	elif event is InputEventScreenTouch and event.pressed:
		touch_position = to_world_position(event.position)
		if touch_sprite != null:
			touch_sprite.global_position = touch_position
		if show_touch_sprite and touch_sprite != null:
			touch_sprite.show()
		is_touching = true
	elif event is InputEventScreenTouch and not event.pressed:
		touch_position = Vector2.ZERO
		if touch_sprite != null:
			touch_sprite.hide()
			touch_sprite.global_position = touch_position
		is_touching = false

	if handle_weapon_belt:
		# if 1 through 0 on the top keyboard then equip from weapon belt to left hand
		# if left shift is held, equip to right hand instead
		if event is InputEventKey and event.pressed and event.keycode >= 49 and event.keycode <= 57:
			var slot_type = Equipment.EquipmentSlotType.LeftHand
			if Input.is_action_pressed("run"):
				slot_type = Equipment.EquipmentSlotType.RightHand
			parent.character.equipment.equip(parent.character.weapon_belt.get_slot(event.keycode - 49), slot_type)
		
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_update_aim_sprite()
	_double_tap_dash()
	if GameManager.user_config.attack_type == UserConfig.AttackType.TOUCH:
		if is_touching:
			simulate_button_press("attack_left_hand")

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	attack_rate_time_elapsed_left_hand += delta
	if attack_rate_time_elapsed_left_hand <= attack_rate_left_hand:
		cooldown_left_hand = true
	else:
		cooldown_left_hand = false
		attack_rate_time_elapsed_right_hand += delta
	if attack_rate_time_elapsed_right_hand <= attack_rate_right_hand:
		cooldown_right_hand = true
	else:
		cooldown_right_hand = false
	attack()

func attack():
	if parent.controls.is_attacking_left_hand():
		attack_left_hand()
	if parent.controls.is_attacking_right_hand():
		attack_right_hand()

func attack_left_hand():
	if cooldown_left_hand:
		return
	if parent.character and parent.character.equipment:
		var left_hand = parent.character.equipment.left_hand
		if left_hand is RangedWeapon:
			attack_rate_left_hand = left_hand.attack_rate
			attack_rate_time_elapsed_left_hand = 0
			attack_ranged_weapon(left_hand, parent.controls.get_aim_direction())

func attack_right_hand():
	if cooldown_right_hand:
		return
	if parent.character and parent.character.equipment:
		var right_hand = parent.character.equipment.right_hand
		if right_hand is RangedWeapon:
			attack_rate_right_hand = right_hand.attack_rate
			attack_rate_time_elapsed_right_hand = 0
			attack_ranged_weapon(right_hand, parent.controls.get_aim_direction())

func attack_ranged_weapon(item: RangedWeapon, direction: Vector2):
	if (!item.unlimited_ammo and item.ammo <= 0):
		return
	if item.screen_shake_amount > 0.0:
		ScreenShake.apply_shake(item.screen_shake_amount, 2.0, 10.0)
	if item.spread == 1:
		if not item.unlimited_ammo:
			item.ammo -= 1
		# Single projectile - normal behavior
		SpawnManager.spawn_projectile(item.projectile, parent.global_position, direction)
	else:
		# Multiple projectiles with spread
		for i in range(item.spread):
			var spread_offset = 0.0
			if item.spread > 1:
				# Calculate spread offset based on projectile index
				var half_spread = (item.spread - 1) * 0.5
				spread_offset = (i - half_spread) * item.spread_angle
			
			# Calculate spread direction
			var spread_direction = direction.rotated(spread_offset)
			
			# Calculate spread position (offset perpendicular to direction)
			var perpendicular = Vector2(-direction.y, direction.x)
			var spread_position = parent.global_position + (perpendicular * spread_offset * 50.0) # 50.0 is a distance multiplier
			
			if not item.unlimited_ammo:
				item.ammo -= 1
			SpawnManager.spawn_projectile(item.projectile, spread_position, spread_direction)
	
  # TODO: Implement ammo changed signal
	# parent.ammo_changed.emit(item, item.ammo)

func _double_tap_dash():
	if parent.paralyzed:
		return
	var current_movement = ""
	if is_action_just_pressed("move_left"):
		current_movement = "move_left"
	elif is_action_just_pressed("move_right"):
		current_movement = "move_right"
	elif is_action_just_pressed("move_up"):
		current_movement = "move_up"
	elif is_action_just_pressed("move_down"):
		current_movement = "move_down"
		
	if current_movement != "":
		match current_movement:
			"move_left":
				double_tap_direction = DOUBLE_TAP_DIRECTION.LEFT
			"move_right":
				double_tap_direction = DOUBLE_TAP_DIRECTION.RIGHT
			"move_up":
				double_tap_direction = DOUBLE_TAP_DIRECTION.UP
			"move_down":
				double_tap_direction = DOUBLE_TAP_DIRECTION.DOWN
		if double_tap_timer.is_stopped():
			last_pressed_movement = current_movement
			double_tap_count = 1
			double_tap_timer.start()
		else:
			if double_tap_count == 1 and current_movement == last_pressed_movement:
				simulate_button_press("dash")
				double_tap_count = 0
				double_tap_timer.stop()

func _on_double_tap_timeout():
	double_tap_count = 0

func get_double_tap_direction():
	match double_tap_direction:
		DOUBLE_TAP_DIRECTION.LEFT:
			return Vector2.LEFT
		DOUBLE_TAP_DIRECTION.RIGHT:
			return Vector2.RIGHT
		DOUBLE_TAP_DIRECTION.UP:
			return Vector2.UP
		DOUBLE_TAP_DIRECTION.DOWN:
			return Vector2.DOWN

func simulate_button_press(action_name: String):
	var press = InputEventAction.new()
	press.action = action_name
	press.pressed = true
	Input.parse_input_event(press)

	var release = InputEventAction.new()
	release.action = action_name
	release.pressed = false
	Input.parse_input_event(release)

func _update_aim_sprite():
	if aim_sprite != null:
		aim_sprite.global_position = parent.global_position + get_aim_direction() * 50
		if show_aim_sprite:
			aim_sprite.show()
		else:
			aim_sprite.hide()

func get_aim_direction():
	if GameManager.user_config.aim_type == UserConfig.AimType.DEFAULT:
		return get_default_aim_direction()
	elif GameManager.user_config.aim_type == UserConfig.AimType.TOUCH:
		return get_touch_aim_direction()
	elif GameManager.user_config.aim_type == UserConfig.AimType.MOUSE:
		return get_mouse_aim_direction()
	elif GameManager.user_config.aim_type == UserConfig.AimType.KEYBOARD:
		return get_keyboard_aim_direction()
	elif GameManager.user_config.aim_type == UserConfig.AimType.JOYSTICK:
		return get_joystick_aim_direction()

func get_default_aim_direction():
	return get_facing_direction().normalized()

func get_touch_aim_direction():
	if touch_position == Vector2.ZERO:
		return get_facing_direction()
	var direction = touch_position - parent.global_position
	return direction.normalized()

func get_mouse_aim_direction():
	var direction = parent.get_global_mouse_position() - parent.global_position
	return direction.normalized()

func get_keyboard_aim_direction():
	var direction: Vector2 = Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	).normalized()
	if direction.length() < 0.1:
		return get_facing_direction()
	return direction

func get_joystick_aim_direction():
	var direction: Vector2 = Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	).normalized()
	if direction.length() < 0.1:
		return get_facing_direction()
	return direction

func get_movement_direction():
	if parent.paralyzed:
		return Vector2.ZERO
	if GameManager.user_config.movement_type == UserConfig.MovementType.DEFAULT:
		return get_default_movement_direction()
	elif GameManager.user_config.movement_type == UserConfig.MovementType.MOUSE:
		return get_mouse_movement_direction()
	elif GameManager.user_config.movement_type == UserConfig.MovementType.KEYBOARD:
		return get_keyboard_movement_direction()
	elif GameManager.user_config.movement_type == UserConfig.MovementType.JOYSTICK:
		return get_joystick_movement_direction()
	elif GameManager.user_config.movement_type == UserConfig.MovementType.TOUCH:
		return get_touch_movement_direction()

func get_default_movement_direction():
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return direction

func get_mouse_movement_direction():
	var direction = parent.get_global_mouse_position() - parent.global_position
	return direction.normalized()

func get_keyboard_movement_direction():
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return direction

func get_joystick_movement_direction():
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	return direction

func get_touch_movement_direction():
	if touch_position == Vector2.ZERO:
		return Vector2.ZERO
	var direction = touch_position - parent.global_position
	return direction.normalized()

func is_walking() -> bool:
	return not Input.is_action_pressed("run") and get_movement_direction() != Vector2.ZERO

func is_running() -> bool:
	return Input.is_action_pressed("run") and get_movement_direction() != Vector2.ZERO
		
func is_attacking_left_hand():
	return Input.is_action_pressed("attack_left_hand")

func is_attacking_right_hand():
	return Input.is_action_pressed("attack_right_hand")

func is_action_just_pressed(action_name) -> bool:
	return Input.is_action_just_pressed(action_name)

func is_action_pressed(action_name) -> bool:
	return Input.is_action_pressed(action_name)
	
func is_movement_pressed() -> bool:
	return get_movement_direction() != Vector2.ZERO

func to_world_position(screen_position: Vector2) -> Vector2:
	var canvas_transform = get_viewport().get_canvas_transform()
	var world_position = canvas_transform.affine_inverse() * screen_position
	return world_position
