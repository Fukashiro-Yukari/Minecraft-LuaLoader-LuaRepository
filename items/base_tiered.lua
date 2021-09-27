ITEM.Base = 'base'
ITEM.Enchantability = 0
ITEM.RepairMaterial = nil

function ITEM:GetItemEnchantability()
    return self.Enchantability
end

function ITEM:GetIsRepairable(toRepair,repair)
    if self.RepairMaterial then
        if isstring(self.RepairMaterial) then
            local ingredient = Ingredient:fromItems(MAPI.GetLuaItem(self.RepairMaterial):get())

            if ingredient then
                return ingredient:test(repair)
            end
        elseif self.RepairMaterial.test then
            self.RepairMaterial:test(repair)
        end
    end

    return self.BaseClass.GetIsRepairable(self,toRepair,repair)
end