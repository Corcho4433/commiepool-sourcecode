extends Node
class_name GUI

@export var cueStickNode : Node3D
@export var camera : Camera3D
@onready var lampara : MeshInstance3D = get_node("../PoolTable/habitacion_pool/lampara")
@onready var bombilla : MeshInstance3D = get_node("../PoolTable/habitacion_pool/bombilla")
@onready var bombillita : MeshInstance3D = get_node("../PoolTable/habitacion_pool/BezierCurve")
@export var grid : GridBall 
@export var  cue_scale = 0.5
var _cueStick : MeshInstance3D



func _ready():
	lampara.set_layer_mask_value(1,false)
	bombilla.set_layer_mask_value(1,false)
	bombillita.set_layer_mask_value(1,false)
	_cueStick = cueStickNode.get_node("Cylinder")
	_cueStick.scale = _cueStick.scale * cue_scale
	GameEvent.update_cue_charge.connect(update_cue_charge)
	GameEvent.change_turn.connect(change_cue_color)
	GameEvent.cue_used_changed.connect(change_cue_visibility)
	GameEvent.on_ball_scored.connect(display_ball_scored)
	grid.toggle_display(false)
	change_cue_color(1)
	change_cue_visibility()

func update_cue_charge(ball_pos : Vector3, direction : Vector3, distance : float):
	displayCueStick(ball_pos,direction,distance)



func change_cue_color(turn : int):
	var material : Material 
	if turn == 1:
		material  = load("res://resources/materiales/palo1.tres")
	elif turn == 2: 
		material = load("res://resources/materiales/palo2.tres")
	_cueStick.set_surface_override_material(1,material)

func change_cue_visibility():
	if _cueStick.visible == false:
		await GameEvent.update_cue_charge
	_cueStick.visible = !_cueStick.visible
	
func displayCueStick(ball_pos : Vector3, direction : Vector3, distance : float):
	const cue_lenght : float = 0.7
	var scale = cue_scale
	var cueRotation : Vector3 = Vector3(1.5708, atan2(direction.x, direction.z), 0)
	var cuePosition : Vector3 = ball_pos + (-direction * distance) - (cue_lenght * direction * scale)
	_cueStick.rotation = cueRotation
	_cueStick.position = cuePosition


func display_ball_scored(_turn:int, _ball: BallObject):
	var allBalls = get_tree().get_nodes_in_group("allBallObjects")
	var ballSmooth : Array[BallObject] = []
	var ballStripped : Array[BallObject] = []
	for ball : BallObject in allBalls:
		if ball.ballType == "Smooth" and ball.spawned == true:
			ballSmooth.append(ball)
		elif ball.ballType == "Stripped" and ball.spawned == true:
			ballStripped.append(ball)

	var _other_turn = _turn
	if _other_turn == 1:
		_other_turn = 2
	else: 
		_other_turn = 1
	
	if _ball.ballType == "Smooth":
		grid.display(ballSmooth,_turn)
		grid.display(ballStripped,_other_turn)
	else :
		grid.display(ballSmooth,_other_turn)
		grid.display(ballStripped,_turn)
	grid.toggle_display(true)
