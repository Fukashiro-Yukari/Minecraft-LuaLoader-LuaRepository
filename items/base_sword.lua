ITEM.Base = 'base_tiered'
ITEM.AttackDamage = 0
ITEM.AttackSpeed = 0
ITEM.MaxStackSize = 1

function ITEM:Init()
    local builder = ImmutableMultimap:builder()

    builder:put(Attributes.ATTACK_DAMAGE,new.AttributeModifier(ATTACK_DAMAGE_MODIFIER,'Weapon modifier',self.AttackDamage,AttributeModifier.Operation.ADDITION))
    builder:put(Attributes.ATTACK_SPEED,new.AttributeModifier(ATTACK_SPEED_MODIFIER,'Weapon modifier',self.AttackSpeed,AttributeModifier.Operation.ADDITION))

    self.AttributeModifiers = builder:build()
end

function ITEM:OnReloaded()
    local builder = ImmutableMultimap:builder()

    builder:put(Attributes.ATTACK_DAMAGE,new.AttributeModifier(ATTACK_DAMAGE_MODIFIER,'Weapon modifier',self.AttackDamage,AttributeModifier.Operation.ADDITION))
    builder:put(Attributes.ATTACK_SPEED,new.AttributeModifier(ATTACK_SPEED_MODIFIER,'Weapon modifier',self.AttackSpeed,AttributeModifier.Operation.ADDITION))

    self.AttributeModifiers = builder:build()
end

function ITEM:GetAttackDamage()
    return self.AttackDamage
end

function ITEM:CanPlayerBreakBlockWhileHolding(state,worldIn,pos,player)
    return !player:isCreative()
end

function ITEM:GetDestroySpeed(stack,state)
    if state:isIn(Blocks.COBWEB) then
        return 15
    else
        local material = state:getMaterial()

        return material != Material.PLANTS and material != Material.TALL_PLANTS and material != Material.CORAL and !state:isIn(BlockTags.LEAVES) and (material != Material.GOURD and 1 or 1.5)
    end
end

function ITEM:HitEntity(stack,target,attacker)
    stack:damageItem(1,attacker,Consumer(function(e)
        e:sendBreakAnimation(EquipmentSlotType.MAINHAND)
    end))

    return true
end

function ITEM:OnBlockDestroyed(stack,worldIn,state,pos,entityLiving)
    if state:getBlockHardness(worldIn,pos) != 0 then
        stack:damageItem(2,entityLiving,Consumer(function(e)
           e:sendBreakAnimation(EquipmentSlotType.MAINHAND)
        end))
    end

    return true
end

function ITEM:CanHarvestBlock(stack,blockIn)
    return blockIn:isIn(Blocks.COBWEB)
end

function ITEM:GetAttributeModifiers(slot,stack)
    return slot == EquipmentSlotType.MAINHAND and self.AttributeModifiers or self.BaseClass.GetAttributeModifiers(slot,stack)
end