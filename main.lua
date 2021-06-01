-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--composer scenes
local composer = require("composer")
local appodeal = require( "plugin.appodeal" )
--hide statusbar
display.setStatusBar( display.HiddenStatusBar )

--randons 
math.randomseed( os.time() )

--Game starts with "menu" scene
composer.gotoScene( "menu" )