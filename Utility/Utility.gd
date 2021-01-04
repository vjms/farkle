extends Node

func children_of_type(parent, type, array):
	for child in parent.get_children():
		if type in child.get_name():
			array.append(child)
		children_of_type(child, type, array)
