--Quasibil Kazane
local s,id=GetID()
function s.initial_effect(c)
	--ritual
	c:EnableReviveLimit()
	--sp opt
	c:SetSPSummonOnce(id)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--Special summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_RITUAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e2:SetDescription(aux.Stringid(id,0))
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e3)
	--ritual summon success
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.drcon)
	e4:SetCost(s.cost)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end

s.listed_series={0x946}
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x946) and (sumtp&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.rescon(sg,e,tp,mg) 
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if c:IsLocation(LOCATION_HAND) then
	return sg:GetSum(Card.GetLevel)>=lv and aux.ChkfMMZ(1)(sg,e,tp,nil)
	end
	if c:IsLocation(LOCATION_EXTRA) then
	return sg:GetSum(Card.GetLevel)>=lv and Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
	end
end

function s.spfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToGrave()) or (c:IsSetCard(0x946) and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM))
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,0,e:GetHandler())
	return aux.SelectUnselectGroup(g,e,tp,1,#g,s.rescon,0)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,1,#rg,s.rescon,1,tp,HINTMSG_RELEASE,s.rescon,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.ReleaseRitualMaterial(g,REASON_MATERIAL+REASON_RITUAL)
	g:DeleteGroup()
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.drfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x946)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094258,3))
	local g=Duel.SelectMatchingCard(tp,s.drfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoExtraP(g,tp,REASON_COST)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
