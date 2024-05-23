extends Area3D
signal ball_entered_hole(body:Node3D)
var collidingBodies : Array[Node3D]
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("allBalls"):
			GameEvent.ball_entered_hole.emit(body)

