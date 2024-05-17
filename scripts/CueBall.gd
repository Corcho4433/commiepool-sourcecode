extends RigidBody3D
@export var cameraNode : Camera3D

var isDraggable : bool = false
var isDragging : bool = false
var isStriking : bool = false
var bodies : Array = []
signal cue_ball_clicked

func _ready():
	GameEvent.penalty_commited.connect(set_dragging)
	GameEvent.ball_strike.connect(ball_striked)

func _process(_delta):
	if Input.is_action_just_pressed("LeftClick") and isDragging == false:
			emit_signal("cue_ball_clicked")
			isStriking = true
	if Input.is_action_just_released("LeftClick"):
		isStriking = false
		
	if Input.is_action_just_pressed("RightClick") and isDraggable == true and isStriking == false:
		isDragging = true
	
	if Input.is_action_just_released("RightClick") and isDraggable == true:
		handle_drop()
	
	if isDragging == false and isStriking == false: return
	var mousePosition : Vector3 = cameraNode.project_ray_origin(get_viewport().get_mouse_position())
	var ballPosition : Vector3 = position
	ballPosition.y = 0
	mousePosition.y = 0
	var distance = (mousePosition-ballPosition).length()
	
	if distance >= 1: return

	if isDragging :
		var cameraDistanceToTable =  cameraNode.position.y + 0.15
		set_collision_layer_value(1,false)
		global_position = cameraNode.project_position(get_viewport().get_mouse_position(),cameraDistanceToTable)
	
	

func handle_drop():
	for body in get_colliding_bodies():
		if body.name == "pelota":
			return
	set_collision_layer_value(1,true)
	isDragging = false

func _on_body_entered(body):
	if body.name == "pelota":
		GameEvent.cue_ball_hit_ball.emit(body.get_parent().ballName)

func set_dragging():
	isDraggable = true
	
func ball_striked():
	isDraggable = false
