extends RigidBody3D
@export
var cameraNode : Camera3D
signal cue_ball_clicked

func _process(_delta):

	
	if Input.is_action_pressed("LeftClick"):
		var mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
		var ballPosition = position
		var distance = (mousePosition-ballPosition).length()
		if distance <= 0.1:
			emit_signal("cue_ball_clicked")


func _on_body_entered(body):
	if body.name == "pelota":
		GameEvent.cue_ball_hit_ball.emit(body.get_parent().ballName)
	pass # Replace with function body.
