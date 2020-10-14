--Fenjou Surge
local s,id=GetID()
function c511325046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

s.listed_series={0x944}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	return (tc:IsSetCard(0x944) and tc:IsControler(tp) and dc and dc:IsControler(1-tp) and (dc:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL)
	or (dc and dc:IsSetCard(0x944) and dc:IsControler(tp) and tc:IsControler(1-tp) and (tc:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL)
end

function s.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x944)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local tg=Duel.GetAttacker()
	local dg=Duel.GetAttackTarget()
	if tg:IsSetCard(0x944) and tg:IsControler(tp) and dg:IsControler(1-tp) and (dg:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and dg:IsCanBeEffectTarget(e) then Duel.SetTargetCard(dg) end
	if dg and dg:IsSetCard(0x944) and dg:IsControler(tp) and tg:IsControler(1-tp) and (tg:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and tg:IsCanBeEffectTarget(e) then Duel.SetTargetCard(tg) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:CanAttack() and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		if Duel.NegateAttack(tc) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end

