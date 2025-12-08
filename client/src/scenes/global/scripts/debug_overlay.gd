extends Control

var show_fps:bool = true
var show_ping:bool = true
var show_dot:bool = true
var show_stamina_icon:bool = true
var show_move_data:bool = true

func _ready() -> void:
	$RightLeft/Scale/Stamina.max_value = Controller.MAX_STAMINA

func _process(_delta:float) -> void:

	$List/FPS.set_text("FPS: "+str(roundf(Engine.get_frames_per_second())))
	$List/FPS.visible = show_fps

	$List/PING.set_text("Ping: "+str(null)+" ms")
	$List/PING.visible = show_ping
	
	if Controller.PLAYER != null:
		$List/MOVE.set_text(
			"MOVE DATA:"+
			"\n    State: "+str(Controller.STATES.keys()[Controller.State])+
			"\n    Vel: "+str(roundf(Utils.totalVector(Controller.PLAYER.velocity)))+
			"\n    Stamina: "+str(roundf(Controller.Stamina))
		)
	$List/MOVE.visible = show_move_data

	$Middle/Dot.visible = show_dot

	$RightLeft/Scale/Stamina.value = Controller.Stamina
	$RightLeft/Scale.visible = show_stamina_icon
