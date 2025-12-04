class_name ActionCameraFollowBody extends Action

@export var body_var: StringName = &"body"
@export var phantom_camera: PhantomCamera2D

func process(_delta: float) -> Status:
	var body = blackboard.get_var(body_var, null)
	if body:
		phantom_camera.follow_target = body
	else:
		phantom_camera.follow_target = null
	return Status.SUCCESS
