extends Node
class_name BallObject

var ballScene : PackedScene = load("res://escenes/objects/ball.tscn")
var ballName : String
var ballMass : float
var ballTexture : Material
var ballPosition : Vector3

var ballCollisionShape : CollisionShape3D 
var ballMesh : MeshInstance3D 
var ballRigidBody : RigidBody3D

var spawned : bool


func setBallName(newBallName : String):
	ballName = newBallName
	
func setBallMass(newBallMass : float = 1):
	ballMass = newBallMass
	
func setBallTexture(newBallTexture : Material):
	ballTexture = newBallTexture

func setBallMesh(newBallMesh : MeshInstance3D):
	ballMesh = newBallMesh

func setBallPosition(newBallPosition : Vector3):
	ballPosition = newBallPosition
	


func get_ballName():
	return ballName
	
func spawnBall():
	var ball = ballScene.instantiate()
	ballCollisionShape = ball.get_node("CollisionShape3D")
	ballRigidBody = ball
	spawned = true

	add_child(ball)
	ball.add_child(ballMesh)
	ball.position = ballPosition

	


func deleteBall():
	queue_free()
	
func setVisibilityBall(newVisibility : bool):
	if !spawned: return
	get_node("pelota").visible = newVisibility


