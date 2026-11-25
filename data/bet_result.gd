class_name BetResult
extends RefCounted

var outcome: Dictionary = {}
var is_win: bool = false
var is_push: bool = false
var gross_payout: int = 0
var net_profit: int = 0
var log_lines: Array[String] = []

# Gross Payout รวม Stake ที่คืนแล้ว / Net = Gross - Stake
static func create(p_outcome: Dictionary, p_gross_payout: int, p_stake: int) -> BetResult:
	var r := BetResult.new()
	r.outcome = p_outcome
	r.gross_payout = p_gross_payout
	r.net_profit = PayoutCalculator.net_profit(p_gross_payout,p_stake)
	r.is_win = p_gross_payout > p_stake
	r.is_push = p_gross_payout == p_stake
	return r
