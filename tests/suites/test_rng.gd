extends "res://tests/test_case.gd"

# Logic รับ RNG จากข้างนอก (M01-11)
func _roll_d6(rng: RngStream) -> int:
	return rng.randi_range(1, 6)

func test_same_seed_same_sequence() -> void:
	var a := RngStream.new(12345)
	var b := RngStream.new(12345)
	for i in 20:
		assert_equal(a.randi_range(1, 100), b.randi_range(1, 100))

func test_injected_rng_is_deterministic() -> void:
	var a := RngStream.new(777)
	var b := RngStream.new(777)
	assert_equal(_roll_d6(a), _roll_d6(b))

func test_cosmetic_does_not_change_gameplay() -> void:
	var s1 := RngService.new()
	var s2 := RngService.new()
	s1.set_run_seed(42)
	s2.set_run_seed(42)
	for i in 10:
		s1.cosmetic.randf()   # s1 ใช้ Cosmetic, s2 ไม่ใช้
	for i in 10:
		assert_equal(s1.gameplay.randi_range(1, 100), s2.gameplay.randi_range(1, 100))
