--Tale of Adventure - The Ancient Ruins
local s,id=GetID()
function c511324010.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Ritual
	local e2=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,forcedselection=s.ritcheck})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end

s.listed_series={0x943}

function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_DECK,0)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x943) and c:IsAbleToGrave()
end
function s.ritcheck(e,tp,g,sc)
	return #g==1,#g>1
end