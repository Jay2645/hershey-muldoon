local characterstates = {}
local charactercurrent = {}

function addstates(charactername, states)
	print(charactername)
	characterstates[charactername] = states
end

function addstate(charactername, statename, state)
	local states = characterstates[charactername]
	states[statename] = state
	characterstates[charactername] = states
end

function allowstates(character, state)
	local name = string.lower(character.name)
	local states = characterstates[name]
	local current = states[state]
	charactercurrent[name] = current
	character.state = main:CreateState(state)
	for key,value in pairs(current.stateTransitions) do
		character.state:AddAllowedState(value)
	end
	return current
end

function getcurrentstate(charactername)
	return charactercurrent[charactername]
end

function getcharacterstates(charactername)
	return characterstates[charactername]
end
