extends "res://tests/test_case.gd"

# ตัวช่วยสร้างของใหม่ทุก Test (ไม่ใช้ร่วมกัน)
func _setup() -> Dictionary:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	return {
		"cfg": cfg,
		"wallet": ChipWallet.new(cfg),
		"validator": StakeValidator.new(),
	}

func test_valid_stake() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(50, s.wallet, s.cfg), StakeValidator.Result.OK)

func test_minimum_bet_exact_is_ok() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(s.cfg.minimum_bet, s.wallet, s.cfg), StakeValidator.Result.OK)

func test_all_chips_is_ok() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(s.wallet.get_chips(), s.wallet, s.cfg), StakeValidator.Result.OK)

func test_below_minimum() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(s.cfg.minimum_bet - 1, s.wallet, s.cfg), StakeValidator.Result.BELOW_MINIMUM)

func test_exceeds_balance() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(s.wallet.get_chips() + 1, s.wallet, s.cfg), StakeValidator.Result.EXCEEDS_BALANCE)

func test_float_is_not_integer() -> void:
	var s := _setup()
	assert_equal(s.validator.check_stake(50.5, s.wallet, s.cfg), StakeValidator.Result.NOT_INTEGER)

func test_validator_does_not_change_wallet() -> void:
	var s := _setup()
	s.validator.check_stake(50, s.wallet, s.cfg)
	assert_equal(s.wallet.get_chips(), s.cfg.starting_chips)
