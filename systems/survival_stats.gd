extends Node

signal changed
signal died

var health := 100.0
var hunger := 88.0
var thirst := 78.0
var stamina := 100.0
var body_temperature := 36.8
var infection := 0.0
var wound_level := 0.0
var is_dead := false
var _emit_clock := 0.0
var difficulty_multiplier := 1.0

func tick(delta: float, sprinting: bool, weather: int, outdoors: bool) -> void:
	if is_dead:
		return
	hunger = maxf(0.0, hunger - delta * 0.035 * difficulty_multiplier)
	thirst = maxf(0.0, thirst - delta * 0.055 * difficulty_multiplier)
	if not sprinting:
		stamina = minf(100.0, stamina + delta * 10.0)
	if outdoors:
		var cooling := 0.0
		if weather == 3:
			cooling = 0.008
		elif weather == 4:
			cooling = 0.018
		elif weather == 5:
			cooling = 0.012
		body_temperature = maxf(30.0, body_temperature - delta * cooling)
	else:
		body_temperature = minf(36.8, body_temperature + delta * 0.012)
	if hunger <= 0.0:
		health -= delta * 0.18
	if thirst <= 0.0:
		health -= delta * 0.32
	if body_temperature < 34.0:
		health -= delta * (34.0 - body_temperature) * 0.12
	if infection > 70.0:
		health -= delta * 0.08
	_emit_clock += delta
	if _emit_clock >= 0.25:
		_emit_clock = 0.0
		changed.emit()
	_check_death()

func spend_stamina(amount: float) -> bool:
	if stamina < amount:
		return false
	stamina = maxf(0.0, stamina - amount)
	return true

func take_damage(amount: float, infecting: bool = false) -> void:
	if is_dead:
		return
	health = maxf(0.0, health - amount)
	wound_level = minf(100.0, wound_level + amount * 0.8)
	if infecting:
		infection = minf(100.0, infection + amount * 0.55)
	changed.emit()
	_check_death()

func consume(item_id: String) -> bool:
	if is_dead:
		return false
	match item_id:
		"water":
			thirst = minf(100.0, thirst + 42.0)
		"canned_food":
			hunger = minf(100.0, hunger + 38.0)
		"bandage":
			health = minf(100.0, health + 12.0)
			wound_level = maxf(0.0, wound_level - 30.0)
		"medical_kit":
			health = minf(100.0, health + 42.0)
			wound_level = maxf(0.0, wound_level - 60.0)
			infection = maxf(0.0, infection - 35.0)
		_:
			return false
	changed.emit()
	return true

func snapshot() -> Dictionary:
	return {"health": health, "hunger": hunger, "thirst": thirst, "stamina": stamina, "temperature": body_temperature, "infection": infection, "wound": wound_level}

func restore(data: Dictionary) -> void:
	health = clampf(float(data.get("health", 100.0)), 0.0, 100.0)
	hunger = clampf(float(data.get("hunger", 88.0)), 0.0, 100.0)
	thirst = clampf(float(data.get("thirst", 78.0)), 0.0, 100.0)
	stamina = clampf(float(data.get("stamina", 100.0)), 0.0, 100.0)
	body_temperature = clampf(float(data.get("temperature", 36.8)), 25.0, 42.0)
	infection = clampf(float(data.get("infection", 0.0)), 0.0, 100.0)
	wound_level = clampf(float(data.get("wound", 0.0)), 0.0, 100.0)
	is_dead = health <= 0.0
	changed.emit()

func _check_death() -> void:
	if health <= 0.0 and not is_dead:
		health = 0.0
		is_dead = true
		died.emit()
