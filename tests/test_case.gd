class_name TestCase
extends RefCounted

var failures: Array[String] = []
var current_test: String = ""

func _fail(msg: String) -> void:
	failures.append("[%s] %s" % [current_test, msg])

func assert_true(cond: bool, msg: String = "") -> void:
	if not cond:
		_fail("expected true. %s" % msg)

func assert_false(cond: bool, msg: String = "") -> void:
	if cond:
		_fail("expected false. %s" % msg)

func assert_equal(actual, expected, msg: String = "") -> void:
	if actual != expected:
		_fail("expected %s but got %s. %s" % [str(expected), str(actual), msg])
