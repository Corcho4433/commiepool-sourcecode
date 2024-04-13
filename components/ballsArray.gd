extends Node
class_name  BallsArray


var StartingArray = ["Ball12","Ball6","Ball15","Ball13","Ball5","Ball4","Ball14","Ball7","Ball11","Ball3","Ball8","Ball10","Ball2","Ball9","Ball1"]
var CurrentArray : Array

func addNewBall(index: int, NewBall: BallObject):
	CurrentArray.append(NewBall) 

func GetStartingArray():
	return StartingArray

func updateArray():
	CurrentArray = []
