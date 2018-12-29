local database={}
--Class to manage database
--variable to manage database
local sqlite3 = require( "sqlite3" )
-- Open "data.db". If the file doesn't exist, it will be created
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
--My require
local myMath=require("myLibrary.myMath")

--Create the table to save levels if it does't exist (the table will be created
--first time player use the app)
function database.tableDBSetup()
	local tablesetup = [[CREATE TABLE IF NOT EXISTS Levels (level INTEGER PRIMARY KEY, stars INTEGER);]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS MusicSetup (music INTEGER,  sound INTEGER);]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS User (name VARCHAR (20));]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS SurviveRecords (level VARCHAR (30) PRIMARY KEY,record DOUBLE);]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS EnergyToPlay (energy INTEGER PRIMARY KEY, time DOUBLE);]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS ShipSelected (ship INTEGER PRIMARY KEY);]]
	db:exec( tablesetup )
	tablesetup = [[CREATE TABLE IF NOT EXISTS ShipAvailable (ship INTEGER PRIMARY KEY);]]
	db:exec( tablesetup )
	--Table for the events
	tablesetup = [[CREATE TABLE IF NOT EXISTS Events (level INTEGER PRIMARY KEY, stars INTEGER, nameEvent VARCHAR(30));]]
	db:exec( tablesetup )
	--Setup Setting
	local checkFirstTime=true
	for a in database.readMusic() do
		checkFirstTime=false
	end
	if checkFirstTime then
		--If this is the first time the player enters in the game the game set on music, sound and user
		local query=[[INSERT INTO MusicSetup VALUES ('1' , '1');]]
		db:exec(query)
		local query=[[INSERT INTO User VALUES ("");]]
		db:exec(query)
	end
	--Setup energy to play
	if database.getEnergyAvailable()==nil then
		--first time the player enter in the game
		local query=[[INSERT INTO EnergyToPlay VALUES('10',']]..os.time(os.date('*t'))..[[');]]
		db:exec(query)
	end
	--Setup ship selected
	if database.getShipSelected()==nil then
		local query=[[INSERT INTO ShipSelected VALUES('1');]]
		db:exec(query)
	end
	--Setup ship available
	if database.readAvailableShip()==false then
		local query=[[INSERT INTO ShipAvailable VALUES('1');]]
		db:exec(query)
	end
end

--Read all results
function database.readAllLevelResults()
	local query=[[SELECT * FROM Levels;]]
	return db:nrows(query)
end
--Read the result for level for only one page
function database.readLevelResults(page)
	local query=[[SELECT * FROM Levels WHERE level>']]..(15*(page-1))..[[' AND level<']]..((page*15)+1)..[[';]]
	return db:nrows(query)
end
--Insert one result only if the result is better than older result
function database.insertResult(levelFinished, stars)
	local checkExist=false
	local pastResult
	--Check if the level that the player finished is in the database yet
	for a in database.readAllLevelResults() do
		if a.level==levelFinished then
			checkExist=true
			pastResult=a.stars
		end
	end
	local query
	if checkExist==false then
		query=[[INSERT INTO Levels VALUES (']]..levelFinished..[[',']]..stars..[[');]]
		db:exec(query)
	else
		--If the level is in the database yet I update the stars only if the player did a better result
		if pastResult<stars then
			query=[[UPDATE Levels SET stars=']]..stars..[[' WHERE level=']]..levelFinished..[[';]]
			db:exec(query)
		end
	end
end

--Count all stars the player win
function database.countStars()
	local query=[[SELECT SUM(stars) AS somma FROM Levels;]]
	local result
	for a in db:nrows(query) do
		result=a.somma
	end
	if result==nil then
		return 0
	end
	return result
end

--Check if the player finish the game, I check if he has at leat 1 star in the last level
function database.finishGame()
	local query=[[SELECT stars FROM Levels WHERE level='105';]]
	local unlock=false
	local star=0
	for a in db:nrows(query) do
		unlock=true
		star=a.stars
	end
	if unlock==true and star>0 then
		return true;
	else
		return false;
	end
end

--Functions to manage music and sound
function database.musicOn()
	local query=[[UPDATE MusicSetup SET music='1';]]
	db:exec(query)
end
function database.musicOff()
	local query=[[UPDATE MusicSetup SET music='0';]]
	db:exec(query)
end
function database.readMusic()
	local query=[[SELECT music FROM MusicSetup;]]
	return db:nrows(query)
end
function database.soundOn()
	local query=[[UPDATE MusicSetup SET sound='1';]]
	db:exec(query)
end
function database.soundOff()
	local query=[[UPDATE MusicSetup SET sound='0';]]
	db:exec(query)
end
function database.readSound()
	local query=[[SELECT sound FROM MusicSetup;]]
	return db:nrows(query)
end

--Functions to manage survive Records
function database.insertSurviveResult(level, score)
	query=[[INSERT INTO SurviveRecords VALUES(']]..level..[[',']]..score..[[');]]
	db:exec(query)
end
function database.modifySurviveResult(level, score)
	local query=[[UPDATE SurviveRecords SET record=']]..score..[[' WHERE level=']]..level..[[';]]
	db:exec(query)
end
function database.readSurviveResult(level)
	local query=[[SELECT record FROM SurviveRecords WHERE level=']]..level..[[';]]
	return db:nrows(query)
