extends Node

signal cue_ball_hit_ball(ball : BallObject)
signal change_turn(turn : int)
signal update_cue_charge(ball_position : Vector3, direction : Vector3, distance : Vector3)
signal cue_used_changed()
signal change_cue_active(value : bool)
signal penalty_commited()
signal ball_strike()
signal on_ball_scored(turn : int, ball_name : BallObject)
signal ball_exited_playable_area(body: Node3D)
signal ball_entered_hole(body:Node3D)
