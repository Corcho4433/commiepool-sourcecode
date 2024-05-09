extends Resource
class_name Ball
@export var ball_name : String
@export var ball_mass : int = 1
var ball_mesh = load("res://resources/meshes/bolas/" + ball_name + ".glb")
