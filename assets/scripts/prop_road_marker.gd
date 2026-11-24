extends StaticBody3D

func _ready() -> void:
	# Road marker: painted line or marker on road
	var length := 2.0
	var width := 0.4
	var height := 0.05
	
	# Road line (white or yellow)
	var line_mesh := BoxMesh.new()
	line_mesh.size := Vector3(length, height, width)
	
	var line_instance := MeshInstance3D.new()
	line_instance.mesh := line_mesh
	line_instance.name := "RoadMarkerLine"
	line_instance.position := Vector3(length * 0.5, height * 0.5, 0)
	
	var material := StandardMaterial3D.new()
	material.albedo_color := Color(1.0, 1.0, 1.0) # white
	material.roughness := 0.5
	line_instance.material_override := material
	
	add_child(line_instance)
	
	# Second marker (yellow)
	var line2_mesh := BoxMesh.new()
	line2_mesh.size := Vector3(length, height, width)
	
	var line2_instance := MeshInstance3D.new()
	line2_instance.mesh := line2_mesh
	line2_instance.name := "RoadMarkerLine2"
	line2_instance.position := Vector3(length * 0.5, height * 0.5, 0.15)
	
	var material2 := StandardMaterial3D.new()
	material2.albedo_color := Color(1.0, 0.9, 0.1) # yellow
	material2.roughness := 0.5
	line2_instance.material_override := material2
	
	add_child(line2_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(length, height * 2, width + 0.1)
	collision.shape := shape
	collision.position := Vector3(length * 0.5, height * 0.5, 0)
	add_child(collision)