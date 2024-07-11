extends Control
class_name GridBall

@export var containersP1 : Array[Sprite2D] = []
@export var containersP2 : Array[Sprite2D] = []
var balls = {
			GameInfo.PLAYER_ONE: [],
			GameInfo.PLAYER_TWO: []}
var p1Balls = []
var p2Balls = []
var firstBall : bool = true

func _ready():
	GameEvent.on_ball_scored.connect(firstTurn)


func firstTurn(_turn:int, _ballScored: BallObject):
	if firstBall == false: return 
	var allBalls = get_tree().get_nodes_in_group("allBalls")
	for ball in allBalls:
		if ball.spawned == false: continue
		if ball.ballType == _ballScored.ballType:
			balls[_turn].append(ball)
		elif ball.ballType == "Smooth" or ball.ballType == "Stripped":
			if _turn == GameInfo.PLAYER_ONE:
				balls[GameInfo.PLAYER_TWO].append(ball)
			else:
				balls[GameInfo.PLAYER_ONE].append(ball)
	display()
	firstBall = false
	toggle_display(true)
	

func update(ball: BallObject):
	balls[GameInfo.PLAYER_ONE].erase(ball)
	balls[GameInfo.PLAYER_TWO].erase(ball)
	display()

func display():
	for container in containersP1:
		container.set_texture(null)
	for container in containersP2:
		container.set_texture(null)
	var idx = 0
	for ball in balls[GameInfo.PLAYER_ONE]:
		containersP1[idx].set_texture(ball.ballImg)
		idx += 1
	
	idx = 0
	for ball in balls[GameInfo.PLAYER_TWO]:
		containersP2[idx].set_texture(ball.ballImg)
		idx += 1

func toggle_display(value : bool):
	for container in containersP1:
		container.set_visible(value)
	
	for container in containersP2:
		container.set_visible(value)
		

