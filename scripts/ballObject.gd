extends Node
## La clase BallObject se encarga de guardar la informacion individual de cada pelota
## y agregarla a la escena principal como nodo hijo de [BallsArray]. [br] [br]
## El arbol de nodos de una bola spawneada se ve asi : [BallObject] -> [RigidBody3D]
## (llamado pelota) -> [CollisionShape3D] y [MeshInstance3D].
class_name BallObject 



## Nombre de la bola.
var ballName : String
## Masa de la bola, por default 1.
var ballMass : float
## Posicion de spawn de la bola, cambiar este valor no actualiza la posicion.
var ballPosition : Vector3
## Colision de la bola.
var ballCollisionShape : CollisionShape3D 
## Mesh de la bola.
var ballMesh : MeshInstance3D 
## Rigid Body de la bola.
var ballRigidBody : RigidBody3D
var ballType : String 
## Si se encuentra spawneado el rigid body, la informacion no se borra aunque no este
## spawneado.
var spawned : bool



## Inicializa ,con informacion previamente almacenada, una instancia de una bola.
func spawnBall():
	var ballScene : PackedScene = load("res://scenes/objects/ball.tscn")
	var ball = ballScene.instantiate()
	ballMesh = instantiateMesh(GameInfo.Balls[ballName].mesh) 
	
	spawned = true
	ballCollisionShape = ball.get_node("CollisionShape3D")
	ballRigidBody = ball
	_addBallToScene(ball)
	_addMeshToScene(ballMesh)


func _addBallToScene(ball : RigidBody3D):
	add_child(ball)
	ball.position = ballPosition

func _addMeshToScene(meshInstance: MeshInstance3D):
	ballRigidBody.add_child(meshInstance)

	
## Borra la bola en pantalla, pero mantiene su informacion.
func deleteBall():
	spawned = false
	ballRigidBody.queue_free()
	
## Establece la visibilidad de la bola.
func setVisibilityBall(newVisibility : bool):
	get_node("pelota").visible = newVisibility


func instantiateMesh(mesh : String):
	var newMeshScene = load(mesh)
	newMeshScene = newMeshScene.instantiate()
	var newBallMesh = newMeshScene.get_children()[0]
	newMeshScene.remove_child(newBallMesh)
	return newBallMesh.duplicate()
	
