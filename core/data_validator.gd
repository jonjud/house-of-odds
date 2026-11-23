class_name DataValidator
extends RefCounted

static func validate_directory(path: String) -> Array[String]:
	var errors: Array[String] = []
	_scan(path, errors, {})
	return errors

static func _scan(path: String, errors: Array[String], seen: Dictionary) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		errors.append("cannot open %s" % path)
		return
	for sub in dir.get_directories():
		_scan(path.path_join(sub), errors, seen)
	for file in dir.get_files():
		if not file.ends_with(".tres"):
			continue
		var full := path.path_join(file)
		var res := load(full)
		if res == null:
			errors.append("%s: failed to load" % full)
			continue
		if res.has_method("validate"):
			for e in res.validate():
				errors.append("%s: %s" % [file, e])
		var rid = res.get("id")
		if rid != null:
			var key := "%s:%s" % [res.get_script().resource_path, rid]
			if seen.has(key):
				errors.append("%s: duplicate id '%s'" % [file, rid])
			seen[key] = true
