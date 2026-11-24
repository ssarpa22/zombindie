extends StaticBody3D

func _ready() -> void:
	# Damaged cottage with porch
	
	# Raised foundation
	var foundation := Floor_RaisedFoundation.Instance()
	foundation.name = "Foundation"
	foundation.position = Vector3(0, 0, 0)
	add_child(foundation)
	
	# Stone/brick walls (using damaged wall variants)
	var wall1 := Wall_Damaged.Instance()
	wall1.name = "Wall_LEFT"
	wall1.position = Vector3(-4, 1.5, 0)
	add_child(wall1)
	
	var wall2 := Wall_Damaged.Instance()
	wall2.name = "Wall_REAR"
	wall2.position = Vector3(0, 1.5, -6)
	add_child(wall2)
	
	var wall3 := Wall_Damaged.Instance()
	wall3.name = "Wall_RIGHT"
	wall3.position = Vector3(4, 1.5, 0)
	add_child(wall3)
	
	# Half wall at front for porch area
	var half_wall := Wall_Half.Instance()
	half_wall.name = "Wall_FrontHalf"
	half_wall.position = Vector3(0, 0.75, 1.5)
	add_child(half_wall)
	
	# Porch
	var porch := Exterior_Porch.Instance()
	porch.name = "Porch"
	porch.position = Vector3(0, 0.1, 1.5)
	add_child(porch)
	
	# Roof with parapet
	var roof := Roof_Parapet.Instance()
	roof.name = "Roof"
	roof.position = Vector3(0, 3.0, 0)
	add_child(roof)
	
	# Door with boarded window
	var door := Door_HospitalInterior.Instance()
	door.name = "Door_ENTRANCE"
	door.position = Vector3(0, 1.1, -6.1)
	add_child(door)
	
	# Boarded window
	var bwindow := Opening_Boarded_Window.Instance()
	bwindow.name = "Window_BOARDED"
	bwindow.position = Vector3(-1, 0.75, -3)
	add_child(bwindow)
	
	# Collision
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(9, 6, 8)
	collision.shape = shape
	collision.position = Vector3(0, 3, 0)
	add_child(collision)