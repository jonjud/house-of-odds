class_name TableDefinition
extends Resource

const GAME_TYPES: Array[StringName] = [&"dice", &"blackjack", &"roulette"]

@export var id: StringName
@export var title: String = ""
@export var game_type: StringName
@export var bets: Array[BetDefinition] = []

func find_bet(bet_id: StringName) -> BetDefinition:
	for b in bets:
		if b != null and b.id == bet_id:
			return b
	return null

func validate() -> Array[String]:
	var errors: Array[String] = []
	if not Ids.is_valid(id):
		errors.append("table has invalid id '%s'" % id)
	if title.is_empty():
		errors.append("table '%s' has empty title" % id)
	if not GAME_TYPES.has(game_type):
		errors.append("table '%s' has unknown game_type '%s'" % [id, game_type])
	if bets.is_empty():
		errors.append("table '%s' has no bets" % id)
	var seen := {}
	for b in bets:
		if b == null:
			errors.append("table '%s' has a null bet" % id)
			continue
		if seen.has(b.id):
			errors.append("table '%s' has duplicate bet '%s'" % [id, b.id])
		seen[b.id] = true
		errors.append_array(b.validate())
	return errors
