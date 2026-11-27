class_name SettlementLedger
extends RefCounted

var _settled: Dictionary = {}

func is_settled(bet_id: StringName) -> bool:
	return _settled.has(bet_id)

func mark_settled(bet_id: StringName) -> void:
	_settled[bet_id] = true
