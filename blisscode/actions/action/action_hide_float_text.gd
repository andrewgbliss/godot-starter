class_name ActionHideFloatText extends Action

func process(_delta: float) -> Status:
	SpawnManager.fade_out_text()
	return Status.SUCCESS
