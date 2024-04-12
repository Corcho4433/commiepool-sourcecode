extends Node3D

@export var ball_scene : PackedScene
@export var ball_array : BallsArray

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	pass # Replace with function body.

func new_game():
	generate_balls()

func generate_balls():
	var rows : int = 6
	var dia = 0.5
	var ofsetX = -3
	var ofsetZ = -3
	var index = 0
	for col in range(5):
		rows -= 1
		for row in range(rows):
			var b = ball_scene.instantiate()
			var new_position = Vector3(ofsetX + (col*dia) , 0 , ofsetZ + (row*dia) + (col * dia / 2) )
			var newBallObject = BallObject.new() 
			add_child(b)
			b.add_child(newBallObject)
			newBallObject.create_ball(1, ball_array.GetStartingArray()[index], "nashe", index)
			b.position = new_position
			index += 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		print(ball_array.CurrentArray.pick_random())
	
	pass
