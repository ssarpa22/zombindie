extends StaticBody3D

func _ready() -> void:
	# Apartment block: multi-unit building
	
	# Raised foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position = Vector3(0, 0, 0)
	add_child(foundation)
	
	# Long walls forming an apartment block
	var wall1 := Wall_4x1.Instance()
	wall1.name = "Wall_FRONT"
	wall1.position = Vector3(0, 1.5, 0)
	add_child(wall1)
	
	var wall2 := Wall_4x1.Instance()
	wall2.name = "Wall_BACK"
	wall2.position = Vector3(0, 1.5, -12)
	add_child(wall2)
	
	var wall3 := Wall_2x1.Instance()
	wall3.name = "Wall_WING1"
	wall3.position = Vector3(-6, 1.5, -4)
	add_child(wall3)
	
	var wall4 := Wall_2x1.Instance()
	wall4.name = "Wall_WING2"
	wall4.position = Vector3(6, 1.5, -4)
	add_child(wall4)
	
# Multiple windows
	for i in range(6):
		var win := Opening_Industrial_Window.Instance()
		win.name = "Window_%d" % i
		win.position = Vector3(-3 + i * 2, 0.9, -4)
		add_child(win)
	
	var door := Door_DoubleEntrance.Instance()
	door.name = "Door_MAIN"
	door.position = Vector3(0, 1.1, -10)
	add_child(door)
	
	# Corrugated industrial roof
	var roof := Roof_Industrial.Instance()
	roof.name = "Roof"
	roof.position = Vector3(0, 3.5, 0)
	add_child(roof)
	
	# Collision
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(16, 8, 14)
	collision.shape = shape
	collision.position = Vector3(0, 4, 0)
	add_child(collision)