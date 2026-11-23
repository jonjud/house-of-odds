class_name RngService
extends RefCounted

var gameplay := RngStream.new()   # ผลเดิมพัน / Reward
var cosmetic := RngStream.new()   # เอฟเฟกต์ภาพเท่านั้น

func set_run_seed(seed_value: int) -> void:
	gameplay.set_seed(seed_value)
	cosmetic.set_seed(seed_value + 1)
