extends RigidBody3D
@export var cameraNode : Camera3D

var isDraggable : bool
var isDragging : bool
var bodies : Array = []
signal cue_ball_clicked

func _ready():
	GameEvent.penalty_commited.connect(set_dragging)

func _process(_delta):
	if isDraggable:		
		if Input.is_action_just_pressed("RightClick"):
			isDragging = true
		if isDragging:
			global_position = cameraNode.project_position(get_viewport().get_mouse_position(),0.985)
		if Input.is_action_just_released("RightClick"):
			handle_drop()

	
	if Input.is_action_just_pressed("LeftClick"):
		var mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
		var ballPosition = position
		var distance = (mousePosition-ballPosition).length()
		if distance <= 0.1:
			emit_signal("cue_ball_clicked")

func handle_drop():
	if bodies.size() == 0 :
		isDraggable = false
		isDragging = false

func _on_body_entered(body):
	if body.name == "pelota":
		GameEvent.cue_ball_hit_ball.emit(body.get_parent().ballName)

func set_dragging():
	isDraggable = true
