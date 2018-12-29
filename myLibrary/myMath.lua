--My Library with usefull mathematic operation
local myMath={}

function myMath.restOfDivision(dividend, divider)
	while dividend>=divider do
		dividend=dividend-divider
	end
	return dividend
end

function myMath.integerDivision(dividend, divider)
	local i=0
	while dividend>=divider do
		dividend=dividend-divider
		i=i+1
	end
	return i
end

return myMath