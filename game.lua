
local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



local physics = require("physics") 
physics.start()
physics.setGravity(0,0)



--center of screen
local centerX = display.contentCenterX 
local centerY = display.contentCenterY



--variables
local RandomObstacles = {} 
local obst
local dead = false


local gameLoopTimer

local score = 0
local scoreText



local countLevel = 0

local nivel1 = 900
local nivel2 = 2000

local scroll = 1 

local avatar
local radiusAvatar = {} 
local bkg 
local bkg2

local interstitialRandom = math.random(3)

--groups 

local bgGroup  
local mainGroup  
local uiGroup



--scrowling bg
local function moveBackground( event )
	bkg.y = bkg.y + scroll
    bkg2.y = bkg2.y + scroll


    if bkg.y  > display.contentHeight * 2.5 then
    	bkg:translate(0, -3840 ) 
    end
    if bkg2.y  > display.contentHeight * 2.5 then
    	bkg2:translate(0,-3840)
    end
    
end
--end

--move the avatar to the right and left 
local function moveAvatar( event)
	local phase = event.phase

	if(phase == "ended") then
		if(event.x <= centerX and event.y > -30)then
			avatar.x = 150
			avatar:scale (-1,1)

		end	

		if(event.x >= centerX and event.y > -30) then
			avatar.x = 620
			avatar:scale (-1,1)	
	
		end	

			
	end
end
--end

--create obstacles
local function obstacles( )


	local obst = display.newImageRect(mainGroup,"obstacles.png",250,40)
	table.insert(RandomObstacles,obst)
	physics.addBody(obst,"dynamic",{radius=40,bouce=.3})
	obst.myName = "obstacles"
	obst.y = -display.contentHeight

	local posicaoX = math.random(2) 

	--obstacles - random positions
	if posicaoX == 1 then
		obst.x = 150 
	elseif posicaoX == 2  then	
		obst.x = 620
	end	


	obst:setLinearVelocity( 0, nivel1)
	
end
--end 



--Count scores
local function countScores()
	for x = #RandomObstacles, 1, -1 do
		local objectPnt = RandomObstacles[x]

 		if (objectPnt.y  > avatar.y) then
 			score = score + 1
 			scoreText.text = "Score: "..score

 			countLevel = countLevel + 1
 			break
 		end


 		if countLevel == 2 then
 			countLevel = 0
 			nivel1 = nivel1 + 100
 		end
	end

end
-- end


--function gameloop
local function gameLoop( ) 
 	obstacles()

 	countScores() 


 	for i = #RandomObstacles, 1, -1 do
 		local thisObst = RandomObstacles[i]

 		if (thisObst.y > display.contentHeight + 40 ) then
 			display.remove( thisObst )
 			table.remove( RandomObstacles, i )
 		end
 	end
end
--end

local function endGame()
	composer.setVariable( "finalScore", score )
	
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


--colisão
local function avatarCollision( event )
	if (event.phase == "began") then

		local obj1 = event.object1
		local obj2 = event.object2

		if((obj1.myName == "avatar" and obj2.myName == "obstacles")or
			(obj1.myName == "obstacles" and obj2.myName == "avatar")) then

			physics.pause()

			timer.performWithDelay( 2000, endGame )
			

			
			for i = #RandomObstacles, 1, -1 do 
                if ( RandomObstacles[i] == obj1 or RandomObstacles[i] == obj2 ) then
                    table.remove( RandomObstacles, i )
                    break
                end
            end
         
		end	
	end
end


--Pause
local function pause( )

	Runtime:removeEventListener( "collision", avatarCollision )
	Runtime:removeEventListener("enterFrame", moveBackground)
	Runtime:removeEventListener("touch", moveAvatar)
    physics.pause()
    timer.cancel( gameLoopTimer )
	composer.showOverlay("pause",{isModal=true,effect = "fade",time = 400})


end

--end






-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	
	bgGroup = display.newGroup() 
	sceneGroup:insert( bgGroup )

	mainGroup = display.newGroup() 
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup() 
	sceneGroup:insert( uiGroup )	
	
	
	--background
	bkg = display.newImageRect(bgGroup,"background.png",800,1920)
	bkg.x = centerX
	bkg.y = centerY

	bkg2 = display.newImageRect(bgGroup,"background.png",800,1920)
	bkg2.x = centerX
	bkg2.y = bkg.y + 1920	


	-- Avatar
	radiusAvatar = {halfWidth=20, halfHeight=75,x=0,y=-75}

	avatar = display.newImageRect(mainGroup,"avatar.png",150,400)
	avatar.x = 150
	avatar.y = display.contentHeight - 100
	physics.addBody(avatar,{box=radiusAvatar,isSensor=true})
	avatar.myName = "avatar"

	
	--scores
	scoreText = display.newText(uiGroup,"Score: "..score,400,100,native.systemFont,36)
	scoreText:setFillColor( 0, 0, 0 )

	--configurando botão de pause
	pausebutton =  display.newImageRect(uiGroup,"btn_pause.png",60,60)
	pausebutton.x = 50
	pausebutton.y = -80
	pausebutton:addEventListener( "tap", pause)
	--chamando evento que irá ativar o pause do game
end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	
		Runtime:addEventListener("touch", moveAvatar)	
	
	
		gameLoopTimer = timer.performWithDelay( nivel2, gameLoop, 0 )
	
		Runtime:addEventListener("enterFrame", moveBackground)		

	elseif ( phase == "did" ) then
	-- Code here runs when the scene is entirely on screen

	
	physics.start()	
		
	
	Runtime:addEventListener("collision", avatarCollision)	

	end
end



function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	-- elseif ( phase == "did" ) then
		Runtime:removeEventListener( "collision", avatarCollision )
		Runtime:removeEventListener("enterFrame", moveBackground)
		Runtime:removeEventListener("touch", moveAvatar)
        physics.pause()
        composer.removeScene( "menu")
        
    	
	end
end



function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

	if interstitialRandom == 2 then
		appodeal.show( "interstitial")
	end
	
end

function scene:resumeGame(  )
	
		Runtime:addEventListener("touch", moveAvatar)	
	
		gameLoopTimer = timer.performWithDelay( nivel2, gameLoop, 0 )
	
		Runtime:addEventListener("enterFrame", moveBackground)	
	
		physics.start()			
	
		Runtime:addEventListener("collision", avatarCollision)	
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
