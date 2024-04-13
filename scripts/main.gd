extends Node3D
class_name LvlManager

@export var PoolTableGame : TableClass

func _ready():
	new_game()
	pass

func new_game():
	PoolTableGame.createBalls()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		PoolTableGame.deleteBalls()
	pass
	

