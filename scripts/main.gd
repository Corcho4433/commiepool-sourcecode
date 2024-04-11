extends Node3D

@export var ball_scene : PackedScene
@export var ball_array : BallsComponent

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
			var ball_material = load("res://resources/materiales/" + ball_array.CurrentArray[index] + ".tres")
			var b = ball_scene.instantiate()
			var new_position = Vector3(ofsetX + (col*dia) , 0 , ofsetZ + (row*dia) + (col * dia / 2) ) 
			add_child(b)
			b.get_node("MeshInstance3D").set_surface_override_material(0,ball_material)
			b.position = new_position
			index += 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		print(ball_array.CurrentArray.pick_random())
	
	pass
