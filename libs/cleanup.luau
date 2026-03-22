-- MIT License

-- Copyright (c) 2022 centau

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
return function(obj: any, err_level: number?)
	return if typeof(obj) == 'RBXScriptConnection'
		then function()
			obj:Disconnect()
		end
		elseif type(obj) == 'thread' then function()
			task.cancel(obj)
		end
		elseif typeof(obj) == 'Instance' then function()
			obj:Destroy()
		end
		elseif obj.destroy then function()
			obj:destroy()
		end
		elseif obj.disconnect then function()
			obj:disconnect()
		end
		elseif obj.Destroy then function()
			obj:Destroy()
		end
		elseif obj.Disconnect then function()
			obj:Disconnect()
		end
		else error('cannot cleanup given object', err_level or 2)
end
