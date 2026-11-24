extends StaticBody3D

func _ready() -> void:
	# Fire Lookout Tower: wildfire detection
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Lookout tower
var tower_mesh := CylinderMesh.new()
tower_mesh.top_radius := 0.3
tower_mesh.bottom_radius := 0.3
tower_mesh.height := 12.0
tower_mesh.radial_segments := 6

var tower_instance := MeshInstance3D.new()
tower_instance.mesh := tower_mesh
tower_instance.name := "LookoutTower"
tower_instance.position := Vector3(0, 6.0, 0)
tower_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(tower_instance)

# Platform
var platform_mesh := BoxMesh.new()
platform_mesh.size := Vector3(3.0, 0.2, 3.0)
var platform_instance := MeshInstance3D.new()
platform_instance.mesh := platform_mesh
platform_instance.name := "LookoutPlatform"
platform_instance.position := Vector3(0, 6.1, 0)
platform_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(platform_instance)

# Telescope/observation gear
var scope_mesh := CylinderMesh.new()
scope_mesh.top_radius := 0.15
scope_mesh.bottom_radius := 0.15
scope_mesh.height := 2.0
scope_mesh.radial_segments := 6

var scope_instance := MeshInstance3D.new()
scope_instance.mesh := scope_mesh
scope_instance.name := "FireScope"
scope_instance.position := Vector3(0, 7.5, 0)
scope_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(scope_instance)

# Entry door
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
	win_instance.name := "LookoutWindow_%d" % i
	win_instance.position := Vector3(0, 1.0, -0.5 + i * 0.3)
	win_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(win_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 12.0
collision.shape := shape
collision.position := Vector3(0, 6.0, 0)
add_child(collision)