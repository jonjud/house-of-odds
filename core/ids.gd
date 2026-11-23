class_name Ids
extends RefCounted

const PATTERN := "^[a-z][a-z0-9_]*$"

static var _regex: RegEx

static func is_valid(id: StringName) -> bool:
	if _regex == null:
		_regex = RegEx.new()
		_regex.compile(PATTERN)
	return _regex.search(String(id)) != null

static func floor_id(n: int) -> StringName:
	return StringName("floor_%d" % n)
