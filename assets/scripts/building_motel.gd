extends StaticBody3D

func _ready() -> void:
	# Motel: roadside accommodation
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Motel wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -12)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(4, 1.5, -4)
add_child(wall3)

# Flat roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Motel units (simple visual)
for i in range(3):
	var unit_mesh := BoxMesh.new()
	unit_mesh.size := Vector3(3.0, 2.5, 3.0)
	var unit_instance := MeshInstance3D.new()
	unit_instance.mesh := unit_mesh
	unit_instance.name := "MotelUnit_%d" % i
	unit_instance.position := Vector3(i * 4, 1.25, -2)
	unit_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(unit_instance)

# Office window
for i in range(3):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -3)
	add_child(win)

# Outdoor parking area
for i in range(3):
	var spot_mesh := BoxMesh.new()
	spot_mesh.size := Vector3(2.5, 0.1, 5.0)
	var spot_instance := MeshInstance3D.new()
	spot_instance.mesh := spot_mesh
	spot_instance.name := "ParkingSpot_%d" % i
	spot_instance.position := Vector3(i * 2.8, 0.05, -5)
	spot_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(spot_instance)

# Entry door
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -6)
add_child(door)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(12, 6, 12)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)