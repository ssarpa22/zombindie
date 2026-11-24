extends StaticBody3D

func _ready() -> void:
	# Bench: simple seating
	var seat_depth := 0.4
	var seat_width := 1.2
	var seat_height := 0.45
	var back_height := 0.8
	
	# Seat
	var seat_mesh := BoxMesh.new()
	seat_mesh.size := Vector3(seat_width, seat_depth, seat_height)
	
	var seat_instance := MeshInstance3D.new()
	seat_instance.mesh := seat_mesh
	seat_instance.name := "BenchSeat"
	seat_instance.position := Vector3(0, seat_height * 0.5, 0)
	seat_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(seat_instance)
	
	# Backrest
	var back_mesh := BoxMesh.new()
	back_mesh.size := Vector3(seat_width, back_height - seat_height, 0.1)
	
	var back_instance := MeshInstance3D.new()
	back_instance.mesh := back_mesh
	back_instance.name := "BenchBack"
	back_instance.position := Vector3(0, seat_height + (back_height - seat_height) * 0.5, -seat_depth * 0.55)
	back_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
	add_child(back_instance)
	
	# Legs (four corners)
	for x in [-0.55, 0.55]:
		for z in [-0.55, 0.55]:
			var leg_mesh := BoxMesh.new()
			leg_mesh.size := Vector3(0.08, seat_height, 0.08)
			var leg_instance := MeshInstance3D.new()
			leg_instance.mesh := leg_mesh
			leg_instance.name := "BenchLeg_%d_%d" % (x > 0, z > 0)
			leg_instance.position := Vector3(x * seat_width * 0.5, leg_mesh.size.y * 0.5, z * seat_depth * 0.5)
			leg_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
			add_child(leg_instance)
	
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size := Vector3(seat_width, seat_height, seat_depth + 0.2)
	collision.shape := shape
	collision.position := Vector3(0, seat_height * 0.5, 0)
	add_child(collision)