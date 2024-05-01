extends Node
class_name CueObject

signal ball_strike 


@export
var cameraNode : Camera3D 
@export
var cueBall : RigidBody3D 
@onready
var cueMesh : MeshInstance3D = get_node("palo_pool/Cylinder")
@export 
var chargeBar : RichTextLabel 
var chargeBarPercentage : int
var oldChargeBarPercentage : int



var isCueStickUsed : bool
var isCueStickActive : bool

var ballPosition : Vector3
var mousePosition : Vector3


var appliedForce : Vector3
var direction : Vector3
var distance : float
const FORCE_MULTIPLIER : float = 9
const MAX_FORCE_VARIATION : float = 1.1
const MIN_FORCE_VARIATION : float = 1
const  MAX_DISTANCE : float = 0.4



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	cueMesh.visible = isCueStickUsed
	
	if isCueStickActive == false or isCueStickUsed == false: return	
	
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	appliedForce = getStrokePower(ballPosition,mousePosition)
	displayCueStick()
	displayChargeBar()
	
	if Input.is_action_just_released("LeftClick"):
		isCueStickUsed = false
		chargeBar.visible = false
		applyStrokePower(appliedForce, Vector3.ZERO)
		emit_signal("ball_strike")
		
		
func applyStrokePower(force : Vector3, spin : Vector3):
	cueBall.apply_impulse(force, spin)
	

func displayCueStick():
	var cueRotation = Vector3(1.5708,atan2(direction.x,direction.z),0)
	var minDistance = direction * -0.7
	var cuePosition = ballPosition - (direction * distance) + minDistance
	cueMesh.rotation = cueRotation
	cueMesh.position = cuePosition

func displayChargeBar():
	var chargeBarPosition = ballPosition - (direction * distance)
	var minDistance = direction * -0.15
	chargeBarPercentage = int((distance / MAX_DISTANCE) * 100)
	chargeBar.visible = true
	chargeBar.position = cameraNode.unproject_position(chargeBarPosition + minDistance) 
	
	if oldChargeBarPercentage != chargeBarPercentage:
		 #si en el frame no cambio la potencia no actualizar
		oldChargeBarPercentage = chargeBarPercentage
		setChargeBarText(chargeBarPercentage)

	
	
	
func getStrokePower(ballPos: Vector3, shotPos: Vector3):
	var forceVariation : float = randf_range(MIN_FORCE_VARIATION,MAX_FORCE_VARIATION)
	var posDifference : Vector3  = ballPos - shotPos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= MAX_DISTANCE: distance = MAX_DISTANCE
	return direction * (FORCE_MULTIPLIER * distance) * forceVariation




func setChargeBarText(percentage: int):
	var tags : String
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
	
	

func _on_cue_ball_clicked():
	if Input.is_action_pressed("LeftClick") == false or isCueStickActive == false: return
	isCueStickUsed = true
