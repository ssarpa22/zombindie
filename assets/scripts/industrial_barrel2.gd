extends StaticBody3D

func _ready() -> void:
	# Barrel 2: additional barrel variant
	
	# Barrel body
	var body_mesh := CylinderMesh.new()
	body_mesh.top_radius := 0.5
	body_mesh.bottom_radius := 0.5
	body_mesh.height := 1.0
	body_mesh.radial_segments := 8

	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "BarrelBody"
	body_instance.position := Vector3(0, 0.5, 0)
	body_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(body_instance)

# Hoops (visual)
for i in range(2):
	var hoop_mesh := CylinderMesh.new()
	hoop_mesh.top_radius := 0.55
	hoop_mesh.bottom_radius := 0.55
	hoop_mesh.height := 0.1
	hoop_mesh.radial_segments := 8

	var hoop_instance := MeshInstance3D.new()
	hoop_instance.mesh := hoop_mesh
	hoop_instance.name := "Hoop_%d" % i
	hoop_instance.position := Vector3(0, 0.5 + i * 0.3, 0)
	hoop_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(hoop_instance)

# Top rim
var rim_mesh := CylinderMesh.new()
rim_mesh.top_radius := 0.52
rim_mesh.bottom_radius := 0.52
rim_mesh.height := 0.05
rim_mesh.radial_segments := 8

var rim_instance := MeshInstance3D.new()
rim_instance.mesh := rim_mesh
rim_instance.name := "TopRim"
rim_instance.position := Vector3(0, 0.95, 0)
rim_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(rim_instance)

# Label/branding (visual)
for i in range(3):
	var label_mesh := BoxMesh.new()
	label_mesh.size := Vector3(0.5, 0.1, 0.1)
	var label_instance := MeshInstance3D.new()
	label_instance.mesh := label_mesh
	label_instance.name := "Label_%d" % i
	label_instance.position := Vector3(
		(cos(i * 2 * PI / 3) * 0.4),
		0.55,
		(sin(i * 2 * PI / 3) * 0.4)
	)
	label_instance.material_override := StandardMaterial3D.new()
	label_instance.material_override.albedo_color := Color(1.0, 1.0, 1.0)
	add_child(label_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CylinderShape3D.new()
shape.radius := 0.55
shape.height := 1.1
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)