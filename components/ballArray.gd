extends Node
class_name  BallsArray


var StartingArray = ["Ball12","Ball6","Ball15","Ball13","Ball5","Ball4","Ball14","Ball7","Ball11","Ball3","Ball8","Ball10","Ball2","Ball9","Ball1"]
var CurrentArray : Array


func GetStartingArray():
	return StartingArray
	
func GenerateBalls():
	var rows : int = 6
	var dia = 0.05
	var ofsetX = 0
	var ofsetZ = 0
	var index = 0
	for col in range(5):
		rows -= 1 
		for row in range(rows): 
			var new_position = Vector3(ofsetX + (row*dia) + (col * dia / 2), 0 , ofsetZ + (col*dia))
			var newBallObject = BallObject.new()
			add_child(newBallObject)
			newBallObject.setBallName(StartingArray[index])
			newBallObject.setBallMass(1)
			newBallObject.setBallPosition(new_position)
			CurrentArray.append(newBallObject)
			index += 1

func SpawnBalls():
	for ball : BallObject in CurrentArray:
		if ball.spawned == false:
			ball.spawnBall()


func DeleteBalls():
	for ball : BallObject in CurrentArray:
		if ball.spawned == true:
			ball.deleteBall()
	CurrentArray = []

func ChangeBall(index:int, newBallName : String = "Ball1" , newBallMass : float = 1, newBallTexture : String = "dea"):
	var ball : BallObject = CurrentArray[index]
	ball.setBallName(newBallName)
	ball.setBallMass(1)
	pass
	
	
