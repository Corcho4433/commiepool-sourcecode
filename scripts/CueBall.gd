extends RigidBody3D
@export var cameraNode : Camera3D

var isDraggable : bool = false
var bodies : Array = []
signal cue_ball_clicked

func _ready():
	GameEvent.penalty_commited.connect(set_dragging)

func _process(_delta):
	if !Input.is_action_pressed("LeftClick") and !Input.is_action_pressed("RightClick"): return
	
	var mousePosition : Vector3 = cameraNode.project_ray_origin(get_viewport().get_mouse_position())
	var ballPosition : Vector3 = position
	ballPosition.y = 0
	mousePosition.y = 0
	var distance = (mousePosition-ballPosition).length()
	
	print(distance)
	if distance >= 1: return
	
	if isDraggable and GameInfo.is_striking == false and Input.is_action_pressed("RightClick"):
		GameInfo.is_dragging = true
		if GameInfo.is_dragging :
			var cameraDistanceToTable =  cameraNode.position.y + 0.15
			set_collision_layer_value(1,false)
			global_position = cameraNode.project_position(get_viewport().get_mouse_position(),cameraDistanceToTable)
		if Input.is_action_just_released("RightClick"):
			handle_drop()

	
	if Input.is_action_just_pressed("LeftClick"):
			emit_signal("cue_ball_clicked")

func handle_drop():
	for body in get_colliding_bodies():
		if body.name == "pelota":
			return
	set_collision_layer_value(1,true)
	GameEvent.change_cue_active.emit(true)
	GameInfo.is_dragging = false

func _on_body_entered(body):
	if body.name == "pelota":
		GameEvent.cue_ball_hit_ball.emit(body.get_parent().ballName)

func set_dragging():
	isDraggable = !isDraggable

