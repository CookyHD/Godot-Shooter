extends Node

var PLAYER:CharacterBody3D = null

enum STATES {
	IDLE,
	WALK,
	RUN,
	CROUCH,
	JUMP,
	AIR,
}

var State:int = 1

const MAX_STAMINA:float = 20

var Stamina:float = 20

var DrainStamina:bool = false

const FULL_JUMP_HIGHT:float = 13
const JUMP_HIGHT:float = 7
const MAX_JUMP_TIMER:float = 3

var JustJumped:bool = false
var JumpTimer:float = 0

const GRAVITY:float = -0.55

const RUN_SPEED:float = 8
const RUN_ACCEL:float = 2

const WALK_SPEED:float = 5
const WALK_ACCEL:float = 1

const SNEAK_SPEED:float = 3
const SNEAK_ACCEL:float = 0.5

const GROUND_FRICTION:float = 2

const AIR_SPEED:float = 8
const AIR_ACCEL:float = 0.1
const AIR_FRICTION:float = 1

const AIR_BOOST_ACCEL:float = 0.1
const AIR_BOOST_TIME:float = 1

var AddVelocity:Vector3 = Vector3.ZERO

var Speed:float = 0
var Accel:float = 0
var Friction:float = 0

var SpeedMultiplier:float = 1

func setPlayer(character:CharacterBody3D) -> void:
	PLAYER = character

func removePlayer() -> void:
	PLAYER = null

func changeState(state:int) -> void:
	State = state

func useStamina(amount:float) -> bool:
	if Stamina >= amount:
		Stamina -= amount
		return true
	else:
		return false


#AIMMING
func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventMouseMotion and Utils.getMouseCapture() == true:
		PLAYER.rotate_y(deg_to_rad(-event.relative.x * Settings.MOUSE_SENS))
		PLAYER.HEAD.rotate_x(deg_to_rad(-event.relative.y * Settings.MOUSE_SENS))
		PLAYER.HEAD.rotation.x = clampf(PLAYER.HEAD.rotation.x,deg_to_rad(-90),deg_to_rad(90))

#MOVEMENT
func _physics_process(_delta:float) -> void:
	if PLAYER != null:

		#DEBUG
		if Input.is_action_just_pressed("DEBUG"):
			if Utils.getMouseCapture():
				Utils.setMouseCapture(false)
			else:
				Utils.setMouseCapture(true)
		
		var input:Vector2 = Input.get_vector("LEFT","RIGHT","FRONT","BACK").normalized()
		var wish_direction:Vector3 = PLAYER.transform.basis * Vector3(input.x,0,input.y)

		var running:bool = Input.is_action_pressed("TOGGLE")
		var jumping:bool = (Input.is_action_pressed("UP") and PLAYER.is_on_floor())

		if jumping:
			changeState(STATES.JUMP)

		match State:
			STATES.IDLE:
				pass
			STATES.WALK:
				Speed = WALK_SPEED
				Accel = WALK_ACCEL
				Friction = GROUND_FRICTION
				if running:
					changeState(STATES.RUN)
				if !PLAYER.is_on_floor():
					changeState(STATES.AIR)
			STATES.RUN:
				if Stamina > 1:
					DrainStamina = true
					Speed = RUN_SPEED
					Accel = RUN_ACCEL
					if !running:
						changeState(STATES.WALK)
						DrainStamina = false
					if !PLAYER.is_on_floor():
						changeState(STATES.AIR)
				else:
					changeState(STATES.WALK)
					DrainStamina = false
			STATES.AIR:
				Speed = AIR_SPEED
				Accel = AIR_ACCEL
				Friction = AIR_FRICTION
				PLAYER.velocity.y += GRAVITY


		if !JustJumped:
			JumpTimer = clampf(JumpTimer - 0.0166,0,MAX_JUMP_TIMER)

		if DrainStamina:
			Stamina = clampf(Stamina - 0.0166,0,MAX_STAMINA)
		else:
			Stamina = clampf(Stamina + 0.0166,0,MAX_STAMINA)

		if input != Vector2.ZERO:
			PLAYER.velocity.x = move_toward(PLAYER.velocity.x,wish_direction.x*(Speed*SpeedMultiplier),Accel)
			PLAYER.velocity.z = move_toward(PLAYER.velocity.z,wish_direction.z*(Speed*SpeedMultiplier),Accel)
		else:
			PLAYER.velocity.x = move_toward(PLAYER.velocity.x,0,Friction)
			PLAYER.velocity.z = move_toward(PLAYER.velocity.z,0,Friction)
		
		if AddVelocity != Vector3.ZERO:
			PLAYER.velocity += AddVelocity
			AddVelocity = Vector3.ZERO

		PLAYER.move_and_slide()
		
