ITEM.Base = 'base_tool'
ITEM.AttackDamage = 0
ITEM.AttackSpeed = 0
ITEM.HarvestLevel = 0
ITEM.ToolClasses = {
    [ToolType.AXE] = ITEM.HarvestLevel,
}
ITEM.EffectiveBlocks = {
    Blocks.LADDER,
    Blocks.SCAFFOLDING,
    Blocks.OAK_BUTTON,
    Blocks.SPRUCE_BUTTON,
    Blocks.BIRCH_BUTTON,
    Blocks.JUNGLE_BUTTON,
    Blocks.DARK_OAK_BUTTON,
    Blocks.ACACIA_BUTTON,
    Blocks.CRIMSON_BUTTON,
    Blocks.WARPED_BUTTON
}
ITEM.Efficiency = 2.0

local EFFECTIVE_ON_MATERIALS = {
    [Material.WOOD] = true,
    [Material.NETHER_WOOD] = true,
    [Material.PLANTS] = true,
    [Material.TALL_PLANTS] = true,
    [Material.BAMBOO] = true,
    [Material.GOURD] = true
}
local BLOCK_STRIPPING_MAP = {
    [Blocks.OAK_WOOD] = Blocks.STRIPPED_OAK_WOOD,
    [Blocks.OAK_LOG] = Blocks.STRIPPED_OAK_LOG,
    [Blocks.DARK_OAK_WOOD] = Blocks.STRIPPED_DARK_OAK_WOOD,
    [Blocks.DARK_OAK_LOG] = Blocks.STRIPPED_DARK_OAK_LOG,
    [Blocks.ACACIA_WOOD] = Blocks.STRIPPED_ACACIA_WOOD,
    [Blocks.ACACIA_LOG] = Blocks.STRIPPED_ACACIA_LOG,
    [Blocks.BIRCH_WOOD] = Blocks.STRIPPED_BIRCH_WOOD,
    [Blocks.BIRCH_LOG] = Blocks.STRIPPED_BIRCH_LOG,
    [Blocks.JUNGLE_WOOD] = Blocks.STRIPPED_JUNGLE_WOOD,
    [Blocks.JUNGLE_LOG] = Blocks.STRIPPED_JUNGLE_LOG,
    [Blocks.SPRUCE_WOOD] = Blocks.STRIPPED_SPRUCE_WOOD,
    [Blocks.SPRUCE_LOG] = Blocks.STRIPPED_SPRUCE_LOG,
    [Blocks.WARPED_STEM] = Blocks.STRIPPED_WARPED_STEM,
    [Blocks.WARPED_HYPHAE] = Blocks.STRIPPED_WARPED_HYPHAE,
    [Blocks.CRIMSON_STEM] = Blocks.STRIPPED_CRIMSON_STEM,
    [Blocks.CRIMSON_HYPHAE] = Blocks.STRIPPED_CRIMSON_HYPHAE
}

function ITEM:GetDestroySpeed(stack,state)
    local mat = state:getMaterial()

    return EFFECTIVE_ON_MATERIALS[mat] and self.Efficiency or self.BaseClass.GetDestroySpeed(self,stack,state)
end

function ITEM:OnItemUse(context)
    local world = context:getWorld()
    local blockpos = context:getPos()
    local blockstate = world:getBlockState(blockpos)
    local block = blockstate:getToolModifiedState(world,blockpos,context:getPlayer(),context:getItem(),ToolType.AXE)

    if block then
        local playerentity = context:getPlayer()

        world:playSound(playerentity,blockpos,SoundEvents.ITEM_AXE_STRIP,SoundCategory.BLOCKS,1.0,1.0)

        if !world:isRemote() then
            world:setBlockState(blockpos,block,11)

            if playerentity then
                context:getItem():damageItem(1,playerentity,Consumer(LivingEntity,function(e)
                    e:sendBreakAnimation(context:getHand())
                end))
            end
        end

        return ActionResultType:func_233537_a_(world:isRemote())
    else
        return ActionResultType.PASS
    end
end

function ITEM:CanDisableShield(stack,shield,entity,attacker)
    return true
end