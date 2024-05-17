extends Node
class_name CueObject




@export
var cameraNode : Camera3D 
@export
var cueBall : RigidBody3D 




var isCueStickUsed : bool
var isCueStickActive : bool

var ballPosition : Vector3
var mousePosition : Vector3


var appliedForce : Vector3
var _oldDirection : Vector3
var direction : Vector3
var distance : float
@export var FORCE_MULTIPLIER : float = 9
@export var MAX_FORCE_VARIATION : float = 1.1
@export var MIN_FORCE_VARIATION : float = 1



func _ready():
	GameEvent.cue_used_changed.connect(_on_cue_ball_clicked)
	GameEvent.change_cue_active.connect(change_cue_active)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isCueStickActive == false or isCueStickUsed == false: return
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	appliedForce = getStrokePower(ballPosition,mousePosition)
	if _oldDirection != direction:
		GameEvent.update_cue_charge.emit(ballPosition,direction,distance)
	

	if Input.is_action_just_released("LeftClick"):
		_handle_strike()
		
	
	_oldDirection = direction
	
func applyStrokePower(force : Vector3, spin : Vector3):
	cueBall.apply_impulse(force, spin)
	
	
func getStrokePower(ballPos: Vector3, shotPos: Vector3):
	const MAX_DISTANCE : float = GameInfo.MAX_DISTANCE
	const MAX_DISTANCE_FORCE : float = GameInfo.MAX_DISTANCE_FORCE
	const MIN_DISTANCE : float = GameInfo.MIN_DISTANCE *  (MAX_DISTANCE_FORCE/ MAX_DISTANCE)
	var distanceForce : float 
	var forceVariation : float = randf_range(MIN_FORCE_VARIATION,MAX_FORCE_VARIATION)
	var posDifference : Vector3  = ballPos - shotPos
	posDifference[1] = 0
	distance  = posDifference.length()
	direction = posDifference.normalized()
	if distance >= MAX_DISTANCE: 
		distance = MAX_DISTANCE 
	elif distance <= MIN_DISTANCE:
		distance = 0
	distanceForce = distance * (MAX_DISTANCE_FORCE /MAX_DISTANCE)
	return direction * FORCE_MULTIPLIER * distanceForce * forceVariation


func _on_cue_ball_clicked():
	if Input.is_action_pressed("LeftClick") == false or isCueStickActive == false or isCueStickUsed == true or GameInfo.is_dragging == true: return
	isCueStickUsed = true
	GameInfo.is_striking = true
	GameEvent.cue_used_changed.emit()

func _handle_strike():
	isCueStickUsed = false
	if distance != 0: 
		applyStrokePower(appliedForce, Vector3.ZERO)
		GameEvent.ball_strike.emit()
	
	GameInfo.is_striking = false
	GameEvent.cue_used_changed.emit()

func change_cue_active(value : bool):
	isCueStickActive = value
