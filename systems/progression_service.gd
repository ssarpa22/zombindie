extends Node

signal changed

var level := 1
var experience := 0
var reputation := 0
var skills := {"survival": 0, "combat": 0, "scavenging": 0, "crafting": 0}

func add_experience(amount: int, skill: String = "survival") -> void:
	if amount <= 0:
		return
	experience += amount
	if skills.has(skill):
		skills[skill] = int(skills[skill]) + 1
	while experience >= _experience_to_next_level():
		experience -= _experience_to_next_level()
		level += 1
	changed.emit()

func _experience_to_next_level() -> int:
	return 100 + (level - 1) * 60

func snapshot() -> Dictionary:
	return {"level": level, "experience": experience, "reputation": reputation, "skills": skills.duplicate(true)}

func restore(data: Dictionary) -> void:
	level = maxi(1, int(data.get("level", 1)))
	experience = maxi(0, int(data.get("experience", 0)))
	reputation = int(data.get("reputation", 0))
	var saved_skills: Dictionary = data.get("skills", {})
	for skill in skills:
		skills[skill] = maxi(0, int(saved_skills.get(skill, 0)))
	changed.emit()
