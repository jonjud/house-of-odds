class_name TransactionLog
extends RefCounted

var _entries: Array[TransactionEntry] = []

func add(entry: TransactionEntry) -> void:
	_entries.append(entry)

func get_all() -> Array[TransactionEntry]:
	return _entries.duplicate()

func find_by_id(bet_id: StringName) -> TransactionEntry:
	for e in _entries:
		if e.bet_id == bet_id:
			return e
	return null

func count() -> int:
	return _entries.size()
