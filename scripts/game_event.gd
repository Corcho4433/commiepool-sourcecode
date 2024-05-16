extends Node

signal cue_ball_hit_ball(ball_name : String)
signal change_turn(turn : int)
signal update_cue_charge(ball_position : Vector3, direction : Vector3, distance : Vector3)
signal cue_used_changed()
#penalty comited no esta programada ashe
signal penalty_commited()
signal on_ball_scored(turn : int, ball : BallObject)

const MAX_DISTANCE = 0.4 
const MIN_DISTANCE = 0.02

const PLAYER_ONE = 1
const PLAYER_TWO = 2

var infoPlayer = {
	PLAYER_ONE: {"Balls": []},
	PLAYER_TWO: {"Balls": []},
}
