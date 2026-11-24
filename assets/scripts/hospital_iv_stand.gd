extends StaticBody3D

func _ready() -> void:
	# IV Stand: intravenous stand on wheels
	var total_height := 1.8
	var base_diameter := 0.4
	
# Base ring
var base_mesh := CylinderMesh.new()
base_mesh.top_radius := base_diameter
base_mesh.bottom_radius := base_diameter
base_mesh.height := 0.1
base_mesh.radial_segments := 6

var base_instance := MeshInstance3D.new()
base_instance.mesh := base_mesh
base_instance.name := "IVStandBase"
base_instance.position := Vector3(0, 0.05, 0)
base_instance.material_override := preload("res://assets/materials/palettes.metal_tres")
add_child(base_instance)

# Main post
var post_mesh := CylinderMesh.new()
post_mesh.top_radius := 0.1
post_mesh.bottom_radius := 0.1
post_mesh.height := total_height - 0.1
post_mesh.radial_segments := 6

var post_instance := MeshInstance3D.new()
post_instance.mesh := post_mesh
post_instance.name := "IVStandPost"
post_instance.position := Vector3(0, total_height * 0.5, 0)
post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(post_instance)

# IV pole arms (3 levels)
for level in [0.3, 0.6, 0.9]:
	var arm_mesh := BoxMesh.new()
	arm_mesh.size := Vector3(0.05, total_height * 0.2, 0.05)

	var arm_instance := MeshInstance3D.new()
	arm_instance.mesh := arm_mesh
	arm_instance.name := "IVArm_%d" % level
	arm_instance.position := Vector3(0, total_height * level, 0)
	arm_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(arm_instance)

# IV bag holder (top)
var bag_mesh := BoxMesh.new()
bag_mesh.size := Vector3(0.1, 0.05, 0.05)

var bag_instance := MeshInstance3D.new()
bag_instance.mesh := bag_mesh
bag_instance.name := "IVBag"
bag_instance.position := Vector3(0, total_height - 0.05, 0)
bag_instance.material_override := StandardMaterial3D.new()
bag_instance.material_override.albedo_color := Color(0.1, 0.2, 0.4)
bag_instance.material_override.roughness := 0.8
add_child(bag_instance)

# Bobber/weight visual
var weight_mesh := SphereMesh.new()
weight_mesh.radius := 0.05

var weight_instance := MeshInstance3D.new()
weight_instance.mesh := weight_mesh
weight_instance.name := "IVWeight"
weight_instance.position := Vector3(0, total_height * 0.3, 0)
weight_instance.material_override := StandardMaterial3D.new()
weight_instance.material_override.albedo_color := Color(0.1, 0.1, 0.1)
weight_instance.material_override.roughness := 1.0
add_child(weight_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := base_diameter * 0.5
shape.height := total_height
collision.shape := shape
collision.position := Vector3(0, total_height * 0.5, 0)
add_child(collision)