class_name PointLight2DAdvanced extends PointLight2D

@export var daylight_level_min: float = 0.6
@export var fade_duration: float = 1.0

var _original_energy: float
var _fade_tween: Tween
var _daylight_level: float = 0.0

func _ready() -> void:
	EventBus.daylight_level_changed.connect(_on_daylight_level_changed)
	_original_energy = energy
	energy = 0.0
	hide()

func _on_daylight_level_changed(daylight_level: float) -> void:
	_daylight_level = daylight_level
	print("Daylight level: ", _daylight_level)

func _process(_delta: float) -> void:
	if _daylight_level <= daylight_level_min:
		if not visible:
			_fade_in()
	else:
		if visible:
			_fade_out()

func _fade_in() -> void:
	# Kill any existing fade tween
	if _fade_tween:
		_fade_tween.kill()
	
	# Start visible with 0 energy
	show()
	energy = 0.0
	
	# Fade in to original energy
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "energy", _original_energy, fade_duration)
	_fade_tween.set_trans(Tween.TRANS_SINE)
	_fade_tween.set_ease(Tween.EASE_IN_OUT)

func _fade_out() -> void:
	# Kill any existing fade tween
	if _fade_tween:
		_fade_tween.kill()
	
	# Fade out to 0 energy, then hide
	_fade_tween = create_tween()
	_fade_tween.tween_property(self, "energy", 0.0, fade_duration)
	_fade_tween.set_trans(Tween.TRANS_SINE)
	_fade_tween.set_ease(Tween.EASE_IN_OUT)
	_fade_tween.tween_callback(func():
		hide()
	)
