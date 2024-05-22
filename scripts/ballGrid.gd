extends Control
class_name GridBall

@export var containersP1 : Array[Sprite2D] = []
@export var containersP2 : Array[Sprite2D] = []


func _ready():
	GameEvent.on_ball_scored.connect(filter_balls)

func display(balls : Array[BallObject],containerID : int):
	var idx : int = 0
	if containerID == 1: 
		for container in containersP1:
			container.set_texture(null)

	elif containerID == 2:
		for container in containersP2:
			container.set_texture(null)

	for ball in balls:
		if containerID == 1:
			containersP1[idx].set_texture(ball.ballImg)
		elif containerID == 2:
			containersP2[idx].set_texture(ball.ballImg)
		idx += 1
		# hacer q  loopee por las bochas que les pasa alguna señal o metodo y ponerlo
		# en los containers 
func filter_balls(_turn : int,_ball : BallObject):
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
		display(ballSmooth,_turn)
		display(ballStripped,_other_turn)
	else :
		display(ballSmooth,_other_turn)
		display(ballStripped,_turn)
