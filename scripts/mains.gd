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
var turn_manager : TurnManager	 = get_node("TurnComponent") 
## Almacena una referencia a la camera de la escena.
@onready
var camera : Camera3D = get_node("Camera3D")

## Es un diccionario que contiene informacion de las bolas que ha metido cada jugador y
## el tipo de bolas que le corresponde, ej: [br] [br]
## [code] {PLAYER_ONE: {"Balls": [], "Type": ""}, PLAYER_TWO: {"Balls": [], "Type": ""},}
## [/code]
var infoPlayer = {
	PLAYER_ONE: {"Balls": []},
	PLAYER_TWO: {"Balls": []},
}
## Visibilidad de las pelotas
var active : bool = true


func _ready():
	new_game()
	pass 

## Inicializa las bolas y las spawnea 
func new_game():
	ball_array.GenerateBalls()
	ball_array.SpawnBalls()
	




func _process(_delta):

	if Input.is_action_just_pressed("SpawnBalls"):
		ball_array.GenerateBalls()
		ball_array.SpawnBalls()
	if Input.is_action_just_pressed("RightClick"):
		ball_array.DeleteBalls()
		
	if Input.is_action_just_pressed("ChangeBall"):
		var longitud = ball_array.CurrentArray.size() - 1
		for i in longitud:
			ball_array.ChangeBall(randi_range(1,longitud) , "Ball" + str(randi_range(1,15)))
		
	if Input.is_action_just_pressed("VisibiltyToggle"):
		active = !active
		ball_array.VisibilityTogle(active)
	pass


func check_win(turn : int,ball : BallObject):

	if infoPlayer[turn]["Balls"].size() >= 8 and ball.ballName == "Ball8":
		print("jugador " + str(turn) +" gana")
	elif ball.ballName == "Ball8":
		print("jugador " + str(turn) +" pierde")
	
func _on_turn_score_ball(turn, ball):
	infoPlayer[turn]["Balls"].append(ball)
	check_win(turn,ball)

