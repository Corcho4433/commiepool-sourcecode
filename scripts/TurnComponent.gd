extends Node
class_name TurnManager 

## Almacena una referencia al objeto [BallsArray] de la escena.
@onready
var ball_array : BallsArray = get_node("../BallArrayComponent")
## Almacena una referencia al objeto [CueObject] de la escena.
@onready
var cue_component : CueObject = get_node("../CueComponent")
## Si es el turno del jugador 1, turno es igual a PLAYER_ONE
const PLAYER_ONE = 1
## Si es el turno del jugador 2, turno es igual a PLAYER_TWO
const PLAYER_TWO = 2
## Indica de quien es el turno.
var turn : int = PLAYER_ONE
var infoTurns = {
	PLAYER_ONE: {"Type": ""},
	PLAYER_TWO: {"Type": ""}
}
var firstBall : bool = true
var firstBallTouched : BallObject 
var touchedBall : bool = false
var ballsScored : Array[BallObject] = []
var turn_state = TurnState.new("normal")

## Se espera un retraso antes de cambiar de turn para permitir 
## que las bolas se detengan después del golpe.
var cueUsedFrames : int = 0
## Indica si el palo de billar ha sido usado
var cueUsed : bool = false

func _ready():
	GameEvent.cue_ball_hit_ball.connect(cue_ball_collide)
	GameEvent.ball_strike.connect(_on_cue_component_ball_strike)
	GameEvent.ball_exited_playable_area.connect(_ball_scored)


func _process(_delta):
	var stillBall : bool = ball_array.checkMovement()
	cue_component.isCueStickActive = stillBall
	
	if cueUsed == true and stillBall == true:
		cueUsedFrames += 1
		if cueUsedFrames >= 4:
			calc_penalty()
			score_balls()
			changeTurn()
			turn_state.reset()
			cueUsed = false
			touchedBall = false
			ballsScored = []
			cueUsedFrames = 0  # Reinicia el contador de frames
	
	if stillBall == false:
		cueUsedFrames = 0
		
		
func changeTurn():
	var state = turn_state.state
	print(state)
	if state == "extra turn": return
	if "penalty" in state: 
		GameEvent.penalty_commited.emit()
	if turn == PLAYER_ONE:
		turn = PLAYER_TWO
	elif turn == PLAYER_TWO:
		turn = PLAYER_ONE
	GameEvent.change_turn.emit(turn)

func _on_cue_component_ball_strike():
	cueUsed = true

func _ball_scored(body):
	var ball : BallObject = body.get_parent()
	ballsScored.append(ball)

func score_balls():
	var otherTurn = get_other_player_turn()
	for ball : BallObject in ballsScored:
		var type : String = ball.ballType
		if type == "CueBall": 
			turn_state.change_state("score cue ball")
			continue
		if firstBall:
			calc_first_turn(type)
		calc_extra_turn(type)
		if infoTurns[turn]["Type"] == type or "" == type:
			GameEvent.on_ball_scored.emit(turn, ball)
		elif infoTurns[turn]["Type"] == type:
			GameEvent.on_ball_scored.emit(otherTurn, ball)
		
	
func calc_extra_turn(type : String):
	if infoTurns[turn]["Type"] == type:
		turn_state.change_state("score own ball")
		
	
func calc_penalty():
	if touchedBall == false:
		turn_state.change_state("miss")
	elif firstBallTouched.ballType != infoTurns[turn]["Type"] and infoTurns[turn]["Type"] != "":
		turn_state.change_state("hit opponent ball")
	

func calc_first_turn(type : String):
	var otherTurn = get_other_player_turn()
	infoTurns[turn]["Type"] = type
	infoTurns[otherTurn]["Type"] = get_other_type(type)
	firstBall = false
	turn_state.change_state("first turn")

func get_other_player_turn():
	if turn == PLAYER_ONE:
		return PLAYER_TWO
	else:
		return PLAYER_ONE

func cue_ball_collide(ball : BallObject):
	if !touchedBall:
		firstBallTouched = ball
		touchedBall = true
	


func get_other_type(type : String):
	if type == "Smooth":
		return "Stripped"
	else:
		return "Smooth"
		

