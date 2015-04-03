function PacMan()

%declare variables (I will change their types later)
global lives score delay;
global level board pellets power_Pellet_Count combo;
global xPacMan yPacMan PacMan dir_PacMan;
global m n;
global xBlinky yBlinky Blinky dir_Blinky;
global xPinky yPinky Pinky dir_Pinky;
%global xPinky yPinky Pinky dir_Pinky;

%initialize variables
combo = 1;
power_Pellet_Count = 0;
lives = 3;
score =0;
level = 1;
delay = .25;

%draw board

selectBoard();
figure('KeyPressFcn',@my_callback);
draw_board(board);
%draw initial pacman and ghost
PacMan = rectangle('Position',[xPacMan-1,m-yPacMan,1,1],'Curvature',[1,1],'FaceColor','y');
Blinky = rectangle('Position',[xBlinky-1,m-yBlinky,1,1],'Curvature',[1,1],'FaceColor','r');
Pinky = rectangle('Position',[xPinky-1,m-yPinky,1,1],'Curvature',[1,1],'FaceColor',[1,0.4,0.6]);
pause(2);
while lives>0 %run game
    while (pellets>0 && lives>0) %run level
        if power_Pellet_Count>0
            power_Pellet_Count = power_Pellet_Count - 1;
            if power_Pellet_Count == 0
                combo = 1;
            end
        end
        move_Blinky();
        move_Pinky();
        switch at_Ghost()
            case 0
            case 1
                pause(1);
                reset_PacMan();
                reset_Blinky();
                pause(1);
            case 2
                pause(1);
                score = score + 100*(2^combo);
                reset_Blinky();
                pause(1);
        end
        %move pacman & score stuff
        if (can_Move(dir_PacMan)==1) 
            move_PacMan();
            switch board(yPacMan,xPacMan)
                case 0
                case 2
                    score = score + 10;
                    pellets = pellets - 1;
                    board(yPacMan,xPacMan) = 0;
                    rectangle('Position',[xPacMan-1,m-yPacMan,1,1],'FaceColor','k');
                    PacMan = rectangle('Position',[xPacMan-1,m-yPacMan,1,1],'Curvature',[1,1],'FaceColor','y');
                    set(Blinky,'Position',[xBlinky-1,m-yBlinky,1,1],'FaceColor','r');
                case 3
                    score = score + 50;
                    pellets = pellets - 1;
                    power_Pellet_Count = 31 - level;
                    if power_Pellet_Count < 1;
                        power_Pellet_Count = 1;
                    end
                    board(yPacMan,xPacMan) = 0;
                    rectangle('Position',[xPacMan-1,m-yPacMan,1,1],'FaceColor','k');
                    PacMan = rectangle('Position',[xPacMan-1,m-yPacMan,1,1],'Curvature',[1,1],'FaceColor','y');
            end
        end
        switch at_Ghost()
            case 0
            case {1,3}
                pause(1);
                reset_Blinky();
                reset_PacMan();
                pause(1);
            case 2
                score = score + 100*(2^combo);
                pause(1);
                reset_Blinky();
                pause(1);
            case 4
                score = score + 100*(2^combo);
                pause(1);
                reset_Pinky();
                pause(1);
        end
        pause(delay);
    end
    %go to next level
    if lives>0
    level = level + 1;
    power_Pellet_Count = 0;
    selectBoard();
    draw_board(board);
    pause(2);
    end
end


% functions called throughout
function ghost=at_Ghost()
     if (xPacMan==xBlinky)&&(yPacMan==yBlinky)&&(power_Pellet_Count==0)
         ghost = 1;
     elseif ((xPacMan==xBlinky)&&(yPacMan==yBlinky)&&(power_Pellet_Count>0))
         ghost = 2;
     elseif((xPacMan==xPinky)&&(yPacMan==yPinky)&&(power_Pellet_Count==0))
         ghost = 3;
     elseif ((xPacMan==xPinky)&&(yPacMan==yPinky)&&(power_Pellet_Count>0))
         ghost = 4;
     else 
         ghost = 0;
     end
