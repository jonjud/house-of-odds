extends "res://tests/test_case.gd"

func test_nerve_0_is_15_percent() -> void:
	assert_equal(StakeValidator.max_bet(500, 0), 75)

func test_nerve_20_is_25_percent() -> void:
	assert_equal(StakeValidator.max_bet(500, 20), 125)

func test_zero_chips() -> void:
	assert_equal(StakeValidator.max_bet(0, 20), 0)

func test_huge_nerve_capped_at_chips() -> void:
	assert_equal(StakeValidator.max_bet(500, 200), 500)

func test_negative_nerve_treated_as_zero() -> void:
	assert_equal(StakeValidator.max_bet(500, -5), 75)

func test_result_is_floored() -> void:
	# 99 x 15% = 14.85 -> 14
	assert_equal(StakeValidator.max_bet(99, 0), 14)

func test_never_exceeds_chips() -> void:
	for nerve in [0, 10, 50, 100, 170, 300]:
		assert_true(StakeValidator.max_bet(500, nerve) <= 500, "nerve %d" % nerve)
