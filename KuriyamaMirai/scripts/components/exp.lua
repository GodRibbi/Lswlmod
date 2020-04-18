local exp = Class(function(self, inst)
	self.inst = inst
	self.maxtimepiont = 100
	self.currenttimepiont = 0
	self.levelpoint = 0
	self.maxlevel = 100
	self.updatefn = nil
end,
nil
)

function exp:DoDelta(delta)
	local val = self.currenttimepiont + delta
	if self.levelpoint == self.maxlevel then
		self.inst:PushEvent("levelupmax")
		self.currenttimepiont = self.maxtimepiont
		return
	end
	while val >= self.maxtimepiont do
		val = val - self.maxtimepiont
		if self.levelpoint < self.maxlevel then
			self:LevelUp()
		else
			self.currenttimepiont = self.maxtimepiont
			return
		end
	end
	self.currenttimepiont = val
end

function exp:GetPercent()
	return self.currenttimepiont/self.maxtimepiont
end

function exp:ApplyUpgrades()
    local hunger_percent = self.inst.components.hunger:GetPercent()
    local health_percent = self.inst.components.health:GetPercent()

    if self.updatefn ~= nil then
    	self.updatefn(self.inst)
    end

    self.inst.components.hunger:SetPercent(hunger_percent)
    self.inst.components.health:SetPercent(health_percent)
end

function exp:SetUpdateFn(fn)
	self.updatefn = fn
end

function exp:LevelUp()
	if self.levelpoint == self.maxlevel then
		self.inst:PushEvent("levelupmax")
		return
	end
	self.levelpoint = self.levelpoint + 1
	self.inst:PushEvent("levelup")
	self.currenttimepiont = 0
	self:ApplyUpgrades()
end

function exp:OnSave()
	return 
	{
		currenttimepiont = self.currenttimepiont,
		maxtimepiont = self.maxtimepiont,
		levelpoint = self.levelpoint,
	}
end
function exp:OnLoad(data)
    self.currenttimepiont = data.currenttimepiont
    self.maxtimepiont = data.maxtimepiont
    self.levelpoint = data.levelpoint
end
function exp:Getlevelpoint()
	return self.Getlevelpoint
end
function exp:Getmaxlevel()
	return self.Getlevelpoint
end
function exp:Setmaxlevel(delta)
	self.Getlevelpoint = delta
end
function exp:Getmaxtimepiont()
	return self.Getmaxtimepiont
end
function exp:Getcurrenttimepiont()
	return self.Getcurrenttimepiont
end
return exp