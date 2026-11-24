extends RefCounted

const ITEMS := {
	"work_jacket": {"name":"Campera de trabajo","slot":"torso","insulation":0.07,"rain":0.15,"wind":0.65,"armor":4.0,"weight":1.4},
	"wool_sweater": {"name":"Suéter de lana","slot":"torso","insulation":0.10,"rain":0.0,"wind":0.25,"armor":1.0,"weight":0.8},
	"raincoat": {"name":"Impermeable","slot":"torso","insulation":0.025,"rain":0.85,"wind":0.8,"armor":1.0,"weight":0.7},
	"work_trousers": {"name":"Pantalón de trabajo","slot":"legs","insulation":0.035,"rain":0.1,"wind":0.2,"armor":2.0,"weight":0.7},
	"leather_gloves": {"name":"Guantes de cuero","slot":"hands","insulation":0.025,"rain":0.1,"wind":0.2,"armor":2.0,"weight":0.2},
	"hiking_boots": {"name":"Botas de montaña","slot":"feet","insulation":0.035,"rain":0.35,"wind":0.2,"armor":3.0,"weight":0.9}
}

static func definition(item_id: String) -> Dictionary:
	return ITEMS.get(item_id, {})

static func totals(equipment: Dictionary) -> Dictionary:
	var result := {"insulation":0.0,"rain":0.0,"wind":0.0,"armor":0.0,"weight":0.0}
	for item_id in equipment.values():
		var item: Dictionary = definition(str(item_id))
		for stat in result:
			result[stat] += float(item.get(stat, 0.0))
	return result
