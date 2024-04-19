extends Node3D
class_name PoolTable
@onready
var ball_array : BallsArray = get_node("BallArrayComponent")
@onready
var cue_component : CueObject = get_node("CueComponent")
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_array.GenerateBalls()
	new_game()
	pass 

func new_game():
	ball_array.SpawnBalls()
	

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	cue_component.isCueStickActive =  ball_array.checkMovement()
	
	if Input.is_action_just_pressed("SpawnBalls"):
		ball_array.GenerateBalls()
		ball_array.SpawnBalls()
	if Input.is_action_just_pressed("RightClick"):
		ball_array.DeleteBalls()
		
	if Input.is_action_just_pressed("ChangeBall"):
		var longitud = ball_array.CurrentArray.size() - 1
		for i in longitud:
			ball_array.ChangeBall(randi_range(1,longitud), "Ball" + str(randi_range(1,15)))
		
	if Input.is_action_just_pressed("VisibiltyToggle"):
		active = !active
		ball_array.VisibilityTogle(active)
	pass



