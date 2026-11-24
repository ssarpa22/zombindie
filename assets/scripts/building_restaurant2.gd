extends StaticBody3D

func _ready() -> void:
	# Restaurant 2: additional restaurant variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Restaurant wings
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
wall3.position := Vector4(5, 1.5, -5)
add_child(wall3)

# Roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Outdoor seating (visual)
for i in range(3):
	var table_mesh := BoxMesh.new()
	table_mesh.size := Vector3(2.0, 0.5, 1.0)
	var table_instance := MeshInstance3D.new()
	table_instance.mesh := table_mesh
	table_instance.name := "Table_%d" % i
	table_instance.position := Vector3(i * 2.5, 0.25, -1)
	table_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
	add_child(table_instance)

# Entry
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -5)
add_child(door)

# Windows
for i in range(4):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(12, 6, 10)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)