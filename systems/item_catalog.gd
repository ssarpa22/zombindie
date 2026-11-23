extends RefCounted

const DEFINITIONS := {
	"water": {"name": "Agua potable", "weight": 0.6, "category": "consumable", "description": "Reduce la sed."},
	"canned_food": {"name": "Lata de comida", "weight": 0.45, "category": "consumable", "description": "Alimento no perecedero."},
	"bandage": {"name": "Venda limpia", "weight": 0.15, "category": "medical", "description": "Detiene una herida leve."},
	"medical_kit": {"name": "Botiquín", "weight": 1.4, "category": "medical", "description": "Cura y reduce infección."},
	"wood_plank": {"name": "Tabla", "weight": 1.1, "category": "material", "description": "Sirve para reforzar un refugio."},
	"scrap_metal": {"name": "Chatarra", "weight": 0.8, "category": "material", "description": "Material de reparación."},
	"battery": {"name": "Pila", "weight": 0.12, "category": "material", "description": "Repuesto portátil."}
}

static func get_definition(item_id: String) -> Dictionary:
	return DEFINITIONS.get(item_id, {})

static func display_name(item_id: String) -> String:
	var definition: Dictionary = get_definition(item_id)
	return str(definition.get("name", item_id))

static func get_weight(item_id: String) -> float:
	var definition: Dictionary = get_definition(item_id)
	return float(definition.get("weight", 0.0))
