include raylib.e

procedure main()

 integer screenWidth = 800
 integer screenHeight = 600
 
 InitWindow(screenWidth,screenHeight,"Keyboard Input Example")
 
 sequence ballPos = {screenWidth / 2, screenHeight / 2}
 
 SetTargetFPS(60)
 
 while not WindowShouldClose() do
 
    --BallPos [1] -is X position, [2] -is Y position
    if IsKeyDown(KEY_RIGHT) then
    	ballPos[1] += 2.0
    	elsif IsKeyDown(KEY_LEFT) then
    		ballPos[1] -= 2.0
    end if
    
	if IsKeyDown(KEY_UP) then
		ballPos[2] -= 2.0
		elsif IsKeyDown(KEY_DOWN) then
			ballPos[2] += 2.0
	end if
	
	--Keep the ball from going off the screen
	if ballPos[1] <= 0 then
		ballPos[1] += 2.0
		elsif ballPos[1] + 50 >= screenWidth then
			ballPos[1] -= 2.0
	end if
	
	if ballPos[2] <= 0 then
		ballPos[2] += 2.0
		elsif ballPos[2] + 50 >= screenHeight then
			ballPos[2] -= 2.0
	end if
 
    BeginDrawing()
    
	ClearBackground(RAYWHITE)
	
    DrawText("Move the ball with arrow keys", 10,10,20, DARKGRAY)
    
    DrawCircleV(ballPos,50,MAROON)
    
    EndDrawing()
 	
 end while
 
 CloseWindow()
	
end procedure

main()
­31.2