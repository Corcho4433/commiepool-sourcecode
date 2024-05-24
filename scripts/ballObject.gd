extends RigidBody3D
## La clase BallObject se encarga de guardar la informacion individual de cada pelota
## y agregarla a la escena principal como nodo hijo de [BallsArray]. [br] [br]
## El arbol de nodos de una bola spawneada se ve asi : [BallObject] -> [RigidBody3D]
## (llamado pelota) -> [CollisionShape3D] y [MeshInstance3D].
class_name BallObject 

var implements = [Interface.Scorable, Interface.Holeable, Interface.Hitable]
## Nombre de la bola.
var ballName : String
## Masa de la bola, por default 1.
var ballMass : float
## Posicion de spawn de la bola, cambiar este valor no actualiza la posicion.
var ballPosition : Vector3
## Colision de la bola.
var _ballCollisionShape : CollisionShape3D 
## Mesh de la bola.
var _ballMesh : MeshInstance3D 
## Rigid Body de la bola.
var _ballRigidBody : RigidBody3D
var ballType : String 
## Si se encuentra spawneado el rigid body, la informacion no se borra aunque no este
## spawneado.
var spawned : bool

var ballImg : Texture2D



## Inicializa ,con informacion previamente almacenada, una instancia de una bola.
func spawnBall():
	_ballMesh = instantiateMesh(GameInfo.Balls[ballName].mesh) 
	add_to_group("allBallObjects")
	spawned = true
	_ballCollisionShape = get_node("CollisionShape3D")
	_ballRigidBody = get_node(".")
	_ballRigidBody.position = ballPosition
	_addMeshToScene(_ballMesh)



func _addMeshToScene(meshInstance: MeshInstance3D):
	_ballRigidBody.add_child(meshInstance)

	
## Borra la bola en pantalla, pero mantiene su informacion.
func deleteBall():
	linear_velocity = Vector3(0,0,0)
	freeze = true
	spawned = false

func instantiateMesh(mesh : String):
	var newMeshScene = load(mesh)
	newMeshScene = newMeshScene.instantiate()
	var newBallMesh = newMeshScene.get_children()[0]
	newMeshScene.remove_child(newBallMesh)
	return newBallMesh.duplicate()

func _to_string():
	return ballName

func score():
	deleteBall()

func hit():
	return self

func disable_collision():
	set_collision_mask_value(1,false)
