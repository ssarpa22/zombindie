extends StaticBody3D

func _ready() -> void:
	# Loot pickup: reusable loot entity
	
# Loot bag
var bag_mesh := BoxMesh.new()
bag_mesh.size := Vector3(1.0, 1.0, 0.5)
var bag_instance := MeshInstance3D.new()
bag_instance.mesh := bag_mesh
bag_instance.name := "LootBag"
bag_instance.position := Vector3(0, 0.25, 0)
bag_instance.material_override := preload("res://assets/materials.palettes.metal_tres")
add_child(bag_instance)

# Gold coins (visual)
for i in range(3):
	var coin_mesh := SphereMesh.new()
	coin_mesh.radius := 0.1
	coin_mesh.subdivisions_around := 8
	coin_mesh.subdivisions_up := 8

	var coin_instance := MeshInstance3D.new()
	coin_instance.mesh := coin_mesh
	coin_instance.name := "Coin_%d" % i
	coin_instance.position := Vector3(
		(cos(i * 2 * PI / 3) * 0.4),
		0.5,
		(sin(i * 2 * PI / 3) * 0.4)
	)
	coin_instance.material_override := StandardMaterial3D.new()
	coin_instance.material_override.albedo_color := Color(1.0, 0.84, 0.0)
	add_child(coin_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(1.0, 1.0, 0.6)
collision.shape := shape
collision.position := Vector3(0, 0, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Picking up loot...")