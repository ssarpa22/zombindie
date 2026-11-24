extends StaticBody3D

func _ready() -> void:
	# Bus Stop: roadside bus waiting area
	
	# Foundation
	var foundation := Floor_Slab.Instance()
	foundation.name = "Foundation"
	foundation.position := Vector3(0, 0, 0)
	add_child(foundation)
	
# Bus stop shelter
var shelter_mesh := BoxMesh.new()
shelter_mesh.size := Vector3(3.0, 2.5, 1.5)
var shelter_instance := MeshInstance3D.new()
shelter_instance.mesh := shelter_mesh
shelter_instance.name := "BusShelter"
shelter_instance.position := Vector3(0, 1.25, 0)
shelter_instance.material_override := preload("res://assets/materials/palettes.asphalt_tres")
add_child(shelter_instance)

# Roof extension
var roof_mesh := BoxMesh.new()
roof_mesh.size := Vector3(4.0, 0.3, 2.0)
var roof_instance := MeshInstance3D.new()
roof_instance.mesh := roof_mesh
roof_instance.name := "ShelterRoof"
roof_instance.position := Vector3(0, 2.8, 0)
roof_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(roof_instance)

# Bench
var bench_mesh := BoxMesh.new()
bench_mesh.size := Vector3(2.0, 0.5, 0.5)
var bench_instance := MeshInstance3D.new()
bench_instance.mesh := bench_mesh
bench_instance.name := "BusBench"
bench_instance.position := Vector3(0, 0.5, -0.5)
bench_instance.material_override := preload("res://assets/materials/palettes.wood_tres")
add_child(bench_instance)

# Window (advertisement)
var win_mesh := BoxMesh.new()
win_mesh.size := Vector3(0.5, 1.0, 0.2)
var win_instance := MeshInstance3D.new()
win_instance.mesh := win_mesh
win_instance.name := "AdWindow"
win_instance.position := Vector3(-0.5, 1.25, 0.6)
win_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(win_instance)

# Entry (optional, sometimes bus stops are open)
# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(3.5, 3.0, 1.5)
collision.shape := shape
collision.position := Vector3(0, 1.5, 0)
add_child(collision)