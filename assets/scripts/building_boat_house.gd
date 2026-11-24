extends StaticBody3D

func _ready() -> void:
	# Boat House: lakeside storage
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Boat house wings
var wall1 := Wall_1x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_1x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -6)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(3, 1.5, -3)
add_child(wall3)

# Roof
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.0, 0)
add_child(roof)

# Boat storage (visual)
for i in range(3):
	var boat_mesh := BoxMesh.new()
	boat_mesh.size := Vector3(3.0, 1.0, 1.0)
	var boat_instance := MeshInstance3D.new()
	boat_instance.mesh := boat_mesh
	boat_instance.name := "Boat_%d" % i
	boat_instance.position := Vector3(i * 3.5, 0.5, -1)
	boat_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(boat_instance)

# Dock
var dock_mesh := BoxMesh.new()
dock_mesh.size := Vector3(5.0, 0.1, 1.0)
var dock_instance := MeshInstance3D.new()
dock_instance.mesh := dock_mesh
dock_instance.name := "Dock"
dock_instance.position := Vector3(0, 0.05, -1)
dock_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
add_child(dock_instance)

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
shape.size := Vector3(6, 5, 4)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)