extends Node
class_name  BallsArray


var CurrentArray = ["Ball12","Ball6","Ball15","Ball13","Ball5","Ball4","Ball14","Ball7","Ball11","Ball3","Ball8","Ball10","Ball2","Ball9","Ball1"]

func ChangeArray(index: int, NewBall: String):
	CurrentArray[index] = NewBall

func GetArray():
	return CurrentArray
