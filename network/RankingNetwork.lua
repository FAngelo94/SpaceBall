--Ranking Network
--In this class the game interact with the ranking online, here I do
--the http call to the server
local rankingOnline={}

--Manage Username Online
function rankingOnline.insertUsername(user, ranking)
	local params={}
	params.body="user="..user
	network.request("http://www.cyberpills.net/Falci//SpaceBall/insertUsername.php", "POST", ranking.insertUserResponse, params)
end
function rankingOnline.modifyUsername(oldUser, newUser, ranking)
	local params={}
	params.body="oldUser="..oldUser.."&newUser="..newUser
	network.request("http://www.cyberpills.net/Falci//SpaceBall/modifyUsername.php", "POST", ranking.modifyUserResponse, params)
end


--SpaceBall_Stars Table
function rankingOnline.readStarsRanking(user, score, ranking)
	local params={}
	params.body="user="..user.."&score="..score.."&table=SpaceBall_Stars"
	network.request("http://www.cyberpills.net/Falci//SpaceBall/readScore.php", "POST", ranking.rankingResponse, params)
end

--SpaceBall_SurviveBalls Table
function rankingOnline.readSuriviveBallsRanking(user, score, ranking)
	local params={}
	params.body="user="..user.."&score="..score.."&table=SpaceBall_SurviveBalls"
	network.request("http://www.cyberpills.net/Falci//SpaceBall/readScore.php", "POST", ranking.rankingResponse, params)
end

--SpaceBall_SurviveTime Table
function rankingOnline.readSuriveTimeRanking(user, score, ranking)
	local params={}
	params.body="user="..user.."&score="..score.."&table=SpaceBall_SurviveTime"
	network.request("http://www.cyberpills.net/Falci//SpaceBall/readScore.php", "POST", ranking.rankingResponse, params)
end

return rankingOnline