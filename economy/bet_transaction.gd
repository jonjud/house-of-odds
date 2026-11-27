class_name BetTransaction
extends RefCounted

static func play(
		wallet: ChipWallet,
		config: EconomyConfig,
		table: TableDefinition,
		request: BetRequest,
		nerve: int,
		resolver: Callable,
		ledger: SettlementLedger,
		tx_log : TransactionLog) -> Dictionary:
	
	# 0) กันจ่ายซ้ำ (ด่านแรกสุด)
	if ledger.is_settled(request.bet_id):
		return {"ok": false, "error": &"already_settled"}
	
	# 1) ตรวจโต๊ะและ Bet
	var req_check := BetRequestValidator.new().validate(table, request)
	if req_check == BetRequestValidator.Result.WRONG_TABLE:
		return {"ok": false, "error": &"wrong_table"}
	if req_check == BetRequestValidator.Result.UNKNOWN_BET:
		return {"ok": false, "error": &"unknown_bet"}
	
	# 2) ตรวจ Stake
	var stake_check := StakeValidator.new().check_stake(request.stake, wallet, config)
	if stake_check != StakeValidator.Result.OK:
		return {"ok": false, "error": &"invalid_stake"}
	
	# 3) ตรวจเพดาน NERVE
	if request.stake > StakeValidator.max_bet(wallet.get_chips(), nerve):
		return {"ok": false, "error": &"exceeds_max_bet"}
	
	# 4) ผ่านทุกการตรวจแล้ว: บันทึก ID ก่อนแตะเงิน
	ledger.mark_settled(request.bet_id)
	
	# 5) หัก Stake (ครั้งเดียว)
	if wallet.debit(request.stake) != ChipWallet.Result.OK:
		return {"ok": false, "error": &"debit_failed"}
	
	# 6) ได้ตัวคูณจาก resolver (แพ้ = 0.0)
	var multiplier: float = resolver.call()
	
	# 7) คำนวณและเพิ่ม Gross Payout (ครั้งเดียว)
	var gross: int = PayoutCalculator.gross_payout(request.stake, multiplier)
	if gross > 0:
		wallet.credit(gross)
	
	# 8) คืนผลสรุป
	var result := BetResult.create({"multiplier": multiplier}, gross, request.stake)
	var entry := TransactionEntry.from_result(request,result)
	tx_log.add(entry)
	return {"ok": true, "result": result}
