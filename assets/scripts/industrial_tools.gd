extends StaticBody3D

func _ready() -> void:
	# Tools: hammer, wrench, screwdriver set
	var tool_length := 0.3
	
# Hammer
var hammer_mesh := BoxMesh.new()
hammer_mesh.size := Vector3(tool_length * 0.2, tool_length * 1.2, tool_length * 0.2)

var hammer_instance := MeshInstance3D.new()
hammer_instance.mesh := hammer_mesh
hammer_instance.name := "HammerHead"
hammer_instance.position := Vector3(0, tool_length * 0.6, 0)
hammer_instance.material_override := StandardMaterial3D.new()
hammer_instance.material_override.albedo_color := Color(0.3, 0.3, 0.3)
hammer_instance.material_override.roughness := 0.8
add_child(hammer_instance)

# Hammer handle
var handle_mesh := CylinderMesh.new()
handle_mesh.top_radius := 0.03
handle_mesh.bottom_radius := 0.03
handle_mesh.height := tool_length
handle_mesh.radial_segments := 6

var handle_instance := MeshInstance3D.new()
handle_instance.mesh := handle_mesh
handle_instance.name := "HammerHandle"
handle_instance.position := Vector3(0, tool_length * 0.5, 0)
handle_instance.material_override := StandardMaterial3D.new()
handle_instance.material_override.albedo_color := Color(0.5, 0.4, 0.3)
handle_instance.material_override.roughness := 0.7
add_child(handle_instance)

# Wrench
var wrench_mesh := BoxMesh.new()
wrench_mesh.size := Vector3(tool_length * 0.15, tool_length * 0.4, tool_length * 0.15)

var wrench_instance := MeshInstance3D.new()
wrench_instance.mesh := wrench_mesh
wrench_instance.name := "Wrench"
wrench_instance.position := Vector3(tool_length * 0.7, 0, 0)
wrench_instance.material_override := StandardMaterial3D.new()
wrench_instance.material_override.albedo_color := Color(0.3, 0.3, 0.3)
wrench_instance.material_override.roughness := 0.8
add_child(wrench_instance)

# Screwdriver
var screwdriver_mesh := BoxMesh.new()
screwdriver_mesh.size := Vector3(tool_length * 0.05, tool_length * 1.0, tool_length * 0.05)

var screwdriver_instance := MeshInstance3D.new()
screwdriver_instance.mesh := screwdriver_mesh
screwdriver_instance.name := "Screwdriver"
screwdriver_instance.position := Vector3(tool_length * 1.3, 0, 0)
screwdriver_instance.material_override := StandardMaterial3D.new()
screwdriver_instance.material_override.albedo_color := Color(0.3, 0.3, 0.3)
screwdriver_instance.material_override.roughness := 0.8
add_child(screwdriver_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(tool_length * 1.5, tool_length * 1.2, tool_length * 0.4)
collision.shape := shape
collision.position := Vector3(tool_length * 0.75, tool_length * 0.6, 0)
add_child(collision)