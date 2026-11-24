extends StaticBody3D

func _ready() -> void:
	# Generator 2: additional generator variant
	
	# Generator base
	var base_mesh := BoxMesh.new()
	base_mesh.size := Vector3(1.5, 0.3, 1.5)
	base_instance := MeshInstance3D.new()
	base_instance.mesh := base_mesh
	base_instance.name := "GeneratorBase"
	base_instance.position := Vector3(0, 0.15, 0)
	base_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(base_instance)

# Generator body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(1.5, 2.0, 1.5)
body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "GeneratorBody"
body_instance.position := Vector3(0, 1.0, 0)
body_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(body_instance)

# Control panel (visual)
var panel_mesh := BoxMesh.new()
panel_mesh.size := Vector3(1.0, 1.0, 0.3)
panel_instance := MeshInstance3D.new()
panel_instance.mesh := panel_mesh
panel_instance.name := "ControlPanel"
panel_instance.position := Vector3(0.5, 1.5, 0)
panel_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(panel_instance)

# Fuel pipe (visual)
var pipe_mesh := CylinderMesh.new()
pipe_mesh.top_radius := 0.1
pipe_mesh.bottom_radius := 0.1
pipe_mesh.height := 1.0
pipe_mesh.radial_segments := 6

var pipe_instance := MeshInstance3D.new()
pipe_instance.mesh := pipe_mesh
pipe_instance.name := "FuelPipe"
pipe_instance.position := Vector3(-0.5, 1.0, 0)
pipe_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(pipe_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.0, 2.5, 1.5)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)