extends StaticBody3D

func _ready() -> void:
	# Radio Tower: communication tower
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Tower structure
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.2
tower_mesh.bottom_radius := 0.2
tower_mesh.height := 30.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "RadioTower"
tower_instance.position := Vector3(0, 15.0, 0)
tower_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(tower_instance)

# Antenna arrays (visual)
for i in range(6):
	var antenna_mesh := BoxMesh.new()
	antenna_mesh.size := Vector3(0.1, 5.0, 0.1)
	var antenna_instance := MeshInstance3D.new()
	antenna_instance.mesh := antenna_mesh
	antenna_instance.name := "Antenna_%d" % i
	antenna_instance.position := Vector3(
		sin(i * PI / 3) * 8,
		7.5 + i * 0.5,
		cos(i * PI / 3) * 8
	)
	antenna_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(antenna_instance)

# Platform at base
var platform_mesh := BoxMesh.new()
platform_mesh.size := Vector3(3.0, 0.5, 3.0)
var platform_instance := MeshInstance3D.new()
platform_instance.mesh := platform_mesh
platform_instance.name := "TowerPlatform"
platform_instance.position := Vector3(0, 0.25, 0)
platform_instance.material_override := preload("res://assets/materials/palettes.concrete_tres")
add_child(platform_instance)

# Entry (small door at base)
var door := Door_Apartment.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 0.5, -1)
add_child(door)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 30.0
collision.shape := shape
collision.position := Vector3(0, 15.0, 0)
add_child(collision)