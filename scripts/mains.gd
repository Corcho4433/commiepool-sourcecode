## Coordina las acciones entre el palo de billar y las bolas. Ademas, contiene
## un sistema de turnos y un sistema de puntuacion.
class_name GameState extends Node
## Si es el turno del jugador 1, turno es igual a PLAYER_ONE
const PLAYER_ONE = 1
## Si es el turno del jugador 2, turno es igual a PLAYER_TWO
const PLAYER_TWO = 2

## Almacena una referencia al objeto [BallsArray] de la escena.
@onready
var ball_array : BallsArray = get_node("BallArrayComponent")
## Almacena una referencia al objeto [CueObject] de la escena.
@onready
var turn_manager : TurnManager = get_node("TurnComponent") 
## Almacena una referencia a la camera de la escena.


## Es un diccionario que contiene informacion de las bolas que ha metido cada jugador y
## el tipo de bolas que le corresponde, ej: [br] [br]
## [code] {PLAYER_ONE: {"Balls": [], "Type": ""}, PLAYER_TWO: {"Balls": [], "Type": ""},}
## [/code]

## Visibilidad de las pelotas
var active : bool = true


func _ready():
	GameEvent.on_ball_scored.connect(_on_turn_score_ball)
	new_game()

## Inicializa las bolas y las spawnea 
func new_game():
	ball_array.GenerateBalls()
	ball_array.SpawnBalls()
	




func _process(_delta):

	if Input.is_action_just_pressed("SpawnBalls"):
		ball_array.GenerateBalls()
		ball_array.SpawnBalls()

func check_win(turn : int,ball_name : String):
	if GameInfo.infoPlayer[turn]["Balls"].size() >= 8 and ball_name == "Ball8":
		print("jugador " + str(turn) +" gana")
	elif ball_name == "Ball8":
		print("jugador " + str(turn) +" pierde")
	
func _on_turn_score_ball(turn, ball):
	GameInfo.infoPlayer[turn]["Balls"].append(ball)
	check_win(turn,ball)
	

