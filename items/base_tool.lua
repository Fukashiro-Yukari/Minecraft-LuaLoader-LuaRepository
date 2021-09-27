ITEM.Base = 'base_tiered'
ITEM.AttackDamage = 0
ITEM.AttackSpeed = 0
ITEM.EffectiveBlocks = {}
ITEM.Efficiency = 2.0
ITEM.MaxStackSize = 1
ITEM.HarvestLevel = 0
ITEM.ToolClasses = {}

function ITEM:Init()
    self.effectiveBlocks = {}

    for k,v in pairs(self.EffectiveBlocks) do
        self.effectiveBlocks[v] = true
    end

    local builder = ImmutableMultimap:builder()

    builder:put(Attributes.ATTACK_DAMAGE,new.AttributeModifier(ATTACK_DAMAGE_MODIFIER,'Tool modifier',self.AttackDamage,AttributeModifier.Operation.ADDITION))
    builder:put(Attributes.ATTACK_SPEED,new.AttributeModifier(ATTACK_SPEED_MODIFIER,'Tool modifier',self.AttackSpeed,AttributeModifier.Operation.ADDITION))

    self.toolAttributes = builder:build()
end

function ITEM:OnReloaded()
    self.effectiveBlocks = {}

    for k,v in pairs(self.EffectiveBlocks) do
        self.effectiveBlocks[v] = true
    end

    local builder = ImmutableMultimap:builder()

    builder:put(Attributes.ATTACK_DAMAGE,new.AttributeModifier(ATTACK_DAMAGE_MODIFIER,'Tool modifier',self.AttackDamage,AttributeModifier.Operation.ADDITION))
    builder:put(Attributes.ATTACK_SPEED,new.AttributeModifier(ATTACK_SPEED_MODIFIER,'Tool modifier',self.AttackSpeed,AttributeModifier.Operation.ADDITION))

    self.toolAttributes = builder:build()
end

function ITEM:GetAttackDamage()
    return self.AttackDamage
end

function ITEM:GetDestroySpeed(stack,state)
    if self:GetToolTypes(stack):stream():anyMatch(Predicate(function(e) return state:isToolEffective(e) end)) then
        return self.Efficiency
    end

    return self.effectiveBlocks[state:getBlock()] and self.Efficiency or 1.0
end

function ITEM:HitEntity(stack,target,attacker)
    stack:damageItem(2,attacker,Consumer(function(e)
        e:sendBreakAnimation(EquipmentSlotType.MAINHAND)
    end))

    return true
end

function ITEM:OnBlockDestroyed(stack,worldIn,state,pos,entityLiving)
    if !worldIn.isRemote and state:getBlockHardness(worldIn,pos) != 0 then
        stack:damageItem(2,entityLiving,Consumer(function(e)
           e:sendBreakAnimation(EquipmentSlotType.MAINHAND)
        end))
    end

    return true
end

function ITEM:GetAttributeModifiers(slot,stack)
    return slot == EquipmentSlotType.MAINHAND and self.toolAttributes or self.BaseClass.GetAttributeModifiers(slot,stack)
end

function ITEM:GetHarvestLevel()
    return self.HarvestLevel
end