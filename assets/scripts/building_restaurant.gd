extends StaticBody3D

func _ready() -> void:
	# Restaurant: dining establishment
	
	# Foundation slab
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
wall2.position := Vector3(0, 1.5, -10)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector3(5, 1.5, -4)
add_child(wall3)

# Pitched roof
var roof := Roof_Pitched.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Entrance door
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Windows
for i in range(4):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-2 + i * 2, 0.9, -4)
	add_child(win)

# Outdoor seating area (simple)
for i in range(2):
	var table_mesh := BoxMesh.new()
	table_mesh.size := Vector3(0.6, 0.05, 0.6)
	var table_instance := MeshInstance3D.new()
	table_instance.mesh := table_mesh
	table_instance.name := "Table_%d" % i
	table_instance.position := Vector3(i * 1.5, 0.05, -2)
	table_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(table_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(12, 6, 12)
collision.shape := shape
collision.position := Vector3(0, 3, 0)
add_child(collision)