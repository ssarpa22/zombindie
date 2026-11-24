extends StaticBody3D

func _ready() -> void:
	# Industrial Tools 2: additional tool variant
	
	# Wrench (visual)
	var wrench_mesh := BoxMesh.new()
	wrench_mesh.size := Vector3(0.3, 0.1, 0.1)
	wrench_instance := MeshInstance3D.new()
	wrench_instance.mesh := wrench_mesh
	wrench_instance.name := "Wrench"
	wrench_instance.position := Vector3(0, 0.5, 0)
	wrench_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(wrench_instance)

# Pliers (visual)
var pliers_mesh := BoxMesh.new()
pliers_mesh.size := Vector3(0.2, 0.1, 0.1)
pliers_instance := MeshInstance3D.new()
pliers_instance.mesh := pliers_mesh
pliers_instance.name := "Pliers"
pliers_instance.position := Vector3(0.3, 0.5, 0)
pliers_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(pliers_instance)

# Hammer head (visual)
var hammer_mesh := BoxMesh.new()
hammer_mesh.size := Vector3(0.2, 0.1, 0.1)
hammer_instance := MeshInstance3D.new()
hammer_instance.mesh := hammer_mesh
hammer_instance.name := "HammerHead"
hammer_instance.position := Vector3(0.6, 0.5, 0)
hammer_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(hammer_instance)

# Handle (visual)
var handle_mesh := CylinderMesh.new()
handle_mesh.top_radius := 0.08
handle_mesh.bottom_radius := 0.08
handle_mesh.height := 0.5
handle_mesh.radial_segments := 6

var handle_instance := MeshInstance3D.new()
handle_instance.mesh := handle_mesh
handle_instance.name := "Handle"
handle_instance.position := Vector3(0.8, 0.5, 0)
handle_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(handle_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(1.0, 1.0, 0.5)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)