extends StaticBody3D

func _ready() -> void:
	# Concrete steps: individual steps with nosing
	var step_count := 5
	var step_height := 0.2
	var step_depth := 0.3
	var total_height := step_count * step_height
	
	for i in range(step_count):
		var step_mesh := BoxMesh.new()
		step_mesh.size = Vector3(1.0, step_height, step_depth)
		var step_instance = MeshInstance3D.new()
		step_instance.mesh = step_mesh
		step_instance.name = "ConcreteStep%d" % i
		step_instance.position = Vector3(0, step_height * (i + 0.5) - total_height * 0.5, i * step_depth)
		step_instance.material_override = preload("res://assets/materials/palettes/concrete_tres")
		add_child(step_instance)
		
		# Step nosing (small overhang)
		var nosing_mesh := BoxMesh.new()
		nosing_mesh.size = Vector3(1.05, 0.03, step_depth)
		var nosing_instance = MeshInstance3D.new()
		nosing_instance.mesh = nosing_mesh
		nosing_instance.name = "StepNosing%d" % i
		nosing_instance.position = Vector3(0, step_height * (i + 1) - total_height * 0.5 + 0.015, i * step_depth)
		nosing_instance.material_override = preload("res://assets/materials/palettes/asphalt_tres")
		add_child(nosing_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.0, total_height, step_depth * step_count)
	collision.shape = shape
	collision.position = Vector3(0, total_height * 0.5, (step_count - 1) * step_depth * 0.5)
	add_child(collision)