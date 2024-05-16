extends Node
class_name GUI

@export var cueStickNode : Node3D
@export var chargeBar : RichTextLabel
@export var camera : Camera3D
var _cueStick : MeshInstance3D

const  MAX_DISTANCE : float = 0.4

func _ready():
	_cueStick = cueStickNode.get_node("Cylinder")
	GameEvent.update_cue_charge.connect(update_cue_charge)
	GameEvent.change_turn.connect(change_cue_color)
	GameEvent.cue_used_changed.connect(change_cue_visibility)
	change_cue_color(1)
	change_cue_visibility()

func update_cue_charge(ball_pos : Vector3, direction : Vector3, distance : float):
	displayChargeBar(ball_pos,direction,distance)
	displayCueStick(ball_pos,direction,distance)



func change_cue_color(turn : int):
	var material : Material 
	if turn == 1:
		material  = load("res://resources/materiales/palo1.tres")
	elif turn == 2: 
		material = load("res://resources/materiales/palo2.tres")
	_cueStick.set_surface_override_material(1,material)

func change_cue_visibility():
	_cueStick.visible = !_cueStick.visible
	
func displayCueStick(ball_pos : Vector3, direction : Vector3, distance : float):
	var cueRotation : Vector3 = Vector3(1.5708,atan2(direction.x,direction.z),0)
	var minDistance : Vector3 = direction * -0.7
	var cuePosition : Vector3 = ball_pos - (direction * distance) + minDistance
	_cueStick.rotation = cueRotation
	_cueStick.position = cuePosition

func displayChargeBar(ball_pos : Vector3, direction : Vector3, distance : float):
	var chargeBarPosition : Vector3 = ball_pos - (direction * distance)
	var minDistance : Vector3 = direction * -0.15
	var chargeBarPercentage : int = int((distance / MAX_DISTANCE) * 100)
	chargeBar.visible = true
	chargeBar.position = camera.unproject_position(chargeBarPosition + minDistance) 
	setChargeBarText(chargeBarPercentage)
		
		
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
