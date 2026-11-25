extends RefCounted
class_name PayoutCalculator

static func gross_payout(stake: int, multiplier: float) -> int:
	if stake <= 0:
		return 0
	if multiplier <= 0:
		return 0
	var int_mult : int = roundi(multiplier * 100)
	return stake * int_mult / 100

static func net_profit(gross_payout: int, stake: int) -> int:
	#Net = Gross - Stake
	var net = gross_payout - stake
	return net
