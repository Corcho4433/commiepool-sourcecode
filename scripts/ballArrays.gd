extends Node
class_name BallsArray


var StartingArray = ["Ball12","Ball6","Ball15","Ball13","Ball5","Ball4","Ball14","Ball7","Ball11","Ball3","Ball10","Ball2","Ball9"]
var ballsScored : Array[BallObject] = []
var CurrentArray : Array


var firstBallTouched : BallObject 
var touchedBall : bool = false

func _ready():
	GameEvent.cue_ball_hit_ball.connect(cue_ball_collide)
	GameEvent.ball_exited_playable_area.connect(_ball_scored)
	GameEvent.change_turn.connect(turn_changed)
	ShuffleBalls()

func GetStartingArray():
	return StartingArray


		
func ShuffleBalls():
	var SmoothBalls = ["Ball1","Ball2","Ball3","Ball4","Ball5","Ball6","Ball7"]
	var StrippedBall = ["Ball9","Ball10","Ball11","Ball12","Ball13","Ball14","Ball15"]
	var cornerStripped : String = StrippedBall.pick_random()
	var cornerSmooth : String = SmoothBalls.pick_random()
	while cornerSmooth == "Ball1":
		cornerSmooth  = SmoothBalls.pick_random()
	StartingArray.pop_at(StartingArray.find(cornerSmooth))	
	StartingArray.pop_at(StartingArray.find(cornerStripped))
	
	StartingArray.shuffle()
	
	StartingArray.push_front(cornerSmooth)
	StartingArray.insert(4,cornerStripped)
	StartingArray.append("Ball1")
	StartingArray.insert(10,"Ball8")

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
			var newBallObject : PackedScene = load("res://scenes/objects/ball.tscn")
			var ballName : String = StartingArray[index]
			var b = newBallObject.instantiate()
			add_child(b)
			b.ballName = ballName
			b.ballPosition = new_position
			b.ballType = GameInfo.Balls[ballName]["type"]
			b.ballImg = load("res://resources/texturas/Balls_GUI_sprites/"+ ballName.to_lower() + ".png")
			CurrentArray.append(b)
			index += 1

func SpawnBalls():
	for ball : BallObject in CurrentArray:
		if ball.spawned == false:
			ball.spawnBall()

#func ChangeBall(index:int, newBallName : String = "Ball1" , newBallMass : float = 1):
	#var ball : BallObject = CurrentArray[index]
	#var ballMesh : MeshInstance3D = instantiateMesh(newBallName)
	#ball.ballName = newBallName
	#ball.ballMass = newBallMass
	#ball.changeBallMesh(ballMesh)
	#pass
	
func VisibilityTogle(visibility : bool):
	for ball : BallObject in CurrentArray:
		if ball.spawned == true:
			ball.get_node("pelota").visible = visibility
	

func DeleteBall(ball : BallObject):
	var pos = CurrentArray.find(ball)
	ball.deleteBall()
	CurrentArray.pop_at(pos)
	
func checkMovement():
	const MOVEMENT_THRESHOLD : float = 0.01
	var allBalls = get_tree().get_nodes_in_group("allBalls")
	for ballRigidBody : RigidBody3D in allBalls:
		if ballRigidBody.linear_velocity.length() > MOVEMENT_THRESHOLD :
			return false
	return true
	
	
func cue_ball_collide(ball : BallObject):
	if !touchedBall:
		firstBallTouched = ball
		touchedBall = true

func _ball_scored(body):
	var ball : BallObject = body
	ballsScored.append(ball)

func turn_changed(_turn):
	ballsScored = []
	touchedBall = false

