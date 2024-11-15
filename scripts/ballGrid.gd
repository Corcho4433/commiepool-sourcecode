extends Control
class_name GridBall

@export var containersP1 : Array[Sprite2D] = []
@export var containersP2 : Array[Sprite2D] = []
@export var outlineP1 : Sprite2D
@export var outlineP2 : Sprite2D
@export var falta_text : Array[Label3D]

var balls = {
	GameInfo.PLAYER_ONE: [],
	GameInfo.PLAYER_TWO: []
}

var p1Balls = []
var p2Balls = []
var firstBall : bool = true
var penalty : bool = false
var old_turn : int = -1
var text_to_show : String = ""
var current_text : String = ""
var text_count : int = 0
var text_frames : int = 0

func _ready():
	GameEvent.on_ball_scored.connect(firstTurn)
	GameEvent.change_turn.connect(activateOutline)
	GameEvent.penalty_commited.connect(activatePenaltyText)

func activatePenaltyText():
	text_to_show = "Bola en mano"
	reset_typing()

func reset_typing():
	# Reset text variables to restart the typing effect
	current_text = ""
	text_count = 0
	text_frames = 0
	update_text()

func update_text():
	for text in falta_text:
		text.text = current_text

func activateOutline(turn : int):
	if turn == GameInfo.PLAYER_ONE:
		outlineP1.visible = true
		outlineP2.visible = false
	else:
		outlineP1.visible = false
		outlineP2.visible = true

	if turn == old_turn:
		text_to_show = "Turno Extra"
	reset_typing()  # Reset text when turn changes
	old_turn = turn

func firstTurn(_turn:int, _ballScored: BallObject):
	if firstBall == false:
		return

	var allBalls = get_tree().get_nodes_in_group("allBalls")
	for ball in allBalls:
		if ball.spawned == false:
			continue
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

func _process(_delta):
	if text_frames >= 15:
		if current_text != text_to_show:
			current_text += text_to_show[text_count]
			text_count += 1
			update_text()
		text_frames = 0
	text_frames += 1

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
