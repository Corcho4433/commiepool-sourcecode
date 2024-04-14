extends Node
class_name BallObject

var ballScene : PackedScene = load("res://escenes/objects/ball.tscn")
var ballName : String
var ballMass : float
var ballTexture : Material
var ballPosition : Vector3
var spawned : bool
var ballCollisionShape : CollisionShape3D 
var ballMesh : MeshInstance3D 

func setBallName(newBallName : String):
	ballName = newBallName
	
func setBallMass(newBallMass : float):
	ballMass = newBallMass
	
func setBallTexture(newBallTexture : Material):
	ballTexture = newBallTexture
	ballMesh.set_surface_override_material(0,self.get_ballTexture(self.ballName))
	

func setBallPosition(newBallPosition : Vector3):
	ballPosition = newBallPosition
	

func get_ballTexture(ballTexture : String):
	var newBallTexture = load("res://resources/materiales/" + ballTexture + ".tres")
	return newBallTexture
	
func get_ballName():
	return ballName
	
func spawnBall():
	var ball = ballScene.instantiate()
	ballCollisionShape = ball.get_node("CollisionShape3D")
	ballMesh =  ball.get_node("MeshInstance3D") 
	spawned = true
	ballMesh.set_surface_override_material(0,self.get_ballTexture(ballName))
	add_child(ball)
	ball.position = ballPosition


func deleteBall():
	spawned = false
	get_node("pelota").free()
	pass
	
func setVisibilityBall(newVisibility : bool):
	if !spawned: return
	get_node("pelota").visible = newVisibility
