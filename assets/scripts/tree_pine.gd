extends StaticBody3D

func _ready() -> void:
	# Pine Tree: conifer tree for forest scenes
	var trunk_height := 5.0
	var trunk_radius := 0.2
	
# Trunk
var trunk_mesh := CylinderMesh.new()
trunk_mesh.top_radius := trunk_radius
trunk_mesh.bottom_radius := trunk_radius
trunk_mesh.height := trunk_height
trunk_mesh.radial_segments := 6

var trunk_instance := MeshInstance3D.new()
trunk_instance.mesh := trunk_mesh
trunk_instance.name := "PineTrunk"
trunk_instance.position := Vector3(0, trunk_height * 0.5, 0)
trunk_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(trunk_instance)

# Tree canopy - layered branches
for layer in range(3):
	var canopy_radius := trunk_radius + layer * 0.3
	var canopy_height := 0.8
	
	var canopy_mesh := CylinderMesh.new()
	canopy_mesh.top_radius := canopy_radius
	canopy_mesh.bottom_radius := canopy_radius * 0.5
	canopy_mesh.height := canopy_height
	canopy_mesh.radial_segments := 6
	
	var canopy_instance := MeshInstance3D.new()
	canopy_instance.mesh := canopy_mesh
	canopy_instance.name := "PineCanopyLayer%d" % layer
	canopy_instance.position := Vector3(0, trunk_height + canopy_height * 0.5 + layer * 0.4, 0)
	canopy_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(canopy_instance)

# Pine needles (visual planes)
for i in range(10):
	var needle_mesh := BoxMesh.new()
	needle_mesh.size := Vector3(0.1, 0.05, 3.0)
	
	var needle_instance := MeshInstance3D.new()
	needle_instance.mesh := needle_mesh
	needle_instance.name := "PineNeedle%d" % i
	needle_instance.position := Vector3(
		(canopy_radius * 0.7) * sin(i * PI / 5),
		trunk_height + 0.5 + (i % 3) * 0.2,
		(canopy_radius * 0.7) * cos(i * PI / 5)
	)
	needle_instance.material_override := preload("res://assets/materials/palettes.green_tress")
	add_child(needle_instance)

var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := trunk_radius
shape.height := trunk_height + 2.0
collision.shape := shape
collision.position := Vector3(0, trunk_height * 0.5 + 1.0, 0)
add_child(collision)