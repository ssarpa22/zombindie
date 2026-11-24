extends StaticBody3D

func _ready() -> void:
	# Awning/canopy: extends from building, supported by columns
	var awning_mesh := BoxMesh.new()
	awning_mesh.size = Vector3(3.0, 0.2, 4.0)
	
	var awning_instance = MeshInstance3D.new()
	awning_instance.mesh = awning_mesh
	awning_instance.name = "AwningTop"
	awning_instance.position = Vector3(0, 0.1, 0)
	add_child(awning_instance)
	
	# Awning support columns (front)
	for side in [-1, 1]:
		var col_mesh := BoxMesh.new()
		col_mesh.size = Vector3(0.2, 2.0, 0.2)
		var col_instance = MeshInstance3D.new()
		col_instance.mesh = col_mesh
		col_instance.name = "AwningColumn%d" % (side == -1 and 1 or 2)
		col_instance.position = Vector3(side * 1.5, 1.0, 2.0)
		col_instance.material_override = preload("res://assets/materials/palettes/painted_metal_tres")
		add_child(col_instance)
	
	# Rope/visual detail
	var rope_mesh := BoxMesh.new()
	rope_mesh.size = Vector3(0.08, 3.5, 0.08)
	var rope_instance = MeshInstance3D.new()
	rope_instance.mesh = rope_mesh
	rope_instance.name = "AwningRope"
	rope_instance.position = Vector3(0, 1.75, 2.05)
	rope_instance.material_override = preload("res://assets/materials/palettes/wood_tres")
	add_child(rope_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(3.0, 0.2, 4.0)
	collision.shape = shape
	collision.position = Vector3(0, 0.1, 0)
	add_child(collision)