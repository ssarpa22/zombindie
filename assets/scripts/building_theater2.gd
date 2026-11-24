extends StaticBody3D

func _ready() -> void:
	# Theater 2: additional theater variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Theater wings
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
var roof := Roof_Flat.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 3.5, 0)
add_child(roof)

# Stage area (visual)
var stage_mesh := BoxMesh.new()
stage_mesh.size := Vector3(10.0, 3.0, 0.2)
stage_instance := MeshInstance3D.new()
stage_instance.mesh := stage_mesh
stage_instance.name := "TheaterStage"
stage_instance.position := Vector3(0, 1.5, -3)
stage_instance.material_override := preload("res://assets/materials.palettes.dark_grey_tres")
add_child(stage_instance)

# Entry
var door := Door_DoubleEntrance.Instance()
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