end

%reset PacMan

function reset_PacMan() %after pacman dies reset him and the ghosts, and decrease life count
    lives = lives - 1;
    %reset pacman and blinky
    xPacMan = 13;
    yPacMan = 24;
    xBlinky = 13;
    yBlinky = 8;
    xPinky = 13;
    yPinky = 14;
    dir_Pinky = -2;
    dir_PacMan = -2;
    dir_Blinky = 2;
    set(PacMan,'Position',[xPacMan-1,m-yPacMan,1,1]);
end

%reset Ghosts

function reset_Blinky()
    xBlinky = 13;
    yBlinky = 8;
    dir_Blinky = 2;
    set(Blinky,'Position',[xBlinky-1,m-yBlinky,1,1]);
end
function reset_Pinky()
    xPinky = 13;
    yPinky = 14;
    dir_Pinky = 1;
end
%reset board
function selectBoard()
    board = level_One();
    
    %starting positions
    xPacMan = 13;
    yPacMan = 24;
    xBlinky = 13;
    yBlinky = 8;
    xPinky = 13;
    yPinky = 14;
    dir_PacMan = -2;
    dir_Blinky = 2;
    dir_Pinky = -2;
    [m n] = size(board);
    pellets = 0;
    
    for a = 1:m
        for b = 1:n
            if (board(a,b)==2 || board(a,b)==3)
                pellets = pellets +1;
            end
        end
    end
    
end

%move pacman
function move_PacMan()
    switch dir_PacMan
        case 1
            yPacMan = yPacMan - 1;
        case -1
            yPacMan = yPacMan + 1;
        case -2
            xPacMan = xPacMan - 1;
        case 2
            xPacMan = xPacMan + 1; 
    end
    set(PacMan,'Position',[xPacMan-1,m-yPacMan,1,1]);
end
%ghost functions
function move_Blinky()
   switch at_Intersection(xBlinky,yBlinky)%check if at intersection, if at intersection do stuff
       case 0
           dir_Blinky = get_Valid_Dir_One(xBlinky,yBlinky,dir_Blinky);
       case 1   
           dir_Blinky = get_Valid_Dir_One(xBlinky,yBlinky,dir_Blinky);
       case 2
           directions = get_Valid_Dir_Several(xBlinky,yBlinky,dir_Blinky);
           a = distance_to_Tile(directions(2,2),directions(3,2),xPacMan,yPacMan);
           b = distance_to_Tile(directions(2,3),directions(3,3),xPacMan,yPacMan);
           if a>b
               dir_Blinky = directions(1,3);
           elseif a == b
               if rand>.5
                   dir_Blinky = directions(1,3);
               else
                   dir_Blinky = directions(1,2);
               end
           else
               dir_Blinky = directions(1,2);
           end
           if power_Pellet_Count > 0 
               if rand>.5
                   dir_Blinky = directions(1,3);
               else
                   dir_Blinky = directions(1,2);
               end
           end
       case 3
           directions = get_Valid_Dir_Several(xBlinky,yBlinky,dir_Blinky);
           a = distance_to_Tile(directions(2,2),directions(3,2),xPacMan,yPacMan);
           b = distance_to_Tile(directions(2,3),directions(3,3),xPacMan,yPacMan);
           c = distance_to_Tile(directions(2,4),directions(3,4),xPacMan,yPacMan);
            if a<b && a<c
                dir_Blinky = directions(1,2);
            elseif b<c && b<a
                dir_Blinky = directions(1,3);
            elseif c<b && c<a 
                dir_Blinky = directions(1,4);
            elseif a==b && a<c
                if rand>.5
                    dir_Blinky = directions(1,2);
                else
                    dir_Blinky = directions(1,3);
                end
            elseif a==c && a<b
                if rand>.5
                    dir_Blinky = directions(1,2);
                else
                    dir_Blinky = directions(1,4);
                end
            elseif b==c && b<a
                if rand>.5
                    dir_Blinky = directions(1,3);
                else
                    dir_Blinky = directions(1,4);
                end
            elseif a==c && a==b
                if rand>.66
                    dir_Blinky = directions(1,2);
                elseif rand>.33
                    dir_Blinky = directions(1,3);
                else
                    dir_Blinky = directions(1,4);
                end
            end
       
       if power_Pellet_Count > 0
           if rand>.66
               dir_Blinky = directions(1,2);
           elseif rand>.33
               dir_Blinky = directions(1,3);
           else
               dir_Blinky = directions(1,4);
           end
       end
       
               
   end
   switch dir_Blinky
        case 1
            yBlinky = yBlinky - 1;
        case -1
            yBlinky = yBlinky + 1;
        case -2
            xBlinky = xBlinky - 1;
        case 2
            xBlinky = xBlinky + 1;    
   end
   delete(Blinky);
   Blinky = rectangle('Position',[xBlinky-1,m-yBlinky,1,1],'Curvature',[1,1],'FaceColor','r');
