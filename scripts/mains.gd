extends Node3D
class_name PoolTable
const PLAYER_ONE = 1
const PLAYER_TWO = 2

@onready
var ball_array : BallsArray = get_node("BallArrayComponent")
@onready
var cue_component : CueObject = get_node("CueComponent")
@onready
var camera : Camera3D = get_node("Camera3D")
var turno : int = PLAYER_ONE	
var cueUsedFrames : int = 0
var cueUsed : bool = false


var infoPlayer = {
	PLAYER_ONE: {"Balls": [], "Type": ""},
	PLAYER_TWO: {"Balls": [], "Type": ""},
}
var active : bool = true


func _ready():
	new_game()
	pass 

func new_game():
	ball_array.GenerateBalls()
	ball_array.SpawnBalls()
	




func _process(_delta):
	
	
	
	var stillBall : bool = ball_array.checkMovement()
	cue_component.isCueStickActive =  stillBall

	
	if cueUsed == true and stillBall == true:
		cueUsedFrames += 1
		if cueUsedFrames >= 30:
			changeTurn()
			cueUsed = false
			print(turno)
			cueUsedFrames = 0  # Reinicia el contador de frames
	
	if stillBall == false:
		cueUsedFrames = 0
		cueUsed = true

	
	
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





func _on_cue_ball_strike():
	cueUsed = true
	pass # Replace with function body.


func _on_ball_scored(body, isCueBall):
	if isCueBall: return
	var ball = body.get_parent()
	var type : String = ball_array.checkTypeBall(ball)
	var bolasJugador1 : Array = infoPlayer[PLAYER_ONE]["Balls"]
	var bolasJugador2 : Array = infoPlayer[PLAYER_TWO]["Balls"]
	var turnoOtherPlayer : int
	if turno == PLAYER_ONE:
		turnoOtherPlayer = PLAYER_TWO
	else:
		turnoOtherPlayer = PLAYER_ONE
	#Checkear primer turno
	if bolasJugador1.is_empty() and bolasJugador2.is_empty():
		infoPlayer[turno]["Type"] = type
		if type == "Smooth":
			infoPlayer[turnoOtherPlayer]["Type"] = "Stripped"
		else: 
			infoPlayer[turnoOtherPlayer]["Type"] = "Smooth"
			
	var typeScoringPlayer : String = infoPlayer[turno]["Type"]

	
	if typeScoringPlayer == type:
		infoPlayer[turno]["Balls"].append(ball)
	else:
		infoPlayer[turnoOtherPlayer]["Balls"].append(ball)
		
	print(infoPlayer)

	pass # Replace with function body.


func changeTurn():
	if turno == PLAYER_ONE:
		turno = PLAYER_TWO
	else: 
		turno = PLAYER_ONE
