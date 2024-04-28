extends Node
class_name TableClass

@export var TableBallsArray : BallsArray
@export var BallsScene : PackedScene

func createBalls():
	var rows : int = 6
	var dia = 0.5
	var ofsetX = -1
	var ofsetZ = -5
	var index = 0 
	for col in range(5):
		rows -= 1 
		for row in range(rows): 
			var b = BallsScene.instantiate()
			var new_position = Vector3(ofsetX + (row*dia) + (col * dia / 2), 0 , ofsetZ + (col*dia))
			var newBallObject = BallObject.new() 
			add_child(b)
			b.add_child(newBallObject)
			newBallObject.create_ball(1, TableBallsArray.GetStartingArray()[index], "nashe", index)
			b.position = new_position
			index += 1

func deleteBalls():
	for BallNode in TableBallsArray.CurrentArray:
		BallNode.get_parent().queue_free()
	TableBallsArray.updateArray()
	
	pass

func _process(delta):
	pass