end%move Blinky

function move_Pinky()
   switch at_Intersection(xPinky,yPinky)%check if at intersection, if at intersection do stuff
       case 0
           dir_Pinky = get_Valid_Dir_One(xPinky,yPinky,dir_Pinky);
       case 1   
           dir_Pinky = get_Valid_Dir_One(xPinky,yPinky,dir_Pinky);
       case 2
           directions = get_Valid_Dir_Several(xPinky,yPinky,dir_Pinky);
           a = distance_to_Tile(directions(2,2),directions(3,2),xPacMan,yPacMan);
           b = distance_to_Tile(directions(2,3),directions(3,3),xPacMan,yPacMan);
           if a>b
               dir_Pinky = directions(1,3);
           elseif a == b
               if rand>.5
                   dir_Pinky = directions(1,3);
               else
                   dir_Pinky = directions(1,2);
               end
           else
               dir_Pinky = directions(1,2);
           end
           if power_Pellet_Count > 0 
               if rand>.5
                   dir_Pinky = directions(1,3);
               else
                   dir_Pinky = directions(1,2);
               end
           end
       case 3
           directions = get_Valid_Dir_Several(xPinky,yPinky,dir_Pinky);
           a = distance_to_Tile(directions(2,2),directions(3,2),xPacMan,yPacMan);
           b = distance_to_Tile(directions(2,3),directions(3,3),xPacMan,yPacMan);
           c = distance_to_Tile(directions(2,4),directions(3,4),xPacMan,yPacMan);
            if a<b && a<c
                dir_Pinky = directions(1,2);
            elseif b<c && b<a
                dir_Pinky = directions(1,3);
            elseif c<b && c<a 
                dir_Pinky = directions(1,4);
            elseif a==b && a<c
                if rand>.5
                    dir_Pinky = directions(1,2);
                else
                    dir_Pinky = directions(1,3);
                end
            elseif a==c && a<b
                if rand>.5
                    dir_Pinky = directions(1,2);
                else
                    dir_Pinky = directions(1,4);
                end
            elseif b==c && b<a
                if rand>.5
                    dir_Pinky = directions(1,3);
                else
                    dir_Pinky = directions(1,4);
                end
            elseif a==c && a==b
                if rand>.66
                    dir_Pinky = directions(1,2);
                elseif rand>.33
                    dir_Pinky = directions(1,3);
                else
                    dir_Pinky = directions(1,4);
                end
            end
       
       if power_Pellet_Count > 0
           if rand>.66
               dir_Pinky = directions(1,2);
           elseif rand>.33
               dir_Pinky = directions(1,3);
           else
               dir_Pinky = directions(1,4);
           end
       end
       
               
   end
   switch dir_Pinky
        case 1
            yPinky = yPinky - 1;
        case -1
            yPinky = yPinky + 1;
        case -2
            xPinky = xPinky - 1;
        case 2
            xPinky = xPinky + 1;    
   end
   delete(Pinky);
   Pinky = rectangle('Position',[xPinky-1,m-yPinky,1,1],'Curvature',[1,1],'FaceColor',[1,0.4,0.6]);
