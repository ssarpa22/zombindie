extends StaticBody3D

func _ready() -> void:
	# Fuel Drum 2: additional fuel drum variant
	
	# Drum body
	var body_mesh := CylinderMesh.new()
	body_mesh.top_radius := 0.4
	body_mesh.bottom_radius := 0.4
	body_mesh.height := 0.8
	body_mesh.radial_segments := 8

	var body_instance := MeshInstance3D.new()
	body_instance.mesh := body_mesh
	body_instance.name := "DrumBody"
	body_instance.position := Vector3(0, 0.4, 0)
	body_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(body_instance)

# Hoops (visual)
for i in range(2):
	var hoop_mesh := CylinderMesh.new()
	hoop_mesh.top_radius := 0.45
	hoop_mesh.bottom_radius := 0.45
	hoop_mesh.height := 0.08
	hoop_mesh.radial_segments := 8

	var hoop_instance := MeshInstance3D.new()
	hoop_instance.mesh := hoop_mesh
	hoop_instance.name := "Hoop_%d" % i
	hoop_instance.position := Vector3(0, 0.4 + i * 0.25, 0)
	hoop_instance.material_override := preload("res://assets.materials.palettes.metal_tres")
	add_child(hoop_instance)

# Top rim
var rim_mesh := CylinderMesh.new()
rim_mesh.top_radius := 0.42
rim_mesh.bottom_radius := 0.42
rim_mesh.height := 0.03
rim_mesh.radial_segments := 8

var rim_instance := MeshInstance3D.new()
rim_instance.mesh := rim_mesh
rim_instance.name := "TopRim"
rim_instance.position := Vector3(0, 0.75, 0)
rim_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(rim_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CylinderShape3D.new()
shape.radius := 0.45
shape.height := 0.85
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)