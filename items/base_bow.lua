ITEM.MaxDamage = 999

function ITEM:OnPlayerStoppedUsing(stack,worldIn,entityLiving,timeLeft)
    print(instanceof(entityLiving,PlayerEntity))
    -- print(entityLiving.class,PlayerEntity)
end