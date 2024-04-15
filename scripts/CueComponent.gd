extends Node
class_name CueObject


var percentage : int
var oldpercentage : int

var cameraNode : Camera3D
var cueBall : RigidBody3D

var action : bool

var ballPosition : Vector3
var mousePosition : Vector3
var posDifference : Vector3


var appliedForce : Vector3
var direction : Vector3
var distance : float
var forceMultiplier : float = 400
var maxDistance : float = 0.4


func _ready():
	cameraNode = get_node("../Camera3D")
	cueBall = get_node("../PoolTable/CueBall")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	
	if action == true: 
		getStrokePower(ballPosition,mousePosition)
		displayText()
		
		oldpercentage = percentage
	if Input.is_action_just_released("LeftClick") and action == true:
		action = false
		applyStrokePower()
	pass

func applyStrokePower():
	cueBall.apply_force(appliedForce, Vector3.ZERO)
	
func displayText():
	var carga : RichTextLabel = get_node("RichTextLabel")
	var tags : String
	
	percentage = int((distance / maxDistance) * 100)
	carga.position = abs(Vector2(get_viewport().get_mouse_position())) * 1.03
	if oldpercentage == percentage: return
	if percentage >= 0 and percentage < 20:
		tags = "[color=aqua][wave]"
	elif percentage >= 20 and percentage < 40: 
		tags = "[color=green][wave]"
	elif percentage >= 40 and percentage < 60:
		tags = "[color=yellow][wave]"
	elif percentage >= 60 and percentage < 90:
		tags = "[color=red][shake]"
	elif percentage >= 90:
		tags = "[shake][rainbow]"


	carga.parse_bbcode("[center]" + tags)
	carga.add_text(str(percentage) + "%")
	carga.pop_all()
	
	
	
	
	
	
	
func getStrokePower(ballPos: Vector3,mousePos: Vector3):
	posDifference = ballPos - mousePos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= maxDistance: distance = maxDistance
	if Input.is_action_pressed("IncreaseCuePower"):
			distance += 0.3
	appliedForce = direction * (forceMultiplier * distance)
	return appliedForce

func _on_cue_ball_input_event(_camera, _event, position, _normal, _shape_idx):
	if !Input.is_action_just_pressed("LeftClick"): return
	action = true
	ballPosition = cueBall.position
	pass # Replace with function body.





