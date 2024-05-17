extends Node

signal cue_ball_hit_ball(ball_name : String)
signal change_turn(turn : int)
signal update_cue_charge(ball_position : Vector3, direction : Vector3, distance : Vector3)
signal cue_used_changed()
#penalty comited no esta programada ashe
signal penalty_commited()
signal on_ball_scored(turn : int, ball : BallObject)
signal freeze_balls()
