-- Unit testing starts
M = {}
luaunit = require('test/luaunit')

TestMyStuff = {} --test class
	function TestMyStuff:testWithNumbers()
		luaunit.assertTrue(true)
	end

	function TestMyStuff:testWithRealNumbers()
		luaunit.assertFalse(true) --expected to fail
	end

TestMyStuff2 = {} --test class
	function TestMyStuff2:testWithNumbers()
		luaunit.assertTrue(false) --expected to fail
	end

	function TestMyStuff2:testWithRealNumbers()
		luaunit.assertFalse(false)
	end


function M.run()
	luaunit.LuaUnit.run()
end

return M