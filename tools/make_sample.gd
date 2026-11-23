@tool
extends EditorScript


func _run() -> void:
	DirAccess.make_dir_recursive_absolute("res://data/bets")
	DirAccess.make_dir_recursive_absolute("res://data/tables")
	var specs := [
		["dice_low", "Low (2-6)", 2.16],
		["dice_seven", "Seven", 5.40],
		["dice_high", "High (8-12)", 2.16],
		["dice_doubles", "Doubles", 5.40],
	]
	var bets: Array[BetDefinition] = []
	for s in specs:
		var bet := BetDefinition.new()
		bet.id = StringName(s[0])
		bet.display_name = s[1]
		bet.min_stake = 10
		bet.payout_multiplier = s[2]
		var path := "res://data/bets/%s.tres" % s[0]
		bet.take_over_path(path)
		ResourceSaver.save(bet, path)
		bets.append(bet)

	var table := TableDefinition.new()
	table.id = &"dice"
	table.title = "Dice Table"
	table.game_type = &"dice"
	table.bets = bets
	table.take_over_path("res://data/tables/dice.tres")
	ResourceSaver.save(table, "res://data/tables/dice.tres")

	var cfg := EconomyConfig.new()
	cfg.take_over_path("res://data/economy_config.tres")
	ResourceSaver.save(cfg, "res://data/economy_config.tres")

	print("Sample data created")
