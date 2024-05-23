extends  Node
class_name TurnState 
var state : String
# penalty ov = Penalty can be overwritten 
# penalty ob = penalty can not be overwritten, it's obligatory
var valid_states = ["penalty ov", "penalty ob", "extra turn", "normal"]
	
func _init(valor):
	assert(valor in valid_states, "New state should be a valid state : penalty,extra turn,normal")
	state = valor

func _to_string():
	return state

func change_state(newState : String) :
	match state:
		"penalty ov":
			if newState == "first turn":
				state = "normal"
		"penalty ob":
			pass
		"extra turn":
			if "penalty" in newState:
				state = newState
		"normal":
			if newState != "first turn":
				state = newState
				
func reset():
	state = "normal"
