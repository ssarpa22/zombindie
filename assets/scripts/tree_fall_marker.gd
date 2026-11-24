extends StaticBody3D

func _ready() -> void:
	# Tree fall marker: indicates a fallen tree area
	var marker_width := 1.0
	var marker_height := 0.8
	
# Fallen tree trunk section
var trunk_mesh := BoxMesh.new()
trunk_mesh.size := Vector3(marker_width * 0.3, marker_height * 0.4, marker_width * 0.3)

var trunk_instance := MeshInstance3D.new()
trunk_instance.mesh := trunk_mesh
trunk_instance.name := "TreeTrunk"
trunk_instance.position := Vector3(marker_width * 0.5, marker_height * 0.2, 0)
trunk_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(trunk_instance)

# Branches (simplified)
for i in range(3):
	var branch_mesh := BoxMesh.new()
	branch_mesh.size := Vector3(marker_width * 0.1, marker_height * 0.1, marker_width * 0.2)
	
	var branch_instance := MeshInstance3D.new()
	branch_instance.mesh := branch_mesh
	branch_instance.name := "TreeBranch_%d" % i
	branch_instance.position := Vector3(
		(marker_width * 0.5 - 0.1) * (1 if i == 0 else -1 if i == 1 else 0),
		marker_height * 0.4,
		0
	)
	branch_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(branch_instance)

# Ground impact marks
for i in range(2):
	var impact_mesh := BoxMesh.new()
	impact_mesh.size := Vector3(0.2, 0.02, 0.2)
	
	var impact_instance := MeshInstance3D.new()
	impact_instance.mesh := impact_mesh
	impact_instance.name := "ImpactMark_%d" % i
	impact_instance.position := Vector3(
		-0.2 + i * 0.5,
		0.01,
		- marker_width * 0.3
	)
	impact_instance.material_override := preload("res://assets/materials/palettes.dirt_tres")
	add_child(impact_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(marker_width, marker_height, marker_width)
collision.shape := shape
collision.position := Vector3(marker_width * 0.5, marker_height * 0.5, 0)
add_child(collision)