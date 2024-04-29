extends Node
class_name BallsArray


var StartingArray = ["Ball12","Ball6","Ball15","Ball13","Ball5","Ball4","Ball14","Ball7","Ball11","Ball3","Ball8","Ball10","Ball2","Ball9","Ball1"]

var CurrentArray : Array
var MovementThreshold : float = 0.01


func GetStartingArray():
	return StartingArray
	
func GenerateBalls():
	var rows : int = 6
	var dia = 0.03
	var ofsetX = -0.06 #dos veces el diamentro
	var ofsetZ = -0.65 #nashe
	var index = 0
	for col in range(5):
		rows -= 1 
		for row in range(rows): 
			var new_position : Vector3 = Vector3(ofsetX + (row*dia) + (col * dia / 2), -0.105 , ofsetZ + (col*dia))
			var newBallObject = BallObject.new()
			var ballName : String = StartingArray[index]
			var ballMesh : MeshInstance3D = instantiateMesh(ballName)
			add_child(newBallObject)
			newBallObject.setBallMesh(ballMesh)
			newBallObject.setBallName(ballName)
			newBallObject.setBallPosition(new_position)
			CurrentArray.append(newBallObject)
			index += 1

func SpawnBalls():
	for ball : BallObject in CurrentArray:
		if ball.spawned == false:
			ball.spawnBall()


func DeleteBalls():
	for ball : BallObject in CurrentArray:
		CurrentArray = []
		ball.deleteBall()

	

func ChangeBall(index:int, newBallName : String = "Ball1" , newBallMass : float = 1):
	var ball : BallObject = CurrentArray[index]
	var ballMesh : MeshInstance3D = instantiateMesh(newBallName)
	ball.setBallName(newBallName)
	ball.setBallMass(newBallMass)
	ball.changeBallMesh(ballMesh)
	pass
	
func VisibilityTogle(visibility : bool):
	for ball : BallObject in CurrentArray:
		if ball.spawned == true:
			ball.get_node("pelota").visible = visibility
	

func DeleteBall(ball : BallObject):
	var pos = CurrentArray.find(ball)
	ball.deleteBall()
	CurrentArray.pop_at(pos)
	
func checkMovement():
	var allBalls = get_tree().get_nodes_in_group("allBalls")
	for ballRigidBody : RigidBody3D in allBalls:
		if ballRigidBody.linear_velocity.length() > MovementThreshold:
			return false
	return true



func ball_exited_playable_area(body, isCueBall):
	if isCueBall: 
		body.position = Vector3(0,-0.038,0.576)
		body.linear_velocity = Vector3(0,0,0)
		body.angular_velocity = Vector3(0,0,0)
		body.set_collision_mask_value(1,true)
		return
	var ball = body.get_parent()
	DeleteBall(ball)
	pass # Replace with function body.


func ball_entered_hole(body):
	body.set_collision_mask_value(1,false)
	pass # Replace with function body.

func instantiateMesh(ballName : String):
	var ballScene = load(str("res://resources/meshes/bolas/"+ ballName + ".glb"))
	ballScene = ballScene.instantiate()
	var ballMesh = ballScene.get_children()[0]
	ballScene.remove_child(ballMesh)
	return ballMesh
