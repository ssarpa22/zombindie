extends StaticBody3D

func _ready() -> void:
	# Fire escape segment: intermediate landing and stairs for external building access
	var landing_length := 2.0
	var landing_depth := 1.0
	var total_height := 3.0
	
	# Landing platform
	var landing_mesh := BoxMesh.new()
	landing_mesh.size := Vector3(landing_length, 0.1, landing_depth)
	
	var landing_instance := MeshInstance3D.new()
	landing_instance.mesh := landing_mesh
	landing_instance.name := "FireEscLanding"
	landing_instance.position := Vector3(landing_length * 0.5, 0.05, 0)
	landing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(landing_instance)
	
# Stairs down from landing
	var step_count := 4
	var step_depth := total_height / step_count
	
	for i in range(step_count):
		var step_mesh := BoxMesh.new()
		step_mesh.size := Vector3(1.0, step_depth, 0.3)
		
		var step_instance := MeshInstance3D.new()
		step_instance.mesh := step_mesh
		step_instance.name := "FireEscStep_%d" % i
		step_instance.position := Vector3(
			landing_length * 0.5 - 0.5,
			step_depth * (i + 1) * 0.5 - total_height * 0.5 + 0.05,
			i * 0.3 - landing_depth * 0.5 + 0.15
		)
		step_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
		add_child(step_instance)
	
# Railing along the stairs
	var railing_mesh := BoxMesh.new()
	railing_mesh.size := Vector3(0.1, total_height, 0.1)
	
	var railing_instance := MeshInstance3D.new()
	railing_instance.mesh := railing_mesh
	railing_instance.name := "FireEscRailing"
	railing_instance.position := Vector3(landing_length * 0.5 + 0.5, total_height * 0.5, 0)
	railing_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(railing_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(landing_length, total_height, landing_depth + 0.3)
	collision.shape := shape
	collision.position := Vector3(landing_length * 0.5, total_height * 0.5, landing_depth * 0.5)
	add_child(collision)