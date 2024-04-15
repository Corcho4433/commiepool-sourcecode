extends Node
class_name CueObject


var cameraNode : Camera3D
var cueBall : RigidBody3D

var action : bool

var ballPosition : Vector3
var mousePosition : Vector3
var posDifference : Vector3

var appliedForce : Vector3
var forceMultiplier : float = 200
var maxForce : float = 200
var xForce : float
var zForce : float

func _ready():
	cameraNode = get_node("../Camera3D")
	cueBall = get_node("../PoolTable/CueBall")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var progressbar : ProgressBar = get_node("ProgressBar")
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	if action == true: 
		appliedForce = getStrokePower(ballPosition,mousePosition)
		var percentage = appliedForce.length() / 2
		progressbar.set_value_no_signal(percentage)
	if Input.is_action_just_released("LeftClick") and action == true:
		action = false
		applyStrokePower()
	pass

func applyStrokePower():
	cueBall.apply_force(appliedForce, Vector3.ZERO)
	
func getStrokePower(ballPos: Vector3,mousePos: Vector3):
	posDifference = ballPos - mousePos
	posDifference[1] = 0
	posDifference.normalized()
	xForce =  posDifference[0] * forceMultiplier
	zForce =  posDifference[2] * forceMultiplier
	if xForce >= maxForce: xForce = maxForce 
	if xForce <= -maxForce: xForce = -maxForce
	if zForce >= maxForce: zForce = maxForce
	if zForce <= -maxForce: zForce = -maxForce
	
	return Vector3(xForce,0,zForce) 

func _on_cue_ball_input_event(_camera, _event, position, _normal, _shape_idx):
	if !Input.is_action_just_pressed("LeftClick"): return
	action = true
	ballPosition = cueBall.position
	pass # Replace with function body.





