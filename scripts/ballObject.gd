extends RigidBody3D
## La clase BallObject se encarga de guardar la informacion individual de cada pelota
## y agregarla a la escena principal como nodo hijo de [BallsArray]. [br] [br]
## El arbol de nodos de una bola spawneada se ve asi : [BallObject] -> [RigidBody3D]
## (llamado pelota) -> [CollisionShape3D] y [MeshInstance3D].
class_name BallObject 

var implements = [Interface.Scorable, Interface.Hitable, Interface.NotDroppable]
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
func spawnBall() -> void:
	_ballMesh = instantiateMesh(GameInfo.Balls[get_ball_name()].mesh) 
	add_to_group("allBallObjects")
	set_ball_spawned(true)
	_ballCollisionShape = get_node("CollisionShape3D")
	_ballRigidBody = get_node(".")
	_ballRigidBody.set_position(get_ball_position())
	_ballRigidBody.set_mass(get_ball_mass()) 
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
	GameEvent.ball_exited_playable_area.emit(self)
	deleteBall()

func hit():
	return self

func animate_score():
	set_linear_velocity(linear_velocity * 0.2)
	set_angular_velocity(angular_velocity * 0.2)
	set_collision_mask_value(1,false)
	await get_tree().create_timer(1).timeout
	score()
# Getters and Setters
func set_ball_name(new_name: String) -> void:
	ballName = new_name

func get_ball_name() -> String:
	return ballName

func set_ball_mass(new_mass: float) -> void:
	ballMass = new_mass

func get_ball_mass() -> float:
	return ballMass

func set_ball_position(new_position: Vector3) -> void:
	ballPosition = new_position

func get_ball_position() -> Vector3:
	return ballPosition

func set_ball_type(new_type: String) -> void:
	ballType = new_type

func get_ball_type() -> String:
	return ballType

func set_ball_img(new_img: Texture2D) -> void:
	ballImg = new_img

func get_ball_img() -> Texture2D:
	return ballImg

func set_ball_spawned(is_spawned: bool) -> void:
	spawned = is_spawned

func get_ball_spawned() -> bool:
	return spawned
