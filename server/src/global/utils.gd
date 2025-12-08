extends Node

func prasePackage(type:String,data:Dictionary) -> Dictionary[String,Variant]:
	return {
		type = type,
		data = data,
	}

func killPackage(package:Dictionary) -> void:
	package["KILL"] = null
