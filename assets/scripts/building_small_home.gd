extends StaticBody3D

func _ready() -> void:
	# Small single-story home assembled from modular pieces
	
	# Foundation slab
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position = Vector3(0, 0, 0)
	add_child(foundation)
	
	# Exterior walls (1x1 sections forming a small house)
	var wall1 := Wall_1x1.Instance()
	wall1.name = "Wall_FRONT"
	wall1.position = Vector3(0, 1.5, 0)
	add_child(wall1)
	
	var wall2 := Wall_1x1.Instance()
	wall2.name = "Wall_SIDE_LEFT"
	wall2.position = Vector3(-3, 1.5, 0)
	add_child(wall2)
	
	var wall3 := Wall_1x1.Instance()
	wall3.name = "Wall_SIDE_RIGHT"
	wall3.position = Vector3(3, 1.5, 0)
	add_child(wall3)
	
	var wall4 := Wall_1x1.Instance()
	wall4.name = "Wall_BACK"
	wall4.position = Vector3(0, 1.5, -6)
	add_child(wall4)
	
	# Roof
	var roof := Roof_Flat.Instance()
	roof.name = "Roof"
	roof.position = Vector3(0, 3.0, 0)
	add_child(roof)
	
	# Door
	var door := Door_Apartment.Instance()
	door.name = "Door_ENTRANCE"
	door.position = Vector3(0, 1.1, -6.1)
	add_child(door)
	
	# Window
	var window := Opening_Apartment_Window.Instance()
	window.name = "Window_LEFT"
	window.position = Vector3(-2, 0.75, -3)
	add_child(window)
	
	# Other window
	var window2 := Opening_Industrial_Window.Instance()
	window2.name = "Window_RIGHT"
	window2.position = Vector3(2, 0.9, -3)
	add_child(window2)
	
	# Collision
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(7, 6, 8)
	collision.shape = shape
	collision.position = Vector3(0, 3, 0)
	add_child(collision)