extends StaticBody3D

func _ready() -> void:
	# Ladder: vertical climbing structure
	var ladder_height := 4.0
	var rung_spacing := 0.5
	var rung_length := 0.5
	
	# Side rails
	var left_rail_mesh := BoxMesh.new()
	left_rail_mesh.size = Vector3(0.05, ladder_height, 0.02)
	var left_rail_instance = MeshInstance3D.new()
	left_rail_instance.mesh = left_rail_mesh
	left_rail_instance.name = "LadderLeftRail"
	left_rail_instance.position = Vector3(-0.25, ladder_height * 0.5, 0)
	add_child(left_rail_instance)
	
	var right_rail_mesh := BoxMesh.new()
	right_rail_mesh.size = Vector3(0.05, ladder_height, 0.02)
	var right_rail_instance = MeshInstance3D.new()
	right_rail_instance.mesh = right_rail_mesh
	right_rail_instance.name = "LadderRightRail"
	right_rail_instance.position = Vector3(0.25, ladder_height * 0.5, 0)
	add_child(right_rail_instance)
	
	# Rungs
	for i in range(int(ladder_height / rung_spacing) + 1):
		var rung_mesh := BoxMesh.new()
		rung_mesh.size = Vector3(rung_length, 0.03, 0.03)
		var rung_instance = MeshInstance3D.new()
		rung_instance.mesh = rung_mesh
		rung_instance.name = "LadderRung%d" % i
		rung_instance.position = Vector3(0, i * rung_spacing - ladder_height * 0.5 + 0.15, 0)
		rung_instance.rotation.z = PI / 2.0
		rung_instance.material_override = preload("res://assets/materials/palettes.wood_tres")
		add_child(rung_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.5, ladder_height, 0.5)
	collision.shape = shape
	collision.position = Vector3(0, ladder_height * 0.5, 0)
	add_child(collision)