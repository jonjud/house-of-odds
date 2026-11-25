extends "res://tests/test_case.gd"

func test_wallet_starts_from_config() -> void:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	var wallet := ChipWallet.new(cfg)
	assert_equal(wallet.get_chips(), cfg.starting_chips)
	assert_equal(wallet.starting_chips, cfg.starting_chips)

func test_credit_add_chips() -> void:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	var wallet := ChipWallet.new(cfg)
	assert_equal(wallet.credit(100),ChipWallet.Result.OK)
	assert_equal(wallet.credit(0),ChipWallet.Result.INVALID_AMOUNT)
	assert_equal(wallet.credit(-50),ChipWallet.Result.INVALID_AMOUNT)

func test_debit_remove_chips() ->void:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	var wallet := ChipWallet.new(cfg)
	assert_equal(wallet.debit(100),ChipWallet.Result.OK)
	assert_equal(wallet.debit(400),ChipWallet.Result.OK)
	assert_equal(wallet.debit(501),ChipWallet.Result.INSUFFICIENT_FUNDS)
	assert_equal(wallet.debit(0),ChipWallet.Result.INVALID_AMOUNT)
	assert_equal(wallet.debit(-10),ChipWallet.Result.INVALID_AMOUNT)
	
