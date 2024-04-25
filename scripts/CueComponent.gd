extends Node
class_name CueObject




@onready
var cameraNode : Camera3D = get_node("../Camera3D")
@onready
var cueBall : RigidBody3D =  get_node("../PoolTable/CueBall")
@onready
var chargeBar : RichTextLabel = get_node("RichTextLabel")
var chargeBarPercentage : int
var oldChargeBarPercentage : int
@onready
var cueMesh : MeshInstance3D = get_node("CueMesh")


var isCueStickUsed : bool
var isCueStickActive : bool

var ballPosition : Vector3
var mousePosition : Vector3
var posDifference : Vector3


var appliedForce : Vector3
var direction : Vector3
var distance : float
const FORCE_MULTIPLIER : float = 400
const MAX_FORCE_VARIATION : float = 1.5
const MIN_FORCE_VARIATION : float = 1
const  MAX_DISTANCE : float = 0.4



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	cueMesh.visible = isCueStickUsed
	
	if isCueStickActive == false or isCueStickUsed == false: return	
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	getStrokePower(ballPosition,mousePosition)
	displayCueStick()
	displayChargeText()
	
	if Input.is_action_just_released("LeftClick"):
		isCueStickUsed = false
		chargeBar.visible = false
		applyStrokePower()
	pass

func applyStrokePower():
	cueBall.apply_force(appliedForce, Vector3.ZERO)


func displayCueStick():
	var cueRotation = Vector3(1.5708,atan2(direction.x,direction.z),0)
	var minDistance = direction * -0.41
	var cuePosition = ballPosition - (direction * distance) + minDistance
	cueMesh.rotation = cueRotation
	cueMesh.position = cuePosition

func displayChargeText():
	var tags : String
	chargeBarPercentage = int((distance / MAX_DISTANCE) * 100)
	chargeBar.visible = true
	chargeBar.position = abs(Vector2(get_viewport().get_mouse_position())) * 1.03
	if oldChargeBarPercentage != chargeBarPercentage: 
		oldChargeBarPercentage = chargeBarPercentage
	else:
		return
	if chargeBarPercentage >= 0 and chargeBarPercentage < 20:
		tags = "[color=aqua][wave]"
	elif chargeBarPercentage >= 20 and chargeBarPercentage < 40: 
		tags = "[color=green][wave]"
	elif chargeBarPercentage >= 40 and chargeBarPercentage < 60:
		tags = "[color=yellow][wave]"
	elif chargeBarPercentage >= 60 and chargeBarPercentage < 90:
		tags = "[color=red][shake]"
	elif chargeBarPercentage >= 90:
		tags = "[shake][rainbow]"
	chargeBar.parse_bbcode("[center]" + tags)
	chargeBar.add_text(str(chargeBarPercentage) + "%")
	chargeBar.pop_all()
	
	
func getStrokePower(ballPos: Vector3, mousePos: Vector3):
	var forceVariation = randf_range(MIN_FORCE_VARIATION,MAX_FORCE_VARIATION)
	posDifference = ballPos - mousePos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= MAX_DISTANCE: distance = MAX_DISTANCE
	appliedForce = direction * (FORCE_MULTIPLIER * distance) * forceVariation
	return appliedForce



func _on_cue_ball_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_pressed("LeftClick") == false or isCueStickActive == false: return
	isCueStickUsed = true
	pass # Replace with function body.








