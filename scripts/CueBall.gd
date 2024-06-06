extends BallObject
@export var cameraNode : Camera3D
@export var strikingDistance : float = 0.2
var isDraggable : bool = false
var isDragging : bool = false
var isStriking : bool = false
signal cue_ball_clicked

func _ready():
	ballName = "CueBall"
	_ballRigidBody = get_node(".")
	ballType = "CueBall"
	GameEvent.penalty_commited.connect(set_dragging)
	GameEvent.ball_strike.connect(ball_striked)

func _process(_delta):
	
	if Input.is_action_just_released("LeftClick"):
		isStriking = false
	if Input.is_action_just_released("RightClick") and isDraggable == true:
		handle_drop()
	
	var mousePosition : Vector3 = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	var ball_position : Vector3 = _ballRigidBody.position
	ballPosition.y = 0
	mousePosition.y = 0
	var distance = (mousePosition-ball_position).length()
	
	if distance >= strikingDistance: return
	if Input.is_action_just_pressed("RightClick") and isDraggable == true and isStriking == false:
		isDragging = true
	if Input.is_action_just_pressed("LeftClick") and isDragging == false and isStriking == false:
		emit_signal("cue_ball_clicked")
		isStriking = true

		
	
	if isDragging == false and isStriking == false: return
	
	
	if isDragging:
		var newPosition =  cameraNode.project_position(get_viewport().get_mouse_position(),1)
		_ballRigidBody.set_collision_layer_value(1,false)
# limites de mesa x = 0.5, z = 1 :VV skibidi toilettt
		newPosition.x = clamp(newPosition.x,-0.44,0.44)
		newPosition.z =  clamp(newPosition.z,-0.902,0.902)
		newPosition.y = -0.131
		_ballRigidBody.global_position = newPosition

func handle_drop():
	for body in _ballRigidBody.get_colliding_bodies():
		if "implements" in body:
			if Interface.NotDroppable in body.implements :
				return
	_ballRigidBody.set_collision_layer_value(1,true)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	isDragging = false

func _on_body_entered(body):
	if "implements" in body:
		if Interface.Hitable in body.implements:
			GameEvent.cue_ball_hit_ball.emit(body.hit())

func set_dragging():
	isDraggable = true
	
func ball_striked():
	isDraggable = false


func animate_score():
	linear_velocity = linear_velocity * 0.2
	angular_velocity = angular_velocity * 0.2
	set_collision_mask_value(1,false)
	await get_tree().create_timer(0.5).timeout
	score()
	await GameEvent.change_turn
	print("ashe")
	freeze = false
	position = Vector3(0,-0.038,0.576)
	set_collision_mask_value(1,true)
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,0,0)
