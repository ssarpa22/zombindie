extends StaticBody3D

func _ready() -> void:
	# Over-the-Bed Table: adjustable table over patient bed
	var table_length := 0.5
	var table_width := 0.4
	var table_height := 0.7
	
# Table top
var top_mesh := BoxMesh.new()
top_mesh.size := Vector3(table_length, table_height, table_width)

var top_instance := MeshInstance3D.new()
top_instance.mesh := top_mesh
top_instance.name := "TableTop"
top_instance.position := Vector3(table_length * 0.5, table_height * 0.5, 0)
top_instance.material_override := StandardMaterial3D.new()
top_instance.material_override.albedo_color := Color(0.95, 0.9, 0.8)
top_instance.material_override.roughness := 0.5
add_child(top_instance)

# Table legs (2-3)
for i in range(3):
	var leg_mesh := BoxMesh.new()
	leg_mesh.size := Vector3(0.05, table_height, 0.05)
	
	var leg_instance := MeshInstance3D.new()
	leg_instance.mesh := leg_mesh
	leg_instance.name := "TableLeg%d" % i
	leg_instance.position := Vector3(
		table_length * 0.5 - 0.1 + i * table_length * 0.3,
		table_height * 0.5,
		table_width * 0.5 + 0.02
	)
	leg_instance.material_override := StandardMaterial3D.new()
	leg_instance.material_override.albedo_color := Color(0.8, 0.75, 0.6)
	leg_instance.material_override.roughness := 0.5
	add_child(leg_instance)

# Height adjustment mechanism (simplified)
var adjustment_mesh := BoxMesh.new()
adjustment_mesh.size := Vector3(0.1, 0.1, table_height * 0.3)

var adjustment_instance := MeshInstance3D.new()
adjustment_instance.mesh := adjustment_mesh
adjustment_instance.name := "TableAdjustment"
adjustment_instance.position := Vector3(table_length * 0.5, table_height * 0.5, -table_width * 0.52)
adjustment_instance.material_override := StandardMaterial3D.new()
adjustment_instance.material_override.albedo_color := Color(0.7, 0.65, 0.55)
adjustment_instance.material_override.roughness := 0.5
add_child(adjustment_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(table_length, table_height, table_width)
collision.shape := shape
collision.position := Vector3(table_length * 0.5, table_height * 0.5, 0)
add_child(collision)