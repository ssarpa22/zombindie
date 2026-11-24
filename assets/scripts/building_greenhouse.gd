extends StaticBody3D

func _ready() -> void:
	# Greenhouse: plant cultivation facility
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Greenhouse wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -10)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(4, 1.5, -4)
add_child(wall3)

# Glass roof (using industrial roof with glass material override concept)
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Growing beds (visual)
for i in range(5):
	var bed_mesh := BoxMesh.new()
	bed_mesh.size := Vector3(2.0, 0.1, 1.0)
	var bed_instance := MeshInstance3D.new()
	bed_instance.mesh := bed_mesh
	bed_instance.name := "GrowingBed_%d" % i
	bed_instance.position := Vector3(i * 2.2, 0.05, -2)
	bed_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
	add_child(bed_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -3)
add_child(door)

# Large windows
for i in range(3):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.9, -2)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(8, 5, 6)
collision.shape := shape
collision.position := Vector3(0, 2.5, 0)
add_child(collision)