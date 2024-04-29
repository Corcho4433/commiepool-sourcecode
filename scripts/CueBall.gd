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

