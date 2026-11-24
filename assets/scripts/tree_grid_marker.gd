extends StaticBody3D

func _ready() -> void:
	# Tree grid marker: placement marker for forest trees
	var marker_size := 0.5
	var post_height := 0.3
	
	# Post
	var post_mesh := CylinderMesh.new()
	post_mesh.top_radius := 0.05
	post_mesh.bottom_radius := 0.05
	post_mesh.height := post_height
	post_mesh.radial_segments := 6
	
	var post_instance := MeshInstance3D.new()
	post_instance.mesh := post_mesh
	post_instance.name := "TreePost"
	post_instance.position := Vector3(0, post_height * 0.5, 0)
	post_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(post_instance)
	
	# Marker top
	var top_mesh := BoxMesh.new()
	top_mesh.size := Vector3(marker_size, 0.02, marker_size)
	
	var top_instance := MeshInstance3D.new()
	top_instance.mesh := top_mesh
	top_instance.name := "TreeMarker"
	top_instance.position := Vector3(0, post_height + 0.01, 0)
	top_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(top_instance)
	
# Direction indicator
var arrow_mesh := BoxMesh.new()
arrow_mesh.size := Vector3(marker_size * 0.3, 0.02, marker_size * 0.1)

var arrow_instance := MeshInstance3D.new()
arrow_instance.mesh := arrow_mesh
arrow_instance.name := "TreeMarkerArrow"
arrow_instance.position := Vector3(0, post_height + 0.03, marker_size * 0.25)
arrow_instance.rotation.z := PI / 4.0
arrow_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(arrow_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(marker_size, post_height + 0.02, marker_size)
collision.shape := shape
collision.position := Vector3(0, post_height * 0.5, 0)
add_child(collision)