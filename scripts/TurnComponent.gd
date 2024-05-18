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
	PLAYER_ONE: {"Type": "", "ExtraTurn": false, "BallInHand": false},
	PLAYER_TWO: {"Type": "", "ExtraTurn": false, "BallInHand": false}
}
var firstBall : bool = true
var firstBallTouched : String = ""



## Se espera un retraso antes de cambiar de turn para permitir 
## que las bolas se detengan después del golpe.
var cueUsedFrames : int = 0
## Indica si el palo de billar ha sido usado
var cueUsed : bool = false

func _ready():
	GameEvent.cue_ball_hit_ball.connect(cue_ball_collide)
	GameEvent.ball_strike.connect(_on_cue_component_ball_strike)



func _process(_delta):
	var stillBall : bool = ball_array.checkMovement()
	cue_component.isCueStickActive = stillBall
	
	if cueUsed == true and stillBall == true:
		cueUsedFrames += 1
		if cueUsedFrames >= 4:
			if firstBallTouched == "":
				penalty()
			print("Antes: ",infoTurns)
			changeTurn()
			print("Despues: ",infoTurns)
			cueUsed = false
			firstBallTouched = ""
			cueUsedFrames = 0  # Reinicia el contador de frames
	
	if stillBall == false:
		cueUsedFrames = 0
		
		
func changeTurn():
	infoTurns[turn]["BallInHand"] = false
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
	
	
	GameEvent.change_turn.emit(turn)

func _on_cue_component_ball_strike():
	cueUsed = true

func _ball_scored(body, isCueBall):
	var otherTurn = get_other_player_turn()
	if isCueBall: 
		penalty()
		return

	var ball : BallObject = body.get_parent()
	var types = ball_array.checkTypeBall(ball.ballName)
	
	
	if firstBall:
		infoTurns[turn]["Type"] = types[0]
		infoTurns[otherTurn]["Type"] = types[1]
		firstBallTouched = "DNC"
		firstBall = false
	getExtraTurns(types)
	if infoTurns[turn]["Type"] == types[0]:
		GameEvent.on_ball_scored.emit(turn, ball)
	else:
		GameEvent.on_ball_scored.emit(otherTurn, ball)
	
	
	
func getExtraTurns(types : Array):
	var firstBallType = ball_array.checkTypeBall(firstBallTouched)
	if infoTurns[turn]["Type"] == types[0]:
		infoTurns[turn]["ExtraTurn"] = true
	if (infoTurns[turn]["Type"] == firstBallType[1] or firstBallTouched == "") and firstBallTouched != "DNC":
		penalty()
		


func get_other_player_turn():
	if turn == PLAYER_ONE:
		return PLAYER_TWO
	else:
		return PLAYER_ONE

func cue_ball_collide(ball_name : String):
	if firstBallTouched == "":
		firstBallTouched = ball_name



func penalty():
	var otherTurn = get_other_player_turn()
	infoTurns[turn]["ExtraTurn"] = false
	infoTurns[otherTurn]["BallInHand"] = true
	GameEvent.penalty_commited.emit()
