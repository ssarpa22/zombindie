extends StaticBody3D

func _ready() -> void:
	# Ruins 3: heavily damaged building
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Ruins walls (severely damaged)
var wall1 := Wall_Damaged.Instance()
wall1.name = "Wall_FRONT"
wall1.position := Vector3(0, 1.5, 0)
add_child(wall1)

var wall2 := Wall_Damaged.Instance()
wall2.name = "Wall_BACK"
wall2.position := Vector3(0, 1.5, -8)
add_child(wall2)

var wall3 := Wall_1x1.Instance()
wall3.name = "Wall_SIDE"
wall3.position := Vector4(5, 1.5, -5)
add_child(wall3)

# Roof (mostly collapsed)
var roof := Roof_Damaged.Instance()
roof.name = "Roof"
roof.position := Vector3(0, 2.0, 0)
add_child(roof)

# Heavy debris everywhere
for i in range(7):
	var debris_mesh := BoxMesh.new()
	var size := 1.0 + i * 0.3
	debris_mesh.size := Vector3(size, 0.3 + i * 0.1, 0.5 + i * 0.1)
	var debris_instance := MeshInstance3D.new()
	debris_instance.mesh := debris_mesh
	debris_instance.name := "Debris_%d" % i
	debris_instance.position := Vector3(
		i * 1.0 - 3,
		0.15,
		-1 + i * 0.2
	)
	debris_instance.material_override := preload("res://assets/materials.palettes.rubble_tres")
	add_child(debris_instance)

# Blocked/boarded entry
var door := Door_Apartment.Instance()
door.name = "Door_BLOCKED"
door.position := Vector3(0, 1.1, -2)
add_child(door)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(8, 4, 5)
collision.shape := shape
collision.position := Vector3(0, 2, 0)
add_child(collision)