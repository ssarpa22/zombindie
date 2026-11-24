extends StaticBody3D

func _ready() -> void:
	# Watchtower 2: additional watchtower variant
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Tower structure
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.3
tower_mesh.bottom_radius := 0.3
tower_mesh.height := 10.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "Watchtower2"
tower_instance.position := Vector3(0, 5.0, 0)
tower_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(tower_instance)

# Platform
var platform_mesh := BoxMesh.new()
platform_mesh.size := Vector3(3.0, 0.5, 3.0)
var platform_instance := MeshInstance3D.new()
platform_instance.mesh := platform_mesh
platform_instance.name := "WatchtowerPlatform2"
platform_instance.position := Vector3(0, 2.5, 0)
platform_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(platform_instance)

# Guard station (visual)
var guard_mesh := BoxMesh.new()
guard_mesh.size := Vector3(2.0, 1.5, 1.0)
var guard_instance := MeshInstance3D.new()
guard_instance.mesh := guard_mesh
guard_instance.name := "GuardStation2"
guard_instance.position := Vector3(0, 1.0, 0)
guard_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(guard_instance)

# Entry
var door := Door_Security.Instance()
door.name = "Door_ENTRANCE"
door.position := Vector3(0, 1.1, -1)
add_child(door)

# Windows (small, near base)
for i in range(2):
	var win_mesh := BoxMesh.new()
	win_mesh.size := Vector3(0.5, 0.8, 0.2)
	var win_instance := MeshInstance3D.new()
	win_instance.mesh := win_mesh
	win_instance.name := "WatchtowerWindow2_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 5.0
collision.shape := shape
collision.position := Vector3(0, 2.5, 0)
add_child(collision)