end

--Functions to manage username for online ranking
function database.readUser()
	local query=[[SELECT name FROM User;]]
	for row in db:nrows(query) do
		return row.name
	end
end

function database.writeUser(user)
	local query=[[UPDATE User SET name=']]..user..[[';]]
	db:exec(query)
end

--Functions to manage the energy to play
function database.setEnergyToPlay()
	local energyAvailable=database.getEnergyAvailable()
	local query
	if energyAvailable==10 then
		--If energy==10 I update only the date
		query=[[UPDATE EnergyToPlay SET time=']]..os.time(os.date('*t'))..[[';]]
		db:exec(query)
	else
		local timeSaved=database.getLastTimeEnergyRecharge()
		local timeNow=os.time(os.date('*t'))
		--In this variable I save 1 energy for every 5 minutes passed
		local energyRecovered=myMath.integerDivision((timeNow-timeSaved), 300)--1 energy every 5 minutes
		energyAvailable=energyAvailable+energyRecovered
		if energyAvailable>=10 then
			energyAvailable=10
			query=[[UPDATE EnergyToPlay SET time=']]..os.time(os.date('*t'))..[[';]]
			db:exec(query)
			query=[[UPDATE EnergyToPlay SET energy='10';]]
			db:exec(query)
		else
			timeSaved=timeSaved+myMath.integerDivision((timeNow-timeSaved), 300)*300
			query=[[UPDATE EnergyToPlay SET time=']]..timeSaved..[[';]]	
			db:exec(query)
			query=[[UPDATE EnergyToPlay SET energy=']]..energyAvailable..[[';]]	
			db:exec(query)
		end
	end
end
function database.getEnergyAvailable()
	local query=[[SELECT energy FROM EnergyToPlay;]]
	for row in db:nrows(query) do
		return row.energy
	end
	return nil
end
function database.getLastTimeEnergyRecharge()
	local query=[[SELECT time FROM EnergyToPlay;]]
	for row in db:nrows(query) do
		return row.time
	end
	return nil
end
function database.getTimeRemainForNextEnergy()
	local lastTime=database.getLastTimeEnergyRecharge()
	local timeNow=os.time(os.date('*t'))
	return 300-(timeNow-lastTime)
end
function database.decrementEnergyToPlay()
	local energyAvailable=database.getEnergyAvailable()
	energyAvailable=energyAvailable-1
	local query=[[UPDATE EnergyToPlay SET energy=']]..energyAvailable..[[';]]
	db:exec(query)
end
function database.rechargeEnergy()
	local energy=database.getEnergyAvailable()
	if energy<5 then
		energy=energy+5
	else
		energy=10
	end
	local query=[[UPDATE EnergyToPlay SET energy=']]..energy..[[';]]
	db:exec(query)
end

--Functions to manage the player ship selected
function database.selectShip(number)
	local query=[[UPDATE ShipSelected SET ship=']]..number..[[';]]
	db:exec(query)
end
function database.getShipSelected()
	local query=[[SELECT ship FROM ShipSelected;]]
	for row in db:nrows(query) do
		return row.ship
	end
	return nil
end

--Functions to manage the ship that are available
function database.addNewShipAvailable(number)
	local query=[[INSERT INTO ShipAvailable VALUES(']]..number..[[');]]
		db:exec(query)
end
function database.isAvailable(number)
	local query=[[SELECT ship FROM ShipAvailable WHERE ship=']]..number..[[';]]
	for row in db:nrows(query) do
		return true --Player can user ship called "number"
	end
	return false--ship called number isn't available for the user, he must unlock it
end
function database.readAvailableShip()
	local query=[[SELECT ship FROM ShipAvailable;]]
	for row in db:nrows(query) do
		return true--In ShipAvailable table there is at least 1 ship available
	end
	return false--In shipAvailable table aren't any ship available
end

--Functions to Manage the events
function database.readLevelResultsInEvent(event)
	local query=[[SELECT * FROM Events WHERE nameEvent=']]..event..[[';]]
	return db:nrows(query)
end
function database.insertEventResult(levelFinished, stars, nameEvent)
	local checkExist=false
	local pastResult
	--Check if the level that the player finished is in the database yet
	for a in database.readLevelResultsInEvent(nameEvent) do
		if a.level==levelFinished then
			checkExist=true
			pastResult=a.stars
		end
	end
	local query
	if checkExist==false then
		query=[[INSERT INTO Events VALUES (']]..levelFinished..[[',']]..stars..[[',']]..nameEvent..[[');]]
		db:exec(query)
	else
		--If the level is in the database yet I update the stars only if the player did a better result
		if pastResult<stars then
			query=[[UPDATE Events SET stars=']]..stars..[[' WHERE level=']]..levelFinished..[[' AND nameEvent=']]..nameEvent..[[';]]
			db:exec(query)
		end
	end
end
--Count all stars the player win in some event
function database.countStarsEvent(nameEvent)
	local query=[[SELECT SUM(stars) AS somma FROM Events WHERE nameEvent=']]..nameEvent..[[';]]
	local result
	for a in db:nrows(query) do
		result=a.somma
	end
	if result==nil then
		return 0
	end
	return result
end

return database