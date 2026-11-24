extends StaticBody3D

func _ready() -> void:
	# Metal fire escape: external stairs with landing and railings
	var total_height := 3.0
	var step_depth := 0.3
	var step_count := 6
	
	# Main stair stringers (two sides)
	var left_mesh := BoxMesh.new()
	left_mesh.size = Vector3(0.2, total_height, 0.5)
	var left_instance = MeshInstance3D.new()
	left_instance.mesh = left_mesh
	left_instance.name = "FireEscapeLeftStringer"
	left_instance.position = Vector3(-0.75, total_height * 0.5, 0)
	left_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(left_instance)
	
	var right_mesh := BoxMesh.new()
	right_mesh.size = Vector3(0.2, total_height, 0.5)
	var right_instance = MeshInstance3D.new()
	right_instance.mesh = right_mesh
	right_instance.name = "FireEscapeRightStringer"
	right_instance.position = Vector3(0.75, total_height * 0.5, 0)
	right_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(right_instance)
	
	# Steps
	for i in range(step_count):
		var step_mesh := BoxMesh.new()
		step_mesh.size = Vector3(1.0, 0.2, step_depth)
		var step_instance = MeshInstance3D.new()
		step_instance.mesh = step_mesh
		step_instance.name = "FireEscapeStep%d" % i
		step_instance.position = Vector3(0, (i + 1) * 0.2 - total_height * 0.5 + 0.1, i * step_depth)
		step_instance.material_override = preload("res://assets/materials/palettes.asphalt_tres")
		add_child(step_instance)
	
	# Top landing
	var landing_mesh := BoxMesh.new()
	landing_mesh.size = Vector3(2.0, 0.1, 2.0)
	var landing_instance = MeshInstance3D.new()
	landing_instance.mesh = landing_mesh
	landing_instance.name = "FireEscape Landing"
	landing_instance.position = Vector3(0, total_height - 0.1, (step_count - 1) * step_depth)
	add_child(landing_instance)
	
	# Railing
	var railing_mesh := BoxMesh.new()
	railing_mesh.size = Vector3(0.1, 3.5, 2.5)
	var railing_instance = MeshInstance3D.new()
	railing_instance.mesh = railing_mesh
	railing_instance.name = "FireEscapeRailing"
	railing_instance.position = Vector3(0, 1.75, 2.25)
	railing_instance.material_override = preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(railing_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.5, total_height, (step_count - 1) * step_depth + 2.0)
	collision.shape = shape
	collision.position = Vector3(0, total_height * 0.5, (step_count - 1) * step_depth * 0.5)
	add_child(collision)