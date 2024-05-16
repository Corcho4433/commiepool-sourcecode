extends Node
class_name CueObject

signal ball_strike 


@export
var cameraNode : Camera3D 
@export
var cueBall : RigidBody3D 

@export 
var chargeBar : RichTextLabel 
var chargeBarPercentage : int
var oldChargeBarPercentage : int



var isCueStickUsed : bool
var isCueStickActive : bool

var ballPosition : Vector3
var mousePosition : Vector3


var appliedForce : Vector3
var oldDirection : Vector3
var direction : Vector3
var distance : float
@export var FORCE_MULTIPLIER : float = 9
@export var MAX_FORCE_VARIATION : float = 1.1
@export var MIN_FORCE_VARIATION : float = 1
const  MAX_DISTANCE : float = 0.4




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isCueStickActive == false or isCueStickUsed == false: return
	mousePosition = cameraNode.project_position(get_viewport().get_mouse_position(),1)
	ballPosition = cueBall.position
	appliedForce = getStrokePower(ballPosition,mousePosition)
	if oldDirection != direction:
		GameEvent.update_cue_charge.emit(ballPosition,direction,distance)


	if Input.is_action_just_released("LeftClick"):
		isCueStickUsed = false
		chargeBar.visible = false
		applyStrokePower(appliedForce, Vector3.ZERO)
		emit_signal("ball_strike")
		GameEvent.cue_used_changed.emit()
	
	oldDirection = direction
	
func applyStrokePower(force : Vector3, spin : Vector3):
	cueBall.apply_impulse(force, spin)
	
func getStrokePower(ballPos: Vector3, shotPos: Vector3):
	var forceVariation : float = randf_range(MIN_FORCE_VARIATION,MAX_FORCE_VARIATION)
	var posDifference : Vector3  = ballPos - shotPos
	posDifference[1] = 0
	distance = posDifference.length()
	direction = posDifference.normalized()
	if distance >= MAX_DISTANCE: distance = MAX_DISTANCE
	return direction * FORCE_MULTIPLIER * distance * forceVariation


func _on_cue_ball_clicked():
	if Input.is_action_pressed("LeftClick") == false or isCueStickActive == false or isCueStickUsed == true: return
	isCueStickUsed = true
	GameEvent.cue_used_changed.emit()


