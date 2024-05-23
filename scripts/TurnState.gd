extends  Node
class_name TurnState 
var state : String
# penalty ov = Penalty can be overwritten 
# penalty ob = penalty can not be overwritten, it's obligatory

	
func _init(valor):
	state = valor

func _to_string():
	return state

func change_state(newState : String) :

	if state == "penalty ob":
		return

	match newState:
		"first turn":
			state = "normal"
		"miss":
			state = "penalty ob"
		"hit opponent ball":
			state = "penalty ov"
		"score own ball":
			state = "extra turn"
		"score cue ball":
			state = "penalty ob"


func reset():
	state = "normal"

func check_state():
	var valid_states = ["penalty ov", "penalty ob", "extra turn", "normal", "first turn"]
	assert(state in valid_states, "New state should be a valid state : penalty,extra turn,normal")
