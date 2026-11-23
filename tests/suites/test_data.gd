extends "res://tests/test_case.gd"

func test_economy_config_loads() -> void:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	assert_equal(cfg.starting_chips, 500)
	assert_equal(cfg.minimum_bet, 10)

func test_dice_table_links_bets() -> void:
	var table: TableDefinition = load("res://data/tables/dice.tres")
	assert_equal(table.bets.size(), 4)
	assert_true(table.find_bet(&"dice_low") != null)

func test_bet_request_without_ui() -> void:
	var req := BetRequest.new(&"dice", &"dice_low", 50)
	assert_equal(req.stake, 50)
	assert_equal(req.table_id, &"dice")

func test_bet_result_win_and_lose() -> void:
	var win := BetResult.create({"sum": 4}, 108, 50)
	assert_true(win.is_win)
	assert_equal(win.net_profit, 58)
	var lose := BetResult.create({"sum": 9}, 0, 50)
	assert_false(lose.is_win)
	assert_equal(lose.net_profit, -50)

func test_id_format() -> void:
	assert_true(Ids.is_valid(&"dice_low"))
	assert_false(Ids.is_valid(&"Dice Low"))

func test_invalid_bet_is_detected() -> void:
	var bad := BetDefinition.new()   # id ว่าง, ไม่มีชื่อ
	assert_true(bad.validate().size() > 0)

func test_all_sample_data_is_valid() -> void:
	var errors := DataValidator.validate_directory("res://data")
	assert_equal(errors.size(), 0, str(errors))
