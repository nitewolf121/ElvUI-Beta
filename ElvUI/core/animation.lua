------------------------------------------------------------------------
-- Animation Functions
------------------------------------------------------------------------
local E, C, L, DF = unpack(select(2, ...)); --Load Ace3, Ace3-ConfigProfile, Locales, Defaults

function E:SetUpAnimGroup(object)
	object.anim = object:CreateAnimationGroup("Flash")
	object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
	object.anim.fadein:SetChange(1)
	object.anim.fadein:SetOrder(2)

	object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
	object.anim.fadeout:SetChange(-1)
	object.anim.fadeout:SetOrder(1)
end

function E:Flash(object, duration)
	if not object.anim then
		E:SetUpAnimGroup(object)
	end

	object.anim.fadein:SetDuration(duration)
	object.anim.fadeout:SetDuration(duration)
	object.anim:Play()
end

function E:StopFlash(object)
	if object.anim then
		object.anim:Finish()
	end
end