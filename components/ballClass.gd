extends Node
class_name BallObject

@export var newBallsArray : BallsArray
var ballName : String



func create_ball(setBallMass : float ,setBallName : String, setBallTexture: String, positionIndex : int):
	ballName = setBallName
	var newBallTexture = self.get_texture(ballName,setBallTexture)
	var ballInstance = self.get_parent()
	var ballMesh = ballInstance.get_node("MeshInstance3D")
	newBallsArray = self.get_node("../../BallsComponent")
	ballMesh.set_surface_override_material(0,newBallTexture)
	ballInstance.mass = setBallMass
	newBallsArray.ChangeArray(positionIndex, self)

func get_texture(ballName,ballTexture):
	var newBallTexture = load("res://resources/materiales/" + ballName + ".tres")
	return newBallTexture
	
func get_ballName():
	return ballName
