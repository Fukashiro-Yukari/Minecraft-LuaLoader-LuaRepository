ITEM.Base = 'base_tool'
ITEM.AttackDamage = 0
ITEM.AttackSpeed = 0
ITEM.HarvestLevel = 0
ITEM.ToolClasses = {
    [ToolType.HOE] = ITEM.HarvestLevel,
}
ITEM.EffectiveBlocks = {
    Blocks.NETHER_WART_BLOCK,
    Blocks.WARPED_WART_BLOCK,
    Blocks.HAY_BLOCK,
    Blocks.DRIED_KELP_BLOCK,
    Blocks.TARGET,
    Blocks.SHROOMLIGHT,
    Blocks.SPONGE,
    Blocks.WET_SPONGE,
    Blocks.JUNGLE_LEAVES,
    Blocks.OAK_LEAVES,
    Blocks.SPRUCE_LEAVES,
    Blocks.DARK_OAK_LEAVES,
    Blocks.ACACIA_LEAVES,
    Blocks.BIRCH_LEAVES
}

function ITEM:OnItemUse(context)
    local world = context:getWorld()
    local blockpos = context:getPos()
    local hook = ForgeEventFactory:onHoeUse(context)

    if hook != 0 then
        return hook > 0 and ActionResultType.SUCCESS or ActionResultType.FAIL
    end

    if context:getFace() != Direction.DOWN and world:isAirBlock(blockpos:up()) then
        local blockstate = world:getBlockState(blockpos):getToolModifiedState(world,blockpos,context:getPlayer(),context:getItem(),ToolType.HOE)

        if blockstate then
            local playerentity = context:getPlayer()
            world:playSound(playerentity,blockpos,SoundEvents.ITEM_HOE_TILL,SoundCategory.BLOCKS,1.0,1.0)
            if !world:isRemote() then
                world:setBlockState(blockpos,blockstate,11)

                if playerentity then
                    context:getItem():damageItem(1,playerentity,Consumer(function(player)
                        player:sendBreakAnimation(context:getHand())
                    end))
                end
            end

            return ActionResultType:func_233537_a_(world:isRemote())
        end
    end

    return ActionResultType.PASS
end