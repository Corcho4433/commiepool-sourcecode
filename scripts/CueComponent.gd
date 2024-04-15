extends Node
class_name CueObject


var percentage : int
var oldpercentage : int
@onready
var cameraNode : Camera3D = get_node("../Camera3D")
@onready
var cueBall : RigidBody3D =  get_node("../PoolTable/CueBall")
@onready
var chargeBar : RichTextLabel = get_node("RichTextLabel")
@onready
var cueMesh : MeshInstance3D = get_node("CueMesh")


var action : bool
var active : bool

var ballPosition : Vector3
var mousePosition : Vector3
var posDifference : Vector3


var appliedForce : Vector3
var direction : Vector3
var distance : float
var forceMultiplier : float = 400
var forceVariation : float = 1.2
var maxDistance : float = 0.4


func _ready():
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if !active: return
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	getStrokePower(ballPosition,mousePosition)
	displayCueStick()
	if action == true: 

		displayChargeText()

		oldpercentage = percentage
	if Input.is_action_just_released("LeftClick") and action == true:
		action = false
		chargeBar.position = Vector2(139,131)
		applyStrokePower()
	pass

func applyStrokePower():
	cueBall.apply_force(appliedForce, Vector3.ZERO)


func displayCueStick():
	var cueDirection = (cueMesh.position - ballPosition).normalized()
	var cueRotation = Vector3(1.5708,atan2(direction.x,direction.z),0)
	var cuePosition = mousePosition + direction * -0.45
	
#	if distance < maxDistance:
	cueMesh.position = cuePosition
	cueMesh.rotation = cueRotation 	

func displayChargeText():
	var tags : String
	percentage = int((distance / maxDistance) * 100)
	chargeBar.position = abs(Vector2(get_viewport().get_mouse_position())) * 1.03
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


	chargeBar.parse_bbcode("[center]" + tags)
	chargeBar.add_text(str(percentage) + "%")
	chargeBar.pop_all()
	
	
	
	
func getStrokePower(ballPos: Vector3,mousePos: Vector3):
	posDifference = ballPos - mousePos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= maxDistance: distance = maxDistance
	if Input.is_action_pressed("IncreaseCuePower"):
			distance += 0.3
	appliedForce = direction * (forceMultiplier * distance) * randf_range(1,forceVariation)
	return appliedForce

func _on_cue_ball_input_event(_camera, _event, position, _normal, _shape_idx):
	if !Input.is_action_just_pressed("LeftClick"): return
	action = true
	pass # Replace with function body.





