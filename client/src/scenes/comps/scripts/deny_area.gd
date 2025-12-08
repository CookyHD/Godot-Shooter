extends Area3D

@export
var POWER_MULT:float = 1

func _physics_process(_delta:float) -> void:
	if overlaps_body(Controller.PLAYER):
		var power:float = global_position.distance_to(Controller.PLAYER.global_position)
		var angle:Vector2 = Vector2.from_angle(global_position.angle_to(Controller.PLAYER.global_position))
		Controller.AddVelocity = Vector3(angle.x*(power*POWER_MULT),0,angle.y*(power*POWER_MULT))
		
