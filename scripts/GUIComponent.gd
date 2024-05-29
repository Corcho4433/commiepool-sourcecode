extends Node
class_name GUI


@export var camera : Camera3D
@onready var lampara : MeshInstance3D = get_node("../PoolTable/habitacion_pool/lampara")
@onready var bombilla : MeshInstance3D = get_node("../PoolTable/habitacion_pool/bombilla")
@onready var bombillita : MeshInstance3D = get_node("../PoolTable/habitacion_pool/BezierCurve")
@export var grid : GridBall 





func _ready():
	lampara.set_layer_mask_value(1,false)
	bombilla.set_layer_mask_value(1,false)
	bombillita.set_layer_mask_value(1,false)
	GameEvent.on_ball_scored.connect(display_ball_scored)
	grid.toggle_display(false)


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
