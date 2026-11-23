class_name BetDefinition
extends Resource

@export var id: StringName
@export var display_name: String = ""
@export var min_stake: int = 10
@export var payout_multiplier: float = 1.0
@export var metadata: Dictionary = {}

func validate() -> Array[String]:
	var errors: Array[String] = []
	if not Ids.is_valid(id):
		errors.append("bet has invalid id '%s'" % id)
	if display_name.is_empty():
		errors.append("bet '%s' has empty display_name" % id)
	if min_stake < 1:
		errors.append("bet '%s' min_stake must be >= 1" % id)
	if payout_multiplier <= 0.0:
		errors.append("bet '%s' payout_multiplier must be > 0" % id)
	return errors
