ITEM.Base = 'base_tool'
ITEM.AttackDamage = 0
ITEM.AttackSpeed = 0
ITEM.HarvestLevel = 0
ITEM.ToolClasses = {
    [ToolType.SHOVEL] = ITEM.HarvestLevel,
}

ITEM.EffectiveBlocks = {
    Blocks.CLAY,
    Blocks.DIRT, 
    Blocks.COARSE_DIRT,
    Blocks.PODZOL,
    Blocks.FARMLAND,
    Blocks.GRASS_BLOCK,
    Blocks.GRAVEL,
    Blocks.MYCELIUM,
    Blocks.SAND,
    Blocks.RED_SAND,
    Blocks.SNOW_BLOCK,
    Blocks.SNOW,
    Blocks.SOUL_SAND,
    Blocks.GRASS_PATH,
    Blocks.WHITE_CONCRETE_POWDER,
    Blocks.ORANGE_CONCRETE_POWDER,
    Blocks.MAGENTA_CONCRETE_POWDER,
    Blocks.LIGHT_BLUE_CONCRETE_POWDER,
    Blocks.YELLOW_CONCRETE_POWDER,
    Blocks.LIME_CONCRETE_POWDER,
    Blocks.PINK_CONCRETE_POWDER,
    Blocks.GRAY_CONCRETE_POWDER,
    Blocks.LIGHT_GRAY_CONCRETE_POWDER,
    Blocks.CYAN_CONCRETE_POWDER,
    Blocks.PURPLE_CONCRETE_POWDER,
    Blocks.BLUE_CONCRETE_POWDER,
    Blocks.BROWN_CONCRETE_POWDER,
    Blocks.GREEN_CONCRETE_POWDER,
    Blocks.RED_CONCRETE_POWDER,
    Blocks.BLACK_CONCRETE_POWDER,
    Blocks.SOUL_SOIL
}

function ITEM:CanHarvestBlock(stack,blockIn)
    return blockIn:isIn(Blocks.SNOW) or blockIn:isIn(Blocks.SNOW_BLOCK)
end

function ITEM:OnItemUse(context)
    local world = context:getWorld()
    local blockpos = context:getPos()
    local blockstate = world:getBlockState(blockpos)

    if context:getFace() == Direction.DOWN then
        return ActionResultType.PASS
    else
        local playerentity = context:getPlayer()
        local blockstate1 = blockstate:getToolModifiedState(world,blockpos,playerentity,context:getItem(),ToolType.SHOVEL)
        local blockstate2

        if blockstate1 and world:isAirBlock(blockpos:up()) then
            world:playSound(playerentity,blockpos,SoundEvents.ITEM_SHOVEL_FLATTEN,SoundCategory.BLOCKS,1.0,1.0)
            blockstate2 = blockstate1
        elseif instanceof(blockstate:getBlock(),CampfireBlock) and blockstate:get(CampfireBlock.LIT) then
            if !world:isRemote() then
                world:playEvent(nil,1009,blockpos,0)
            end

            CampfireBlock:extinguish(world,blockpos,blockstate)
            blockstate2 = blockstate:with(CampfireBlock.LIT,false)
        end

        if blockstate2 then
            if !world:isRemote() then
                world:setBlockState(blockpos,blockstate2,11)

                if playerentity then
                    context:getItem():damageItem(1,playerentity,Consumer(function(e)
                        e:sendBreakAnimation(context:getHand())
                    end))
                end
            end
            
            return ActionResultType:func_233537_a_(world:isRemote())
        else
            return ActionResultType.PASS
        end
    end
end