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
	


func setBallPosition(newBallPosition : Vector3):
	ballPosition = newBallPosition


func get_ballName():
	return ballName
	
func spawnBall():
	var ball = ballScene.instantiate()
	spawned = true
	setBallCollision(ball.get_node("CollisionShape3D"))
	setBallRigidBody(ball)
	addBallToScene(ball)
	addMeshToScene()

	
func changeBallMesh(newBallMesh : MeshInstance3D):
	ballRigidBody.remove_child(ballMesh)
	ballMesh.queue_free()
	ballMesh = newBallMesh
	ballMesh.position = Vector3.ZERO
	addMeshToScene()



func setBallCollision(collisionShape : CollisionShape3D):
	ballCollisionShape = collisionShape

func setBallRigidBody(rigidBody : RigidBody3D):
	ballRigidBody = rigidBody

func addBallToScene(ball):
	add_child(ball)
	ball.position = ballPosition

func addMeshToScene():
	ballRigidBody.add_child(ballMesh)
	

func setBallMesh(newBallMesh : MeshInstance3D):
	ballMesh = newBallMesh 
	ballMesh.position = Vector3.ZERO


func deleteBall():
	queue_free()
	
func setVisibilityBall(newVisibility : bool):
	get_node("pelota").visible = newVisibility


