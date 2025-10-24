extends CanvasModulate

@export var gradient: GradientTexture1D

func _process(_delta: float) -> void:
	color = gradient.gradient.sample(WorldTimeService.current_value)
