extends Node
class_name BallObject



func create_ball(ballMass : float ,ballName : String,ballTexture: String,ballMaterial : String):
	var ballInstance = self.get_parent()
	var ballMesh = ballInstance.get_node("MeshInstance3D")
	var newBallTexture = self.get_texture(ballName,ballTexture)
	ballMesh.set_surface_override_material(0,newBallTexture)
	ballInstance.mass = ballMass
	pass

func get_texture(ballName,ballTexture):
	var newBallTexture = load("res://resources/materiales/" + ballName + ".tres")
	return newBallTexture
