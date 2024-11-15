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
var text_frames : int = 0
var deleting_text : bool = false 

func _ready():
	GameEvent.on_ball_scored.connect(firstTurn)
	GameEvent.change_turn.connect(activateOutline)
	GameEvent.penalty_commited.connect(activatePenaltyText)

func activatePenaltyText():
	change_text("Bola en mano")
	penalty = true
	reset_typing()

func reset_typing():
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
		change_text("Turno Extra") 
	elif penalty == false:
		change_text("Turno Normal")
	penalty = false
	reset_typing() 
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
		if deleting_text:
			if current_text.length() > 0:
				current_text = current_text.substr(0, current_text.length() - 1)
				update_text()
			else:
				
				deleting_text = false
		else:
			# Typing the text
			if current_text != text_to_show:
				current_text += text_to_show[current_text.length()]
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

func change_text(new_text: String):
	if new_text != text_to_show:
		text_to_show = new_text
		deleting_text = true
		text_frames = 0  
		reset_typing()
