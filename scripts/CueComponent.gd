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
var forceMultiplier : float = 400
var forceVariation : float = 1.2
var maxDistance : float = 0.4



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	cueMesh.visible = isCueStickUsed
	
	
	if isCueStickActive == false or isCueStickUsed == false: return	
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	getStrokePower(ballPosition,mousePosition)
	displayCueStick(direction)
	displayChargeText()
	
	if Input.is_action_just_released("LeftClick"):
		isCueStickUsed = false
		chargeBar.visible = false
		applyStrokePower()
	pass

func applyStrokePower():
	cueBall.apply_force(appliedForce, Vector3.ZERO)


func displayCueStick(ballDirection : Vector3):
	var cueRotation = Vector3(1.5708,atan2(ballDirection.x,ballDirection.z),0)
	var cuePosition = mousePosition + ballDirection * -0.45
	cuePosition.y += 0.05
	cueMesh.position = cuePosition
	cueMesh.rotation = cueRotation

func displayChargeText():
	var tags : String
	chargeBarPercentage = int((distance / maxDistance) * 100)
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
	posDifference = ballPos - mousePos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= maxDistance: distance = maxDistance
	appliedForce = direction * (forceMultiplier * distance) * randf_range(1,forceVariation)
	return appliedForce



func _on_cue_ball_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_pressed("LeftClick") == false or isCueStickActive == false: return
	isCueStickUsed = true
	pass # Replace with function body.








