extends StaticBody3D

func _ready() -> void:
	# Fallen log variant: larger
	
# Log body
var log_mesh := CylinderMesh.new()
log_mesh.top_radius := 0.5
log_mesh.bottom_radius := 0.5
log_mesh.height := 4.0
log_mesh.radial_segments := 6

var log_instance := MeshInstance3D.new()
log_instance.mesh := log_mesh
log_instance.name := "LogBody"
log_instance.position := Vector3(0, 2.0, 0)
log_instance.material_override := preload("res://assets/materials.palettes.wood_tres")
add_child(log_instance)

# Moss (visual)
for i in range(3):
	var moss_mesh := SphereMesh.new()
	moss_mesh.radius := 0.2
	moss_mesh.subdivisions_around := 8
	moss_mesh.subdivisions_up := 4

	var moss_instance := MeshInstance3D.new()
	moss_instance.mesh := moss_mesh
	moss_instance.name := "Moss_%d" % i
	moss_instance.position := Vector3(
		sin(i * 2 * PI / 3) * 1.0,
		2.1,
		cos(i * 2 * PI / 3) * 1.0
	)
	moss_instance.material_override := preload("res://assets/materials.palettes.foliage_tres")
	add_child(moss_instance)

# Collision (log only)
var collision := CollisionShape3D.new()
var shape := CylinderShape3D.new()
shape.radius := 0.55
shape.height := 4.1
collision.shape := shape
collision.position := Vector3(0, 2.0, 0)
add_child(collision)