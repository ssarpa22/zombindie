extends StaticBody3D

func _ready() -> void:
	# Phone booth internal: interior details for phone booth
	var booth_height := 2.0
	var booth_width := 0.6
	var booth_depth := 0.6
	
# Interior back wall
var back_mesh := BoxMesh.new()
back_mesh.size := Vector3(booth_width, booth_height, 0.1)

var back_instance := MeshInstance3D.new()
back_instance.mesh := back_mesh
back_instance.name := "PhoneBoothBackWall"
back_instance.position := Vector3(0, booth_height * 0.5, -booth_depth * 0.5 + 0.05)
back_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(back_instance)

# Interior side walls
for side in [-1, 1]:
	var side_mesh := BoxMesh.new()
	side_mesh.size := Vector3(0.1, booth_height, booth_depth - 0.2)
	
	var side_instance := MeshInstance3D.new()
	side_instance.mesh := side_mesh
	side_instance.name := "PhoneBoothSideWall_%d" % (side == -1 and 1 or 2)
	side_instance.position := Vector3(side * booth_width * 0.5, booth_height * 0.5, 0)
	side_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
	add_child(side_instance)

# Phone cradle detail
var cradle_mesh := BoxMesh.new()
cradle_mesh.size := Vector3(0.15, 0.1, 0.05)

var cradle_instance := MeshInstance3D.new()
cradle_instance.mesh := cradle_mesh
cradle_instance.name := "PhoneCradleDetail"
cradle_instance.position := Vector3(0, booth_height * 0.55, booth_depth * 0.2)
cradle_instance.material_override := preload("res://assets/materials/palettes.painted_metal_tres")
add_child(cradle_instance)

# Phone handset rest area
var rest_mesh := BoxMesh.new()
rest_mesh.size := Vector3(0.2, 0.1, 0.05)

var rest_instance := MeshInstance3D.new()
rest_instance.mesh := rest_mesh
rest_instance.name := "PhoneHandsetRest"
rest_instance.position := Vector3(0, booth_height * 0.3, -booth_depth * 0.2)
rest_instance.material_override := preload("res://assets/materials/palettes.medical_plastics_tres")
add_child(rest_instance)

var collision := CollisionShape3D.new()
var shape := BoxShape3D.new()
shape.size := Vector3(booth_width, booth_height, booth_depth)
collision.shape := shape
collision.position := Vector3(0, booth_height * 0.5, 0)
add_child(collision)