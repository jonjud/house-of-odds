class_name BetRequest
extends RefCounted

var table_id: StringName
var bet_type: StringName
var stake: int
var options: Dictionary

func _init(p_table_id: StringName = &"", p_bet_type: StringName = &"", p_stake: int = 0, p_options: Dictionary = {}) -> void:
	table_id = p_table_id
	bet_type = p_bet_type
	stake = p_stake
	options = p_options
