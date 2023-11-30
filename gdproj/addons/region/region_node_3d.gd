@tool
class_name Region
extends Node3D

var sub_regions: Array
var bounds : SubRegion.Bounds2D

# Temporarily being loaded and called here, this should be done by the spawn manager
var poisson_disc

func _ready():
	sub_regions = find_children("", "SubRegion", false)
	bounds = find_bounds()
	
	# Initialize Poisson Disc
	# Do not port
	if !Engine.is_editor_hint():
		poisson_disc = $PoissonDisc
		poisson_disc.init()
		
		var points = poisson_disc.generate_distribution()
		
		for group in points:
			for p in group:
				var mesh = GraphicalUtility.point_mesh(Vector3(p.x, 0, p.y))
				add_child(mesh)


func _get_configuration_warnings():
	var error: PackedStringArray
	
	var areas = find_children("", "Area3D")
	
	if areas.size() == 0:
		error.append("Region has no Area3D to perform gizmo raycasts against")
	
	return error


func contains_point(point: Vector3) -> int:
	var result = -1
	
	for i in range(sub_regions.size()):
		if sub_regions[i].contains_point(point):
			if sub_regions[i].is_positive:
				result = i
			else:
				result = -1
				break
	
	return result


# Returns the rectangular bounds of the region
func find_bounds() -> SubRegion.Bounds2D:
	var min : Vector2 = sub_regions[0].bounds.min
	var max : Vector2 = sub_regions[0].bounds.max
	
	for i in range(1, sub_regions.size()):
		var bounds = sub_regions[i].bounds
		
		if min.x > bounds.min.x:
			min.x = bounds.min.x
		if min.y > bounds.min.y:
			min.y = bounds.min.y
		if max.x < bounds.max.x:
			max.x = bounds.max.x
		if max.y < bounds.max.y:
			max.y = bounds.max.y
	
	return SubRegion.Bounds2D.new(min, max)


func _on_projection_plane_input_event(camera, event, position, normal, shape_idx):
	pass
#	if event.is_action_pressed("click"):
#		print(find_bounds().min)
#		print(contains_point(position))
