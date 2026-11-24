extends StaticBody3D

func _ready() -> void:
	# Trader archetype: reusable NPC entity
	
# Merchant table
var table_mesh := BoxMesh.new()
table_mesh.size := Vector3(2.0, 0.5, 1.0)
var table_instance := MeshInstance3D.new()
table_instance.mesh := table_mesh
table_instance.name := "Table"
table_instance.position := Vector3(0, 0.25, 0)
table_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(table_instance)

# Goods display (visual)
for i in range(3):
	var goods_mesh := BoxMesh.new()
	goods_mesh.size := Vector3(0.5, 0.5, 0.3)
	var goods_instance := MeshInstance3D.new()
	goods_instance.mesh := goods_mesh
	goods_instance.name := "Good_%d" % i
	goods_instance.position := Vector3(
		(cos(i * 2 * PI / 3) * 0.7),
		0.35,
		(sin(i * 2 * PI / 3) * 0.7) + 0.3
	)
	goods_instance.material_override := StandardMaterial3D.new()
	goods_instance.material_override.albedo_color := Color(1.0, 0.5, 0.0)
	add_child(goods_instance)

# Merchant character base (simplified)
var base_mesh := CylinderMesh.new()
base_mesh.top_radius := 0.3
base_mesh.bottom_radius := 0.3
base_mesh.height := 1.8
base_mesh.radial_segments := 6

var base_instance := MeshInstance3D.new()
base_instance.mesh := base_mesh
base_instance.name := "TraderBase"
base_instance.position := Vector3(0, 0.9, 0)
base_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(base_instance)

# Hat (visual)
var hat_mesh := CylinderMesh.new()
hat_mesh.top_radius := 0.35
hat_mesh.bottom_radius := 0.35
hat_mesh.height := 0.3
hat_mesh.radial_segments := 6

var hat_instance := MeshInstance3D.new()
hat_instance.mesh := hat_mesh
hat_instance.name := "Hat"
hat_instance.position := Vector3(0, 1.5, 0)
hat_instance.material_override := preload("res://assets/materials.palettes.painted_metal_tres")
add_child(hat_instance)

# Collision
var collision := CollisionShape3D.new()
var shape := CapsuleShape3D.new()
shape.radius := 0.3
shape.height := 1.8
collision.shape := shape
collision.position := Vector3(0, 0.9, 0)
add_child(collision)

# Interaction distance
func interact() -> void:
	print("Trading with merchant...")