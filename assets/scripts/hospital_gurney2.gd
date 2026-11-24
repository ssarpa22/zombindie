extends StaticBody3D

func _ready() -> void:
	# Gurney 2: additional gurney variant
	
# Frame
var frame_mesh := BoxMesh.new()
frame_mesh.size := Vector3(2.0, 0.3, 0.8)
frame_instance := MeshInstance3D.new()
frame_instance.mesh := frame_mesh
frame_instance.name := "GurneyFrame"
frame_instance.position := Vector3(0, 0.15, 0)
frame_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(frame_instance)

# Mattress platform
var platform_mesh := BoxMesh.new()
platform_mesh.size := Vector3(2.0, 0.1, 0.8)
platform_instance := MeshInstance3D.new()
platform_instance.mesh := platform_mesh
platform_instance.name := "MattressPlatform"
platform_instance.position := Vector3(0, 0.1, 0)
platform_instance.material_override := StandardMaterial3D.new()
platform_instance.material_override.albedo_color := Color(0.8, 0.8, 0.8)
add_child(platform_instance)

# Side rails (visual)
for side in [-1, 1]:
	var rail_mesh := BoxMesh.new()
	rail_mesh.size := Vector3(0.1, 1.5, 0.8)
	rail_instance := MeshInstance3D.new()
	rail_instance.mesh := rail_mesh
	rail_instance.name := "Rail_%d" % side
	rail_instance.position := Vector3(side * 0.5, 0.75, 0)
	rail_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(rail_instance)

# IV Pole (visual)
var pole_mesh := CylinderMesh.new()
pole_mesh.top_radius := 0.1
pole_mesh.bottom_radius := 0.1
pole_mesh.height := 2.0
pole_mesh.radial_segments := 6

var pole_instance := MeshInstance3D.new()
pole_instance.mesh := pole_mesh
pole_instance.name := "IVPole"
pole_instance.position := Vector3(0, 2.0, 0)
pole_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(pole_instance)

# Bag hook (visual)
var hook_mesh := BoxMesh.new()
hook_mesh.size := Vector3(0.2, 0.3, 0.2)
hook_instance := MeshInstance3D.new()
hook_instance.mesh := hook_mesh
hook_instance.name := "BagHook"
hook_instance.position := Vector3(0.5, 1.5, 0)
hook_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(hook_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.0, 1.5, 0.8)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)