end%move Pinky

%general ghost functions
%check distance, check if at intersection, check if move is valid
function dist = distance_to_Tile(xGhost,yGhost,xDest,yDest)
    if yDest<1
        y = 1;
    else
        y = yDest;
    end
    if xDest<1
        x = 1;
    else
        x = xDest;
    end
    dist = sqrt((xGhost-x)^2+(yGhost-y)^2);
end

function temp = at_Intersection(xGhost,yGhost)
    temp = 0;
    if move_Valid(xGhost,yGhost-1) == 1 %up
        temp = temp + 1;
    end
    if move_Valid(xGhost,yGhost+1) == 1 %down
        temp = temp + 1;
    end 
    if move_Valid(xGhost-1,yGhost) == 1 %left
        temp = temp + 1;
    end
    if move_Valid(xGhost+1,yGhost) == 1 %right
        temp = temp + 1;
    end
    temp = temp - 1;
    
end

function bool = move_Valid(xGhostf,yGhostf)
    if (board(yGhostf,xGhostf)==1);
        bool = 0;
    else
        bool = 1;
    end
end

function bool = move_Valid_Dir(xGhostf,yGhostf,dir)
    switch dir
        case 1
            y = yGhostf - 1;
            x = xGhostf;
        case -1
            y = yGhostf + 1;
            x = xGhostf;
        case -2
            y = yGhostf;
            x = xGhostf - 1;
        case 2
            y = yGhostf;
            x = xGhostf + 1;    
    end
    if (board(y,x)==1);
        bool = 0;
    else
        bool = 1;
    end
end

function direction = get_Valid_Dir_One(xGhost,yGhost,dir)
   if move_Valid_Dir(xGhost,yGhost,dir) == 1
       direction = dir;
   elseif ((move_Valid_Dir(xGhost,yGhost,1) == 1)&&(dir ~= -1))
       direction = 1;
   elseif ((move_Valid_Dir(xGhost,yGhost,-1) == 1)&&(dir ~= 1))
       direction = -1;
   elseif ((move_Valid_Dir(xGhost,yGhost,2) == 1)&&(dir ~= -2))
       direction = 2;
   elseif ((move_Valid_Dir(xGhost,yGhost,-2) == 1)&&(dir ~= 2))
       direction = -2;
   else
       direction = -1*dir;
   end
   
end

function directions = get_Valid_Dir_Several(xGhost,yGhost,dir)
   directions = [0;0;0];
   if ((move_Valid_Dir(xGhost,yGhost,1) == 1)&&(dir ~= -1))
       a = [1;xGhost;yGhost-1];
       directions = [directions,a];
   end
   if ((move_Valid_Dir(xGhost,yGhost,-1) == 1)&&(dir ~= 1))
       a = [-1;xGhost;yGhost+1];
       directions = [directions,a];
   end
   if ((move_Valid_Dir(xGhost,yGhost,2) == 1)&&(dir ~= -2))
       a = [2;xGhost+1;yGhost];
       directions = [directions,a];
   end
   if ((move_Valid_Dir(xGhost,yGhost,-2) == 1)&&(dir ~= 2))
       a = [-2;xGhost-1;yGhost];
       directions = [directions,a];
   end
    
end

%end of General Ghost functions
    

%draw board

function draw_board(board)
    %axis off
    axis([0 n -2 m])
    for y = 1:m
        for x = 1:n
            switch board(y,x)
                case 1
                    rectangle('Position',[x-1,m-y,1,1],'FaceColor','b')
                case 0
                    rectangle('Position',[x-1,m-y,1,1],'FaceColor','k')
                case 2
                    rectangle('Position',[x-1,m-y,1,1],'FaceColor','k');
                    rectangle('Position',[x-.75,m-y+.25,.5,.5],'Curvature',[1,1],'FaceColor','y');
                case 3
                    rectangle('Position',[x-1,m-y,1,1],'FaceColor','k');
                    rectangle('Position',[x-.85,m-y+.15,.70,.70],'Curvature',[1,1],'FaceColor','y');
                otherwise
                    rectangle('Position',[x-1,m-y,1,1],'FaceColor','k')
            end
        end       
    end
