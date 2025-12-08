extends Node

signal changed

var MOUSE_SENS:float = 0.1255
var FOV:int = 110

var IP_ADDRESS:String = "127.0.0.1"
var PORT:int = 32580

func apply() -> void:
	changed.emit()
