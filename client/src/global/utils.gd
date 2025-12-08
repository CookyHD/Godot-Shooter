extends Node

func setMouseCapture(mode:bool) -> void:
	if mode:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func getMouseCapture() -> bool:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return true
	else:
		return false

func prasePackage(type:String,data:Dictionary) -> Dictionary[String,Variant]:
	return {
		type = type,
		data = data,
	}

func killPackage(package:Dictionary) -> void:
	package["KILL"] = null

func totalVector(vector:Vector3) -> float:
	return abs(vector.x) + abs(vector.y) + abs(vector.z)
