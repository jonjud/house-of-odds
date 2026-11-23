class_name RngStream
extends RefCounted

var _rng := RandomNumberGenerator.new()
var _seed: int = 0

func _init(seed_value: int = 0) -> void:
	if seed_value == 0:
		_rng.randomize()
		_seed = _rng.seed
	else:
		set_seed(seed_value)

func set_seed(seed_value: int) -> void:
	_seed = seed_value
	_rng.seed = seed_value

func get_seed() -> int:
	return _seed

func randi_range(from: int, to: int) -> int:
	return _rng.randi_range(from, to)

func randf() -> float:
	return _rng.randf()
