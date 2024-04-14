extends Node
class_name CueObject

var action : bool
var ballPosition : Vector3
var mousePosition : Vector3
var cameraNode : Camera3D
var cueBall : RigidBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	cameraNode = get_node("../Camera3D")
	cueBall = get_node("../PoolTable/CueBall")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("LeftClick") and action == true:
		action = false
		getStrokePower(ballPosition,cameraNode.project_position(get_viewport().get_mouse_position(),1))
	pass


func getStrokePower(ballPos: Vector3,mousePos: Vector3):
	var posDifference = ballPos - mousePos
	var forceMultiplier = 1000
	posDifference[1] = 0
	cueBall.apply_force(Vector3(posDifference[0]* forceMultiplier,0,posDifference[2]*forceMultiplier),posDifference)
	pass


func _on_cue_ball_input_event(_camera, _event, position, _normal, _shape_idx):
	if !Input.is_action_just_pressed("LeftClick"): return
	action = true
	ballPosition = cueBall.position
	pass # Replace with function body.





