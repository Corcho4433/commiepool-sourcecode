extends Area3D
signal ball_exited_playable_area(body: Node3D)
var collidingBodies : Array[Node3D]

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	collidingBodies = get_overlapping_bodies()
	if collidingBodies:
		for body in get_overlapping_bodies():
			GameEvent.ball_exited_playable_area.emit(body)
	 		

