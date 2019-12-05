extends KinematicBody

onready var camera = $Pivot/Camera
var gravity = -25
var jumpSpeed = 8
var maxSpeed = 0
var maxWalkSpeed = 4.5
var maxRunSpeed = 8.5
var maxAirSpeed = 7

var speed = 0
var targetSpeed = 0
var acceleration = 0.15
var friction = 0.35

var mouseSensitivity = 0.004 # radiens/pixel

var velocity = Vector3.ZERO
var inputDirection = Vector3.ZERO
var jump = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func GetInput():
	
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	
	if is_on_floor():
		targetSpeed = maxWalkSpeed
	else:
		targetSpeed = maxAirSpeed
	
	if Input.is_action_pressed("sprint") and is_on_floor():
		targetSpeed = maxRunSpeed
	
	var inputDir = Vector3()
	if Input.is_action_pressed("move_forward"):
		inputDir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		inputDir += camera.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		inputDir += -camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		inputDir += camera.global_transform.basis.x
	inputDir = inputDir.normalized()
	if inputDir == Vector3.ZERO:
		targetSpeed = 0
		return false
	else: 
		inputDirection = inputDir
		return true
		

func _unhandled_input(event):
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouseSensitivity)
		$Pivot.rotate_x(-event.relative.y * mouseSensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)


func _physics_process(delta):
	
	velocity.y += gravity * delta
	var input = GetInput()
	
	speed = lerp(speed, targetSpeed, GetFriction(GetInput()))
	
	velocity.x = inputDirection.x * speed
	velocity.z = inputDirection.z * speed
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if jump and is_on_floor():
		velocity.y = jumpSpeed
	
	
func GetFriction(accelerating):
	if !is_on_floor(): return 0
	if accelerating: return acceleration
	else: return friction
	
	
	
	
	
	
