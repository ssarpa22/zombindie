extends StaticBody3D

func _ready() -> void:
	# Compressor 2: additional compressor variant
	
	# Compressor base
	var base_mesh := BoxMesh.new()
	base_mesh.size := Vector3(2.0, 0.5, 2.0)
	base_instance := MeshInstance3D.new()
	base_instance.mesh := base_mesh
	base_instance.name := "CompressorBase"
	base_instance.position := Vector3(0, 0.25, 0)
	base_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
	add_child(base_instance)

# Compressor body
var body_mesh := BoxMesh.new()
body_mesh.size := Vector3(2.0, 2.5, 2.0)
body_instance := MeshInstance3D.new()
body_instance.mesh := body_mesh
body_instance.name := "CompressorBody"
body_instance.position := Vector3(0, 1.25, 0)
body_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(body_instance)

# Pump (visual)
var pump_mesh := CylinderMesh.new()
pipe_mesh.top_radius := 0.2
pipe_mesh.bottom_radius := 0.2
pipe_mesh.height := 1.0
pipe_mesh.radial_segments := 6

var pipe_instance := MeshInstance3D.new()
pipe_instance.mesh := pipe_mesh
pipe_instance.name := "Pump"
pipe_instance.position := Vector3(0.8, 1.5, 0)
pipe_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(pipe_instance)

# Pressure gauge (visual)
var gauge_mesh := BoxMesh.new()
gauge_mesh.size := Vector3(0.3, 0.3, 0.1)
gauge_instance := MeshInstance3D.new()
gauge_instance.mesh := gauge_mesh
gauge_instance.name := "Gauge"
gauge_instance.position := Vector3(-0.8, 1.5, 0)
gauge_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(gauge_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(2.5, 3.0, 2.5)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)