extends StaticBody3D

func _ready() -> void:
	# Taxi Stand: taxi pickup and dispatch
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Taxi stand
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -4)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(2, 1.5, -2)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Taxi waiting area
for i in range(3):
	var seat_mesh := BoxMesh.new()
	seat_mesh.size := Vector3(1.5, 0.1, 0.5)
	var seat_instance := MeshInstance3D.new()
	seat_instance.mesh := seat_mesh
	seat_instance.name := "TaxiSeat_%d" % i
	seat_instance.position := Vector3(i * 1.8, 0.05, -1)
	seat_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(seat_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -2)
add_child(door)

# Windows
for i in range(2):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -1)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(4, 5, 3)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)