local name = "autoop.lua"
local desc = "auto-op everyone"
local version = "1.0"

hexchat.register(name, version, desc)

local function isOp()
	local nick = hexchat.get_info("nick")
	for user in hexchat.iterate("users") do
		if user.nick == nick then
			return string.find(user.prefix, "@") ~= nil
		end
	end
	return false
end

local function handle_join(word, word_eol, event, attrs)
	--print(dump(word))
	local nick = word[1]
	--local channel = word[2]
	-- give op to user if we can
	if isOp() then
		hexchat.command("OP " .. nick)
	end
	-- pass on event unchanged
	return hexchat.EAT_NONE
end

local function handle_operator(word, word_eol, event, attrs)
	--print(dump(word))
	--local giver = word[1]
	local receiver  = word[2]
	local nick = hexchat.get_info("nick")
	if receiver == nick then
		-- give op to everyone
		for user in hexchat.iterate("users") do
			if string.find(user.prefix, "@") == nil then
				hexchat.command("OP " .. user.nick)
			end
		end
	end
	-- pass on event unchanged
	return hexchat.EAT_NONE
end

-- give everyone op on join
hexchat.hook_print_attrs("Join", handle_join)

-- give op to everyone as soon as we get op
hexchat.hook_print_attrs("Channel Operator", handle_operator)


-- DEBUG: convert table to printable string
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
