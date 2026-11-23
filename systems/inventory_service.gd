extends Node

signal changed
signal item_added(item_id: String, amount: int)

const ItemCatalog = preload("res://systems/item_catalog.gd")

@export var carry_capacity := 22.0
var items: Dictionary = {}

func add_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0 or ItemCatalog.get_definition(item_id).is_empty():
		return false
	if get_weight() + ItemCatalog.get_weight(item_id) * amount > carry_capacity:
		return false
	items[item_id] = int(items.get(item_id, 0)) + amount
	item_added.emit(item_id, amount)
	changed.emit()
	return true

func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0 or int(items.get(item_id, 0)) < amount:
		return false
	var remaining := int(items[item_id]) - amount
	if remaining == 0:
		items.erase(item_id)
	else:
		items[item_id] = remaining
	changed.emit()
	return true

func has_item(item_id: String, amount: int = 1) -> bool:
	return int(items.get(item_id, 0)) >= amount

func get_count(item_id: String) -> int:
	return int(items.get(item_id, 0))

func get_weight() -> float:
	var total := 0.0
	for item_id in items:
		total += ItemCatalog.get_weight(str(item_id)) * int(items[item_id])
	return total

func movement_multiplier() -> float:
	var load_ratio := get_weight() / maxf(carry_capacity, 0.1)
	return clampf(1.0 - maxf(0.0, load_ratio - 0.65) * 0.8, 0.68, 1.0)

func snapshot() -> Dictionary:
	return items.duplicate(true)

func restore(saved_items: Dictionary) -> void:
	items.clear()
	for item_id in saved_items:
		var amount := int(saved_items[item_id])
		if not ItemCatalog.get_definition(str(item_id)).is_empty() and amount > 0:
			items[str(item_id)] = amount
	changed.emit()
