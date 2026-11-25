extends SceneTree

# เพิ่ม Suite ใหม่ในลิสต์นี้
const SUITES := [
	preload("res://tests/suites/test_rng.gd"),
	preload("res://tests/suites/test_data.gd"),
	preload("res://tests/suites/test_wallet.gd"),
	preload("res://tests/suites/test_stake_validator.gd"),
]

func _init() -> void:
	var total := 0
	var failed := 0
	var messages: Array[String] = []

	for suite_script in SUITES:
		var suite = suite_script.new()
		for m in suite.get_method_list():
			var method_name: String = m["name"]
			if not method_name.begins_with("test_"):
				continue
			total += 1
			suite.current_test = method_name
			var before: int = suite.failures.size()
			suite.call(method_name)
			if suite.failures.size() > before:
				failed += 1
		messages.append_array(suite.failures)

	for msg in messages:
		printerr("FAIL " + msg)
	print("Tests run: %d | Failed: %d" % [total, failed])
	quit(1 if failed > 0 else 0)
