extends "res://tests/test_case.gd"

func _setup() -> Dictionary:
	var cfg: EconomyConfig = load("res://data/economy_config.tres")
	return {
		"cfg": cfg,
		"wallet": ChipWallet.new(cfg),
		"table": load("res://data/tables/dice.tres"),
		"ledger": SettlementLedger.new(),
		"tx_log": TransactionLog.new(),
	}

func _play(s: Dictionary, bet_id: StringName, stake: int, nerve: int, mult: float) -> Dictionary:
	var req := BetRequest.new(&"dice", &"dice_low", stake, {}, bet_id)
	return BetTransaction.play(
		s.wallet, s.cfg, s.table, req, nerve,
		func(): return mult,
		s.ledger, s.tx_log)

# ---------- ยอด 0 ----------

func test_zero_balance_rejects_bet() -> void:
	var s := _setup()
	s.wallet.debit(s.wallet.get_chips())   # ทำให้ยอดเป็น 0
	var out := _play(s, &"bet_1", 10, 200, 2.16)
	assert_false(out.ok)
	assert_equal(out.error, &"invalid_stake")
	assert_equal(s.wallet.get_chips(), 0)
	assert_equal(s.tx_log.count(), 0)

# ---------- Minimum Bet ----------

func test_minimum_bet_exact_win() -> void:
	var s := _setup()
	var out := _play(s, &"bet_1", s.cfg.minimum_bet, 20, 2.16)
	assert_true(out.ok)
	# 10 x 2.16 = 21.6 -> 21 ; 500 - 10 + 21
	assert_equal(s.wallet.get_chips(), 511)

func test_minimum_bet_exact_loss() -> void:
	var s := _setup()
	var out := _play(s, &"bet_1", s.cfg.minimum_bet, 20, 0.0)
	assert_true(out.ok)
	assert_equal(s.wallet.get_chips(), 490)

func test_below_minimum_rejected() -> void:
	var s := _setup()
	var out := _play(s, &"bet_1", s.cfg.minimum_bet - 1, 20, 2.16)
	assert_equal(out.error, &"invalid_stake")
	assert_equal(s.wallet.get_chips(), 500)

# ---------- All Available Chips ----------

func test_all_chips_blocked_by_nerve_cap() -> void:
	var s := _setup()
	# NERVE 20 -> เพดาน 125 จึงวางทั้งหมด 500 ไม่ได้
	var out := _play(s, &"bet_1", 500, 20, 2.16)
	assert_equal(out.error, &"exceeds_max_bet")
	assert_equal(s.wallet.get_chips(), 500)

func test_all_chips_allowed_with_high_nerve_loss() -> void:
	var s := _setup()
	# NERVE 170 -> (30+170)/200 = 100% จึงวางทั้งหมดได้
	var out := _play(s, &"bet_1", 500, 170, 0.0)
	assert_true(out.ok)
	assert_equal(s.wallet.get_chips(), 0)

func test_all_chips_allowed_with_high_nerve_win() -> void:
	var s := _setup()
	var out := _play(s, &"bet_1", 500, 170, 2.16)
	assert_true(out.ok)
	# 500 x 2.16 = 1080 ; 500 - 500 + 1080
	assert_equal(s.wallet.get_chips(), 1080)

# ---------- เงินไม่พอ ----------

func test_insufficient_funds_rejected() -> void:
	var s := _setup()
	var out := _play(s, &"bet_1", 501, 200, 2.16)
	assert_equal(out.error, &"invalid_stake")
	assert_equal(s.wallet.get_chips(), 500)
	assert_equal(s.tx_log.count(), 0)

# ---------- ยอดสูงมาก ----------

func test_very_large_balance() -> void:
	var s := _setup()
	s.wallet.credit(1_000_000_000)   # ยอดรวม 1,000,000,500
	var out := _play(s, &"bet_1", 100_000_000, 20, 2.16)
	assert_true(out.ok)
	# 1,000,000,500 - 100,000,000 + 216,000,000
	assert_equal(s.wallet.get_chips(), 1_116_000_500)

# ---------- ไม่จ่ายซ้ำ ----------

func test_duplicate_does_not_pay_twice() -> void:
	var s := _setup()
	_play(s, &"bet_1", 100, 20, 2.16)                 # ยอด 616
	var again := _play(s, &"bet_1", 100, 20, 2.16)
	assert_equal(again.error, &"already_settled")
	assert_equal(s.wallet.get_chips(), 616)
	assert_equal(s.tx_log.count(), 1)

# ---------- ยอดไม่เคยติดลบ ----------

func test_balance_never_negative_when_betting_until_broke() -> void:
	var s := _setup()
	for i in 10:
		_play(s, StringName("bet_%d" % i), 100, 200, 0.0)
		assert_true(s.wallet.get_chips() >= 0, "round %d" % i)
	# แพ้ 5 ครั้ง ยอดเป็น 0 ส่วนรอบที่เหลือถูกปฏิเสธ
	assert_equal(s.wallet.get_chips(), 0)
	assert_equal(s.tx_log.count(), 5)
