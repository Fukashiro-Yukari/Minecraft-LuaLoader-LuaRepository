print('luatest','luatest','luatest')
print(SERVER,CLIENT)

-- local t = Loader.CreateUserdata({
--     tostring = 'nice user data',
--     type = 'test data',
--     get = function(self,k)
--         return 'test'
--     end,
--     set = function(self,k,v)
--         print('lol')
--     end
-- })

-- print(t,type(t))

-- print(weapons.test)

-- local jc = luajava.runString([[
--     public class temp {

--     }
-- ]])

-- hook.Add('OnPlayerTick','lmao',function(e)
--     for i = 1,255 do
--         for i2 = 1,2 do
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()-i2,i,e.player:getPosZ()-i2),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()-i2,i,e.player:getPosZ()+i2),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()+i2,i,e.player:getPosZ()+i2),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()+i2,i,e.player:getPosZ()-i2),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()+i2,i,e.player:getPosZ()),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX()-i2,i,e.player:getPosZ()),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX(),i,e.player:getPosZ()+i2),false)
--             e.player:getEntityWorld():removeBlock(BlockPos(e.player:getPosX(),i,e.player:getPosZ()-i2),false)
--         end
--     end
-- end)

-- for i = 1,99 do
--     MAPI.GetWorld(World.OVERWORLD):destroyBlock(BlockPos(260,70-i,110),true,nil,0)
-- end