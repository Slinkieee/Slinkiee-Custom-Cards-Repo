--Fenjou Ash
local s,id=GetID()
function c511325040.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_HAND})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

s.listed_series={0x944}
function s.ritualfil(c)
	return c:IsSetCard(0x944)
end

function s.exfilter0(c)
	return c:IsSetCard(0x944) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end

function s.lmfilter(c)
	return (c:GetSummonType()&SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(s.lmfilter,tp,0,LOCATION_MZONE,1,nil) then
		return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_PZONE,0,nil)
	end
end

function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_PZONE)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end

function s.forcedgroup(c,e,tp)
	return (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) or (c:IsSetCard(0x944) and c:IsLocation(LOCATION_PZONE))
end