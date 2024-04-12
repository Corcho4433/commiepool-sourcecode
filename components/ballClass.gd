extends Node
class_name BallObject

@export var newBallsArray : BallsArray





func create_ball(ballMass : float ,ballName : String, ballTexture: String, positionIndex : int):
	var newBallTexture = self.get_texture(ballName,ballTexture)
	var ballInstance = self.get_parent()
	var ballMesh = ballInstance.get_node("MeshInstance3D")
	newBallsArray = self.get_node("../../BallsComponent")
	ballMesh.set_surface_override_material(0,newBallTexture)
	ballInstance.mass = ballMass
	newBallsArray.ChangeArray(positionIndex, self)
	pass

func get_texture(ballName,ballTexture):
	var newBallTexture = load("res://resources/materiales/" + ballName + ".tres")
	return newBallTexture
