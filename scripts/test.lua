require 'statemachine'
local sam
local states =
{
	hello =
	{
		stateTransitions =
		{
			hello = "howareyou",
			hi = "howareyou"
		},
		response = "Listen, can you get my flowerpot?",
		func = function() sam:SetAquireGoal("flowerpot","Player") end
	},
	howareyou = 
	{
		stateTransitions = 
		{
			fine = "doingfine",
			good = "doingfine",
			well = "doingfine"
		},
		response = "That's good, that's good.",
		func = function() end
	}
}
local current

local function addplayers(room)
	sam = room:AddCharacter("Sam")
	addstates("sam", states)
	current = allowstates(sam, "hello")
end

local function onenter(room)
	if(current == states.hello) then
		sam:Say("Oh, hello there, mate.")
	elseif(sam:CheckGoal()) then
		sam:Say("Oh, fantastic. You found my flowerpot.")
		main:GameOver("You won!")
	end
end

local function onspeak(speech)
	if current then
		for key,value in pairs(current.stateTransitions) do
			if string.find(speech,key) and sam.state:IsAllowedState(value) then
				sam:Say(current.response)
				current.func()
				current = allowstates(sam, value)				
			end
		end
	end
end

local function test(param)
	print("Hi there!")
	print(param)
end

start:BindMessageFunction(addplayers,"onroominit")
start:BindMessageFunction(onenter,"onroomprint")
player:BindMessageFunction(onspeak,"oncharacterspeak")
