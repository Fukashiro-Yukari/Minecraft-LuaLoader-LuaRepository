print('test mod test ----------------------------------------------------------------------')

local th = thread.create('test1',function()
    local i = 0

    while true do
        i = i+1

        thread.sleep(50)

        if i > 100 then
            return 101
        end

        print(i)
    end
end)
-- th:start()

-- print(th:getresult())

-- async({
--     function()
--         return 1
--     end,
--     function()
--         return 2
--     end
-- })

-- local th2 = thread.create('test2',function()
--     local i = 0

--     while true do
--         i = i+1

--         thread.sleep(500,1)

--         if i > 100 then
--             break
--         end

--         print(i)
--     end
-- end)

-- th:start()
-- th2:start()

-- print(th,th:getName())

-- print(th,th:start())