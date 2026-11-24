extends StaticBody3D

func _ready() -> void:
	# Wolf animal entity
	
# Body
var body_mesh := CylinderMesh.new()
body_mesh.top_radius := 0.6
body_mesh.bottom_radius := 0.6
body_mesh.height := 1.0
body_mesh.radial_segments := 8

var body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "Body"
body_instance.position := Vector3(0, 0.5, 0)
body_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
add_child(body_instance)

# Fur texture (visual - simplified)
var fur_color := Color(0.3, 0.3, 0.3)
var body_material := StandardMaterial3D.new()
body_material.albedo_color := fur_color
body_material.roughness := 0.7
body_instance.material_override := body_material

# Tail (visual)
var tail_mesh := CylinderMesh.new()
tail_mesh.top_radius := 0.1
tail_mesh.bottom_radius := 0.1
tail_mesh.height := 0.4
tail_mesh.radial_segments := 6

var tail_instance := MeshInstance3D.new()
tail_instance.mesh := tail_mesh
tail_instance.name := "Tail"
tail_instance.position := Vector3(0, 0.3, -0.3)
tail_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
add_child(tail_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.6
shape.height := 1.0
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)