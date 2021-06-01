
local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local title

local function gotoGame()
    composer.gotoScene( "game", { time=800, effect="crossFade" } )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end





-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	
	--background 
	local bkg = display.newImageRect(sceneGroup,"background.png",800,1920)
	bkg.x = display.contentCenterX
	bkg.y = display.contentCenterY

	--Title image
	title = display.newImageRect( sceneGroup, "fly_up.png", 500, 500 )
    title.x = display.contentCenterX
    title.y = 200

    --Play Buttom 
    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 800, native.systemFont, 70 )
    playButton:setFillColor( 0, 0, 0 )
 
    --event of "play buttom" to start the game
    playButton:addEventListener( "tap", gotoGame )


	
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "highscores" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
