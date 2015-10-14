-- Unit testing starts
M = {}
luaUnit = require('test/luaunit')

TestMyStuff = {} --test class
	function TestMyStuff:testWithNumbers()
		luaUnit.assertTrue(true)
	end

	function TestMyStuff:testWithRealNumbers()
		luaUnit.assertFalse(true) --expected to fail
	end

TestMyStuff2 = {} --test class
	function TestMyStuff2:testWithNumbers()
		luaUnit.assertTrue(false) --expected to fail
	end

	function TestMyStuff2:testWithRealNumbers()
		luaUnit.assertFalse(false)
	end


function M.run()
	local runner = require("luacov.runner")
	runner.init("main.lua")
	luaunit.LuaUnit.run()
end

return M