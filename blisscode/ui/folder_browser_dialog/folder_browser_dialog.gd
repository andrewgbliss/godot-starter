class_name FolderBrowserDialog extends Node2D

@export_group("UI")
@export var panel: Panel
@export var folder_list: ItemList
@export var select_button: Button
@export var close_button: Button
@export var path_edit: TextEdit

var current_path: String = ""
var root_path: String = "D://"
var selected_path: String = ""

signal folder_selected(path: String)
signal dialog_closed()

func _ready():
	panel.hide()
	call_deferred("_after_ready")

func _after_ready():
	select_button.pressed.connect(_on_select_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	folder_list.item_selected.connect(_on_item_selected)
	folder_list.item_activated.connect(_on_item_activated)
	path_edit.text_changed.connect(_on_path_text_changed)
	
	# Initialize with root path
	set_root_path(root_path)

func show_dialog():
	panel.show()

func hide_dialog():
	panel.hide()

func set_root_path(path: String):
	root_path = _normalize_path(path)
	current_path = root_path
	_navigate_to_path(root_path)

func _normalize_path(path: String) -> String:
	# Normalize path separators and remove trailing slashes
	path = path.replace("\\", "/")
	while path.ends_with("/") and path.length() > 1:
		path = path.substr(0, path.length() - 1)
	return path

func _navigate_to_path(path: String):
	path = _normalize_path(path)
	
	if not DirAccess.dir_exists_absolute(path):
		print("Path does not exist: ", path)
		return
	
	current_path = path
	_update_path_edit()
	_populate_folder_list(path)

func _populate_folder_list(path: String):
	folder_list.clear()
	
	var dir = DirAccess.open(path)
	if not dir:
		print("Failed to open directory: ", path)
		return
	
	# Add parent directory option (if not at root)
	var normalized_root = _normalize_path(root_path)
	if path != normalized_root:
		var parent_path = _normalize_path(path.get_base_dir())
		if parent_path != "" and parent_path != path:
			folder_list.add_item("../", null, false)
			folder_list.set_item_metadata(folder_list.get_item_count() - 1, parent_path)
	
	# List directories first
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var dirs = []
	var files = []
	
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		
		# Use proper path joining
		var full_path = path
		if not path.ends_with("/"):
			full_path += "/"
		full_path += file_name
		full_path = _normalize_path(full_path)
		
		if dir.current_is_dir():
			dirs.append({"name": file_name, "path": full_path, "is_dir": true})
		else:
			files.append({"name": file_name, "path": full_path, "is_dir": false})
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	# Sort directories and files
	dirs.sort_custom(func(a, b): return a.name < b.name)
	files.sort_custom(func(a, b): return a.name < b.name)
	
	# Add directories
	for dir_info in dirs:
		var index = folder_list.add_item("📁 " + dir_info.name, null, false)
		folder_list.set_item_metadata(index, dir_info.path)
	
	# Add files
	for file_info in files:
		var index = folder_list.add_item("📄 " + file_info.name, null, false)
		folder_list.set_item_metadata(index, file_info.path)

func _on_item_selected(index: int):
	var path = folder_list.get_item_metadata(index)
	if path:
		selected_path = path

func _on_item_activated(index: int):
	var path = folder_list.get_item_metadata(index)
	if path:
		# Check if it's a directory
		if DirAccess.dir_exists_absolute(path):
			_navigate_to_path(path)
		else:
			# It's a file, select it
			selected_path = path

func _on_path_text_changed():
	# Allow manual path editing, but don't navigate until Enter is pressed
	pass

func _update_path_edit():
	if path_edit:
		path_edit.text = current_path

func _on_select_button_pressed():
	if selected_path != "":
		folder_selected.emit(selected_path)
	else:
		# If nothing selected, use current path
		folder_selected.emit(current_path)

func _on_close_button_pressed():
	dialog_closed.emit()
	queue_free()

func get_selected_path() -> String:
	return selected_path if selected_path != "" else current_path

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			if path_edit.has_focus():
				var new_path = path_edit.text.strip_edges()
				var normalized_new_path = _normalize_path(new_path)
				if normalized_new_path != current_path:
					_navigate_to_path(normalized_new_path)
