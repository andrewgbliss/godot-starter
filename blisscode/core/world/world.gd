class_name World extends Node2D

@export var world_name: String

var world_doors: Array[WorldDoor] = []

func _ready() -> void:
	SceneManager.hide_backdrop()
	_find_world_doors(self)
	call_deferred("_after_ready")

func _after_ready():
	if GameManager.game_config.game_state == GameConfig.GAME_STATE.GAME_RESTORE:
		_restore_spawn()
	else:
		_default_spawn()
	
	GameUi.hud.show_hud()
	
	#NotifcationsToast.show_notification("Game Ready", "Ready to start the game!")
	#NotifcationsToast.show_notification("Aint no one got you on this", "Holy shit!!!")
	
func _restore_spawn():
	UserDataStore.restore()
	GameManager.game_config.set_state(GameConfig.GAME_STATE.GAME_PLAY)
	
func _default_spawn():
	GameManager.game_config.set_state(GameConfig.GAME_STATE.GAME_PLAY)
	
func _find_world_doors(node: Node):
	if node is WorldDoor:
		world_doors.append(node)
	for child in node.get_children():
		_find_world_doors(child)

func find_world_door():
	for door in world_doors:
		if door.door_id == GameManager.game_config.to_world_door_id:
			return door
	return null

func save():
	pass
	# var data = {
	# 	"description": description,
	# 	"timestamp": Time.get_datetime_string_from_system(false, true),
	# 	"world_data": world_data
	# }
	# save_persisting_nodes(index)
	
func restore():
	pass
	# print("Restoring persisting nodes")
	# restore_persisting_nodes()
	
func _get_world_data():
	var root = get_tree().get_root()
	for node in root.get_children():
		if node is World:
			return node.save()
	return null

func get_persisting_nodes():
	var save_nodes = get_tree().get_nodes_in_group("persist")
	var node_data_arr = []
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save")
		node_data_arr.append(node_data)
	return node_data_arr

func restore_persisting_nodes(data):
	var node_data = data
	var node = get_node(node_data.get("path"))
	if node != null:
		var new_position = Vector2(node_data.get("pos_x"), node_data.get("pos_y"))
		node.position = new_position
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "path" or i == "pos_x" or i == "pos_y" or i == "input_x" or i == "input_y" or i == "movement_direction" or i == "movement_state" or i == "is_facing_right":
				continue
			node.set(i, node_data.get(i))
			
		if node.has_method("restore"):
			node.call("restore", node_data)

		if node.has_method("spawn_restore"):
			node.call("spawn_restore")

func restore_all_nodes(nodes_data: Array):
	for node_data in nodes_data:
		var node_path = node_data.get("path")
		if node_path:
			var node = get_node_or_null(node_path)
			if node != null:
				# Call custom restore method if available
				if node.has_method("restore"):
					node.call("restore", node_data)
			else:
				print("Warning: Could not find node at path: ", node_path)
