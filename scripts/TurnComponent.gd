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
	print(infoTurns)

	if turn == PLAYER_ONE:
		turn = PLAYER_TWO
	elif turn == PLAYER_TWO:
		turn = PLAYER_ONE

func _on_cue_component_ball_strike():
	cueUsed = true

func _on_playable_area_collision_ball_exited_playable_area(body, isCueBall):
	if isCueBall: return
	getExtraTurns(body.get_parent())
	
	
func getExtraTurns(ball):
	var otherTurn = get_other_player_turn()
	var types = ball_array.checkTypeBall(ball)
	print(types)
	if firstTurn:
		infoTurns[turn]["Type"] = types[0]
		infoTurns[otherTurn]["Type"] = types[1]
		firstTurn = false
	
	if infoTurns[turn]["Type"] == types[0]:
		infoTurns[turn]["ExtraTurn"]= true
	
	pass


func get_other_player_turn():
	if turn == PLAYER_ONE:
		return PLAYER_TWO
	else:
		return PLAYER_ONE
