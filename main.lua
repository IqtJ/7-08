-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

---background
local background = display.newImageRect( "assets/bg.png", 570, 355 )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "background" 


-- Gravity

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )

local playerBullets = {} -- Table that holds the players Bullets

---wall

--local leftWall = display.newImageRect( "assets/wall.png", 100, 200)
--leftWall.x = 5
--leftWall = 
local leftWall = display.newRect( -40, display.contentHeight / 2, 10, display.contentHeight )
--myRectangle.strokeWidth = 3
--myRectangle:setFillColor( 0.5 )
--myRectangle:setStrokeColor( 1, 0, 0 )
--myRectangle.alpha = 0.0
physics.addBody( leftWall, "static", { 
	density = 4.0,
    friction = 0.5, 
    bounce = 2.00 
    } )


---ground
local theGround = display.newImageRect( "assets/land.png", 600, 120 )
theGround.x = display.contentCenterX
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

--character (ninja)
local theCharacter = display.newImageRect( "assets/ninja.png", 50, 50 )
theCharacter.x = display.contentCenterX - 70
theCharacter.y = display.contentCenterY
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
theCharacter.isFixedRotation = true


----character (ghost)
local ghost = display.newImageRect( "assets/ghost.png", 50, 50 )
ghost.x = display.contentCenterX +150
ghost.y = display.contentCenterY
ghost.id = "ghost"
physics.addBody( ghost, "dynamic", { 
    density = 1.5, 
    friction = 0.5, 
    bounce = 0.3 
    } )


--d-pad
local dPad = display.newImageRect( "assets/d-pad.png", 75, 75 )
dPad.x = 50
dPad.y = display.contentHeight - 80
dPad.alpha = 0.50
dPad.id = "d-pad"

--to go up
local upArrow = display.newImageRect( "assets/upArrow.png", 19, 14 )
upArrow.x = 50
upArrow.y = display.contentCenterY + 53
upArrow.id = "up arrow"


--to go down
local downArrow = display.newImageRect( "assets/downArrow.png", 19, 14 )
downArrow.x = 50
downArrow.y = display.contentCenterY + 108
downArrow.id = "down arrow"

--to go left
local leftArrow = display.newImageRect( "assets/leftArrow.png", 14, 19 )
leftArrow.x = 22
leftArrow.y = display.contentCenterY + 80
leftArrow.id = "left arrow"

-- to go right
local rightArrow = display.newImageRect( "assets/rightArrow.png", 14, 19 )
rightArrow.x = 78
rightArrow.y = display.contentCenterY + 80
rightArrow.id = "right arrow"

---jump

local jumpButton = display.newImageRect( "assets/jumpButton.png", 19, 19 )
jumpButton.x = 50
jumpButton.y = display.contentCenterY + 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5
 

--shoot
local rightShootButton = display.newImageRect ( "assets/rightShoot.png", 50, 50 )
rightShootButton.x = 440
rightShootButton.y = display.contentCenterY 
rightShootButton.id = "rightShootButton"
rightShootButton.alpha = 0.5

local leftShootButton = display.newImageRect ( "assets/leftShoot.png", 50, 50 )
leftShootButton.x = 100
leftShootButton.y = display.contentCenterY 
leftShootButton.id = "leftShootButton"
leftShootButton.alpha = 0.5
  -----functions

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end


local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "ghost" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "ghost" ) ) then
            -- Remove both the laser and asteroid
            --display.remove( obj1 )
            --display.remove( obj2 )
 			
 			-- remove the bullet
 			local bulletCounter = nil
 			
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            ghost:removeSelf()
            ghost = nil

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "assets/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
			local emitterParams = {
			    startColorAlpha = 1,
			    startParticleSizeVariance = 25,
			    startColorGreen = 0.3031555,
			    yCoordFlipped = -1,
			    blendFuncSource = 770,
			    rotatePerSecondVariance = 153.95,
			    particleLifespan = 0.7237,
			    tangentialAcceleration = -1440.74,
			    finishColorBlue = 0.3699196,
			    finishColorGreen = 0.5443883,
			    blendFuncDestination = 1,
			    startParticleSize = 50,
			    startColorRed = 0.8373094,
			    textureFileName = "assets/fire.png",
			    startColorVarianceAlpha = 1,
			    maxParticles = 25,
			    finishParticleSize = 50,
			    duration = 0.25,
			    finishColorRed = 1,
			    maxRadiusVariance = 50.63,
			    finishParticleSizeVariance = 100,
			    gravityy = -671.05,
			    speedVariance = 90.79,
			    tangentialAccelVariance = -420.11,
			    angleVariance = -142.62,
			    angle = -244.11
			}
			local emitter = display.newEmitter( emitterParams )
			emitter.x = whereCollisonOccurredX
			emitter.y = whereCollisonOccurredY

        end
    end
end



function checkPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end


function rightShootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleRightBullet = display.newImageRect ( "assets/rightKunai.png", 30, 5 )
        aSingleRightBullet.x = theCharacter.x
        aSingleRightBullet.y = theCharacter.y
        aSingleRightBullet.id = "a single bullet"
        physics.addBody( aSingleRightBullet, "dynamic", {
         	density = 3.0, 
    		friction = 0.5, 
    		bounce = 0.3 
    		} )
        -- Make the object a "bullet" type object
        aSingleRightBullet.isBullet = true
        aSingleRightBullet.gravityScale = 2
        aSingleRightBullet.id = "bullet"
        aSingleRightBullet:setLinearVelocity( 1000, 0 )
          

        table.insert(playerBullets,aSingleRightBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function leftShootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleLeftBullet = display.newImageRect ( "assets/leftKunai.png", 30, 5 )
        aSingleLeftBullet.x = theCharacter.x
        aSingleLeftBullet.y = theCharacter.y
        aSingleLeftBullet.id = "a single bullet"
        physics.addBody( aSingleLeftBullet, "dynamic", {
         	density = 3.0, 
    		friction = 0.5, 
    		bounce = 0.3 
    		} )
        -- Make the object a "bullet" type object
        aSingleLeftBullet.isBullet = true
        aSingleLeftBullet.gravityScale = 2
        aSingleLeftBullet.id = "bullet"
        aSingleLeftBullet:setLinearVelocity( -1000, 0 )
          

        table.insert(playerBullets,aSingleLeftBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = -30, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = 30, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = -30, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 30, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        theCharacter:setLinearVelocity( 0, -250 )
    end

    return true
end

-- if character falls off the end of the world, respawn back to where it came from
function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX - 200
        theCharacter.y = display.contentCenterY
    end
end




---event listeners
upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
jumpButton:addEventListener( "touch", jumpButton )

rightShootButton:addEventListener( "touch", rightShootButton )
leftShootButton:addEventListener( "touch", leftShootButton )


Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )

---theCharacter.collision = characterCollision
--theCharacter:addEventListener( "collision" )
