local composer = require( "composer" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

--prepare physics
local physics=require("physics")

--Things for Advertisement
coronaAds = require( "plugin.coronaAds" )
chartboost = require( "plugin.chartboost" )
adcolony = require( "plugin.adcolony" )

-- Substitute your own placement IDs when generated
bannerPlacement = "bottom-banner-320x50"
interstitialPlacement = "prova"
 -- Initialize Corona Ads (substitute your own API key when generated)
coronaAds.init( "a02e967c-83d7-496f-91b6-7c92ecdd5b31")
  -- Initialize the Chartboost plugin with your Corona Ads API key
function cbListener( event )
	if ( event.phase == "loaded") then
		if event.type == "interstitial" then
			chartboost.show( "interstitial" )
		end
	end
end
chartboost.init(cbListener, { apiKey="a02e967c-83d7-496f-91b6-7c92ecdd5b31", appOrientation="landscape"} )
-- AdColony listener function
local function adListener( event )
    if ( event.phase == "init" ) then  -- Successful initialization
    end
end
-- Initialize the AdColony plugin with your Corona Ads API key
adcolony.init(adListener, { apiKey="a02e967c-83d7-496f-91b6-7c92ecdd5b31" } )
-- this will eventually go to the menu scene.
composer.gotoScene( "Menu" )
