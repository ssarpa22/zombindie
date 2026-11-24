extends StaticBody3D

func _ready() -> void:
	# No Right Turn sign: circular red sign with right arrow
	var sign_diameter := 0.6
	var post_height := 2.0
	
# Post
var post_mesh := CylinderMesh.new()
post_mesh.top_radius := 0.08
post_mesh.bottom_radius := 0.08
post_mesh.height := post_height
post_mesh.radial_segments := 6

var post_instance := MeshInstance3D.new()
post_instance.mesh := post_mesh
post_instance.name := "NoRightTurnPost"
post_instance.position := Vector3(0, post_height * 0.5, 0)
post_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(post_instance)

# Sign circle
var sign_mesh := BoxMesh.new()
sign_mesh.size := Vector3(sign_diameter, sign_diameter, 0.02)

var sign_instance := MeshInstance3D.new()
sign_instance.mesh := sign_mesh
sign_instance.name := "NoRightTurnSign"
sign_instance.position := Vector3(0, post_height * 0.5, sign_diameter * 0.5 + 0.01)
sign_instance.material_override := StandardMaterial3D.new()
sign_instance.material_override.albedo_color := Color(1.0, 1.0, 1.0)
sign_instance.material_override.roughness := 0.8
add_child(sign_instance)

# Red circle (approximated)
var circle_mat := StandardMaterial3D.new()
circle_mat.albedo_color := Color(1.0, 1.0, 1.0)
circle_mat.roughness := 1.0
sign_instance.material_override := circle_mat

# Horizontal bar (white)
var bar_mesh := BoxMesh.new()
bar_mesh.size := Vector3(sign_diameter * 0.4, 0.05, sign_diameter * 0.4)

var bar_instance := MeshInstance3D.new()
bar_instance.mesh := bar_mesh
bar_instance.name := "NoRightTurnBar"
bar_instance.position := Vector3(0, post_height * 0.5 - sign_diameter * 0.2, sign_diameter * 0.5 + 0.01)
bar_instance.material_override := StandardMaterial3D.new()
bar_instance.material_override.albedo_color := Color(0.0, 0.0, 0.0)
bar_instance.material_override.roughness := 0.8
add_child(bar_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(sign_diameter * 1.2, post_height + sign_diameter * 1.2, 0.2)
collision.shape := shape
collision.position := Vector3(0, (post_height + sign_diameter) * 0.5, 0)
add_child(collision)