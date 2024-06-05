extends Node
class_name CueObject



@export
var cameraNode : Camera3D 
@export
var cueBall : RigidBody3D 
@export
var cueStick : Node3D

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
@export var MAX_DISTANCE_FORCE = 0.4
@export var MAX_DISTANCE = 0.3
@export var MIN_DISTANCE = 0.04


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
		cueStick.update_cue_charge(ballPosition,direction,distance)
	

	if Input.is_action_just_released("LeftClick"):
		_handle_strike()
		
	
	_oldDirection = direction
	
func applyStrokePower(force : Vector3, _spin : Vector3):
	cueBall.apply_central_impulse(force)
	
	
func getStrokePower(ballPos: Vector3, shotPos: Vector3):
	var MIN_DISTANCE_TO_BALL : float = MIN_DISTANCE *  (MAX_DISTANCE_FORCE/ MAX_DISTANCE)
	var distanceForce : float 
	var forceVariation : float = randf_range(MIN_FORCE_VARIATION,MAX_FORCE_VARIATION)
	var posDifference : Vector3  = ballPos - shotPos
	posDifference[1] = 0
	distance  = posDifference.length()
	direction = posDifference.normalized()
	if distance >= MAX_DISTANCE: 
		distance = MAX_DISTANCE 
	elif distance <= MIN_DISTANCE_TO_BALL:
		distance = 0
	distanceForce = distance * (MAX_DISTANCE_FORCE /MAX_DISTANCE)
	return direction * FORCE_MULTIPLIER * distanceForce * forceVariation


func _on_cue_ball_clicked():
	if  isCueStickActive == false or isCueStickUsed == true: return
	isCueStickUsed = true
	cueStick.change_cue_visibility()

func _handle_strike():
	isCueStickUsed = false
	if distance != 0: 
		applyStrokePower(appliedForce, Vector3.ZERO)
		GameEvent.ball_strike.emit()
	cueStick.change_cue_visibility()

func change_cue_active(value : bool):
	isCueStickActive = value
