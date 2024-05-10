extends Node
class_name TurnManager 

signal score_ball(turn : int,ball : BallObject)
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
	PLAYER_ONE: {"Type": "", "ExtraTurn": false},
	PLAYER_TWO: {"Type": "", "ExtraTurn": false}
}
var firstTurn : bool = true




## Se espera un retraso antes de cambiar de turn para permitir 
## que las bolas se detengan después del golpe.
var cueUsedFrames : int = 0
## Indica si el palo de billar ha sido usado
var cueUsed : bool = false



func _process(_delta):
	var stillBall : bool = ball_array.checkMovement()
	cue_component.isCueStickActive =  stillBall
	
	if cueUsed == true and stillBall == true:
		cueUsedFrames += 1
		if cueUsedFrames >= 30:
			changeTurn()
			print(turn)
			cueUsed = false
			cueUsedFrames = 0  # Reinicia el contador de frames
	
	if stillBall == false:
		cueUsedFrames = 0
		
		
func changeTurn():

	if turn == PLAYER_ONE and infoTurns[turn]["ExtraTurn"]:
		turn = PLAYER_ONE
		infoTurns[turn]["ExtraTurn"] = false
	elif turn == PLAYER_TWO and infoTurns[turn]["ExtraTurn"]:
		turn = PLAYER_TWO
		infoTurns[turn]["ExtraTurn"] = false
	elif turn == PLAYER_ONE:
		turn = PLAYER_TWO
	elif turn == PLAYER_TWO:
		turn = PLAYER_ONE

func _on_cue_component_ball_strike():
	cueUsed = true

func _ball_scored(body, isCueBall):
	var otherTurn = get_other_player_turn()
	if isCueBall: 
		infoTurns[otherTurn]["ExtraTurn"] = true

		return

	var ball = body.get_parent()
	var types = ball_array.checkTypeBall(ball)
	getExtraTurns(ball,types)
	
	if firstTurn:
		infoTurns[turn]["Type"] = types[0]
		infoTurns[otherTurn]["Type"] = types[1]
		firstTurn = false
	
	if infoTurns[turn]["Type"] == types[0]:
		score_ball.emit(turn, ball)
	else:
		score_ball.emit(otherTurn, ball)
	
func getExtraTurns(ball : BallObject,types : Array):

	var otherTurn = get_other_player_turn()

	if infoTurns[turn]["Type"] == types[0]:
		infoTurns[turn]["ExtraTurn"]= true

func get_other_player_turn():
	if turn == PLAYER_ONE:
		return PLAYER_TWO
	else:
		return PLAYER_ONE


