extends Node3D
class_name PoolTable
@export var ball_array : BallsArray
var active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	ball_array.GenerateBalls()
	new_game()
	pass 

func new_game():
	ball_array.SpawnBalls()
	

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		ball_array.GenerateBalls()
		ball_array.SpawnBalls()
	if Input.is_action_just_pressed("RightClick"):
		ball_array.DeleteBalls()
	pass
