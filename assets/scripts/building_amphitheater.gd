extends StaticBody3D

func _ready() -> void:
	# Amphitheater: outdoor performance venue
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Amphitheater wings
var wall1 := Wall_2x1.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_2x1.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -15)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector4(5, 1.5, -5)
add_child(wall3)

# Stage area
var stage_mesh := BoxMesh.new()
stage_mesh.size := Vector3(20.0, 0.5, 10.0)
var stage_instance := MeshInstance3D.new()
stage_instance.mesh := stage_mesh
stage_instance.name := "Stage"
stage_instance.position := Vector3(0, 0.25, 0)
stage_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
add_child(stage_instance)

# Tiered seating (visual)
for i in range(5):
	var seat_mesh := BoxMesh.new()
	seat_mesh.size := Vector3(1.5, 0.5, 1.0)
	var seat_instance := MeshInstance3D.new()
	seat_instance.mesh := seat_mesh
	seat_instance.name := "Seat_%d" % i
	seat_instance.position := Vector3(
		(-5 + i * 1.5),
		0.25 + i * 0.3,
		-5
	)
	seat_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
	add_child(seat_instance)

# Windows
for i in range(3):
	var win := Opening_Apartment_Window.Instance()
	win.name := "Window_%d" % i
	win.position := Vector3(-1 + i * 2, 0.75, -3)
	add_child(win)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(20.0, 6.0, 15.0)
collision.shape := shape
collision.position := Vector3(0, 3.0, 0)
add_child(collision)