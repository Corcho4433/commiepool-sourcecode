extends Node

class Scorable:
	func score():
		pass
		
	func animate_score():
		pass


class Hitable:
	func hit():
		pass

class NotDroppable:
	pass

func get_all_descendants(node):
	var all_descendants = [node]
	var children = node.get_children()
	for child in children:
		all_descendants.append_array(get_all_descendants(child))
	return all_descendants
	
func _ready():
	var all_nodes = get_all_descendants(get_tree().current_scene)
	for node in all_nodes:
		check_node(node)
	get_tree().node_added.connect(check_node)
	

func check_node(node):
	if "implements" in node:
		if typeof(node.implements) == TYPE_ARRAY:
			for implementation in node.implements:
				var instance = implementation.new()
				check_implementation(instance, node)
		else:
			var instance = node.implements.new()
			check_implementation(instance, node)
			

func check_implementation(instance, node):
	for method in instance.get_script().get_script_method_list():
		assert(method.name in node, "Interface error: " + node.name 
		+ " does not possess the " + method.name + " method.")
