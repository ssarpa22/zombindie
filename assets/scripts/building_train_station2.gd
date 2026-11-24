extends StaticBody3D

func _ready() -> void:
	# Train Station 2: additional station variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Station wings
var wall1 := Wall_4x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_4x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -20)
add_child(wall2)

var wall3 := Wall_2x1.Instance()
wall3.name = "Wall_WING"
wall3.position := Vector3(-8, 1.5, -6)
add_child(wall3)

# Roof
var roof := Roof_Industrial.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 5.0, 0)
add_child(roof)

# Additional platforms
for i in range(2):
	var platform_mesh := BoxMesh.new()
	platform_mesh.size := Vector3(5.0, 0.1, 5.0)
	var platform_instance := MeshInstance3D.new()
	platform_instance.mesh := platform_mesh
	platform_instance.name := "Platform_%d" % i
	platform_instance.position := Vector3(i * 6, 0.05, -3)
	platform_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
	add_child(platform_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -8)
add_child(door)

# Windows
for i in range(6):
	var win := Opening_Industrial_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-3 + i * 2, 0.9, -4)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(22, 8, 22)
collision.shape := shape
collision.position := Vector3(0, 5, 0)
add_child(collision)