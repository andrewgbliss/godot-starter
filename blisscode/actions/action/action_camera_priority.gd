class_name ActionCameraPriority extends Action

@export var camera_priority: int = 20
@export var phantom_camera: PhantomCamera2D

func process(_delta: float) -> Status:
	phantom_camera.set_priority(camera_priority)
	return Status.SUCCESS