end
%change pacman direction
function change_dir(dir)
    if can_Move(dir) == 1
        dir_PacMan = dir;
    end
end
%check if pacman can move
function bool=can_Move(dir)
    switch dir
        case 1
            y = yPacMan - 1;
            x = xPacMan;
        case -1
            y = yPacMan + 1;
            x = xPacMan;
        case -2
            y = yPacMan;
            x = xPacMan - 1;
        case 2
            y = yPacMan;
            x = xPacMan + 1;    
    end
    if (board(y,x)==1);
        bool = 0;
    else
        bool = 1;
    end
end
%watch for keystrokes
function my_callback(fig,event)
    switch event.Character
        case 'w'
            change_dir(1);
        case 's'
            change_dir(-1);
        case 'a'
            change_dir(-2);
        case 'd'
            change_dir(2);
        case 'p'
            pause(10);
    end      
end

%board functions

function level_One = level_One()
level_One = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
1 3 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2 3 1;
1 2 1 1 1 1 2 1 1 1 1 2 1 2 1 1 1 1 2 1 1 1 1 2 1;
1 2 1 1 1 1 2 1 1 1 1 2 1 2 1 1 1 1 2 1 1 1 1 2 1;
1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1;
1 2 1 1 1 1 2 1 2 1 1 1 1 1 1 1 2 1 2 1 1 1 1 2 1;
1 2 2 2 2 2 2 1 2 2 2 2 1 2 2 2 2 1 2 2 2 2 2 2 1;
1 2 1 2 1 1 2 1 1 1 1 0 0 0 1 1 1 1 2 1 1 2 1 2 1;
1 2 1 2 1 1 2 0 0 0 0 0 1 0 0 0 0 0 2 1 1 2 1 2 1;
1 2 1 2 2 2 2 1 1 0 1 1 1 1 1 0 1 1 2 1 1 2 1 2 1;
1 2 1 1 1 1 2 1 1 0 0 0 0 0 0 0 1 1 2 1 1 2 2 2 1;
1 2 1 1 1 1 2 1 1 0 1 1 1 1 1 0 0 0 2 1 1 1 2 1 1;
1 2 2 2 2 2 2 0 0 0 1 1 1 1 1 0 1 1 2 1 2 2 2 1 1;
1 2 1 2 1 1 2 1 1 0 0 0 0 0 0 0 1 1 2 1 2 1 2 1 1;
1 2 1 2 1 1 2 1 1 0 1 1 1 1 1 0 1 1 2 1 2 1 2 1 1;
1 2 2 2 2 2 2 1 1 0 1 0 0 0 1 0 0 0 2 1 2 2 2 1 1;
1 1 1 1 1 1 2 0 0 0 0 0 1 0 1 1 0 1 2 1 1 1 2 1 1;
1 1 1 1 1 1 2 1 1 1 1 0 1 0 1 1 0 1 2 1 1 1 2 1 1;
1 2 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2 2 1;
1 2 1 1 1 1 2 1 1 1 1 2 2 2 1 1 1 1 2 1 1 2 1 2 1;
1 2 2 2 1 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1 1 2 1 2 1;
1 2 1 2 1 1 2 1 1 1 1 2 2 2 1 1 1 1 2 1 1 2 2 2 1;
1 2 1 2 2 2 2 1 1 1 1 1 2 1 1 1 1 1 2 2 2 1 1 2 1;
1 3 2 2 1 1 2 2 2 2 2 2 0 2 2 2 2 2 2 1 2 2 2 3 1;
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

end
end
