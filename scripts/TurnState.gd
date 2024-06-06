extends  Node
class_name TurnState 
var state : String
var logs = []
# penalty ov = Penalty can be overwritten 
# penalty ob = penalty can not be overwritten, it's obligatory

	
func _init(valor):
	state = valor
	check_state()

func _to_string():
	return state

func change_state(newState : String) :
	assert(newState in ["first turn","miss","hit opponent ball","score cue ball","score own ball"])
	if state == "penalty ob":
		return

	match newState:
		"first turn":
			state = "normal"
		"miss":
			state = "penalty ob"
		"hit opponent ball":
			state = "penalty ov"
		"score cue ball":
			state = "penalty ob"
		"score own ball":
			if "penalty" not in state:
				state = "extra turn"
				
	logs.append(state)
func reset():
	state = "normal"
	print(logs)
	logs = []

func check_state():
	var valid_states = ["penalty ov", "penalty ob", "extra turn", "normal", "first turn"]
	assert(state in valid_states, "New state should be a valid state : penalty,extra turn,normal")
