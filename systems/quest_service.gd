extends Node

signal changed
signal quest_completed(title: String)

var active_quest := "evacuation"
var kit_recovered := false
var station_reached := false
var zombies_killed := 0
var completed := false

func on_item_collected(item_id: String) -> void:
	if item_id == "medical_kit" and not kit_recovered:
		kit_recovered = true
		changed.emit()
		_check_completion()

func on_zombie_killed() -> void:
	zombies_killed += 1
	changed.emit()

func on_location_discovered(location_id: String) -> void:
	if location_id == "police_station" and not station_reached:
		station_reached = true
		changed.emit()
		_check_completion()

func get_objective_text() -> String:
	if completed:
		return "Evacuación completada · Seguí explorando"
	var objective := "Recuperá el botiquín de la clínica"
	if kit_recovered:
		objective = "Llegá a la comisaría por el camino del bosque"
	return objective + "  [%d infectados abatidos]" % zombies_killed

func snapshot() -> Dictionary:
	return {"kit": kit_recovered, "station": station_reached, "kills": zombies_killed, "completed": completed}

func restore(data: Dictionary) -> void:
	kit_recovered = bool(data.get("kit", false))
	station_reached = bool(data.get("station", false))
	zombies_killed = maxi(0, int(data.get("kills", 0)))
	completed = bool(data.get("completed", false))
	changed.emit()

func _check_completion() -> void:
	if not completed and kit_recovered and station_reached:
		completed = true
		quest_completed.emit("Evacuación: de la clínica a la comisaría")
		changed.emit()
