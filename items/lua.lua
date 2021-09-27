ITEM.Base = 'base'
ITEM.Register = true
ITEM.Group = 'lua'
ITEM.ImmuneToFire = true

ITEM.Name = 'Lua'

function ITEM:InventoryTick(stack,worldIn,entityIn,itemSlot,isSelected)
    self.addn = (self.addn or 0)+1

    if self.addn > 10 then
        if self.addn == 11 then
            self.Name = self.Name..'L'
        elseif self.addn == 12 then
            self.Name = self.Name..'u'
        elseif self.addn > 13 then
            self.Name = self.Name..'a'
            self.addn = 0
        end
    else
        self.Name = self.Name..' '
    end

    if #self.Name > 6 then
        self.Name = string.sub(self.Name,2,#self.Name)
    end
end