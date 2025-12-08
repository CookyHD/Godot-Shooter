extends CharacterBody3D
class_name Player

@onready var HEAD:Node3D = $Pivot
@onready var CAM:Camera3D = $Pivot/Camera3D

func _ready() -> void:
	CAM.fov = Settings.FOV

func _enter_tree() -> void:
	Utils.setMouseCapture(true)
	Controller.setPlayer(self)
	Settings.changed.connect(setFOV)

func _exit_tree() -> void:
	Utils.setMouseCapture(false)
	Controller.removePlayer()

func setFOV() -> void:
	CAM.fov = Settings.FOV
