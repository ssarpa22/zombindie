extends StaticBody3D

func _ready() -> void:
	# Fence gap section: temporary fencing for construction/closure
	var fence_height := 1.0
	var gap_width := 2.0
	var post_depth := 0.2
	var post_height := 1.5
	
# Posts
for side in [-1, 1]:
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := post_depth
	post_mesh.bottom_radius := post_depth
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "GapFence_Post_%d" % (side == -1 and 1 or 2)
	post_instance.position := Vector3(side * gap_width * 0.5, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(post_instance)

# Top rail
var rail_mesh := BoxMesh.new()
rail_mesh.size := Vector3(gap_width, 0.05, post_depth)

var rail_instance := MeshInstance3D.new()
rail_instance.mesh := rail_mesh
rail_instance.name := "GapFence_Rail"
rail_instance.position := Vector3(gap_width * 0.5, fence_height + 0.05, 0)
rail_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(rail_instance)

# Warning tape (simplified)
var tape_mesh := BoxMesh.new()
tape_mesh.size := Vector3(gap_width, 0.02, 0.01)

var tape_instance := MeshInstance3D.new()
tape_instance.mesh := tape_mesh
tape_instance.name := "GapFence_Tape"
tape_instance.position := Vector3(gap_width * 0.5, fence_height - 0.05, 0.1)
tape_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(tape_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(gap_width, fence_height + 0.1, post_depth * 2)
collision.shape := shape
collision.position := Vector3(gap_width * 0.5, fence_height * 0.5, 0)
add_child(collision)