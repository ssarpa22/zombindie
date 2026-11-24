extends StaticBody3D

func _ready() -> void:
	# World document: readable document entity
	
# Document page
var page_mesh := BoxMesh.new()
page_mesh.size := Vector3(2.0, 2.5, 0.1)
var page_instance := MeshInstance3D.new()
page_instance.mesh := page_mesh
page_instance.name := "DocumentPage"
page_instance.position := Vector3(0, 1.25, 0)
page_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(page_instance)

# Document binding
var binding_mesh := CylinderMesh.new()
binding_mesh.top_radius := 0.1
binding_mesh.bottom_radius := 0.1
binding_mesh.height := 2.5
binding_mesh.radial_segments := 6

var binding_instance := MeshInstance3D.new()
binding_instance.mesh := binding_mesh
binding_instance.name := "DocumentBinding"
binding_instance.position := Vector3(-0.9, 1.25, 0)
binding_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(binding_instance)

# Title text (visual - simplified)
var title_mesh := BoxMesh.new()
title_mesh.size := Vector3(1.5, 0.3, 0.1)
var title_instance := MeshInstance3D.new()
title_instance.mesh := title_mesh
title_instance.name := "Title"
title_instance.position := Vector3(0, 2.3, 0.05)
title_instance.material_override := StandardMaterial3D.new()
title_instance.material_override.albedo_color := Color(0.0, 0.0, 0.0)
add_child(title_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.2, 2.7, 0.2)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Reading world document...")