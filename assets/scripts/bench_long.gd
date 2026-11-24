extends StaticBody3D

func _ready() -> void:
	# Long bench: extended seating for public areas
	var bench_length := 2.5
	var bench_width := 0.8
	var bench_height := 0.45
	var back_height := 0.8
	
# Seat
var seat_mesh := BoxMesh.new()
seat_mesh.size := Vector3(bench_length, bench_depth := 0.4, bench_height)

var seat_instance := MeshInstance3D.new()
seat_instance.mesh := seat_mesh
seat_instance.name := "LongBenchSeat"
seat_instance.position := Vector3(bench_length * 0.5, bench_height * 0.5, 0)
seat_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(seat_instance)

# Backrest
var back_mesh := BoxMesh.new()
back_mesh.size := Vector3(bench_length, back_height - bench_height, 0.1)

var back_instance := MeshInstance3D.new()
back_instance.mesh := back_mesh
back_instance.name := "LongBenchBack"
back_instance.position := Vector3(bench_length * 0.5, bench_height + (back_height - bench_height) * 0.5, -bench_depth * 0.55)
back_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(back_instance)

# Legs (six legs for longer bench)
for i in range(3):
	for side in [-1, 1]:
		var leg_mesh := BoxMesh.new()
		leg_mesh.size := Vector3(0.08, bench_height, 0.08)
		
		var leg_instance := MeshInstance3D.new()
		leg_instance.mesh := leg_mesh
		leg_instance.name := "LongBenchLeg_%d_%d" % (i, side > 0 and 1 or 2)
		leg_instance.position := Vector3(
			-bench_length * 0.5 + i * bench_length * 0.5 + bench_length * 0.1,
			leg_mesh.size.y * 0.5,
			side * bench_depth * 0.45
		)
		leg_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
		add_child(leg_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(bench_length, bench_height, bench_depth + 0.2)
collision.shape := shape
collision.position := Vector3(bench_length * 0.5, bench_height * 0.5, 0)
add_child(collision)