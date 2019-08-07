function [path] = findPath(startloc,targetloc, m)

openSet = [];
closedSet = [];

gCost = m;
hCost = m;

mapSize = size(m);
parent = zeros(mapSize(1),mapSize(2), 2);
for x = 1:mapSize(1)
    for y = 1:mapSize(2)
        gCost(x,y) = Inf;
        hCost(x,y) = Inf;
    end
end

gCost(startloc(1), startloc(2)) = 0;
hCost(startloc(1), startloc(2)) = 0;

openSet = [openSet; rot90(startloc)];
setSize = size(openSet);
while(setSize(2) > 0) %#ok<ISMT>
    activePos = openSet(:,1);
    for i = 1:setSize(2)
        
        node = openSet(:,i);  
        
        if(gCost(node(1), node(2)) + hCost(node(1), node(2)) <= gCost(activePos(1), activePos(2)) + hCost(activePos(1), activePos(2)))
            if(hCost(node(1), node(2)) < hCost(activePos(1), activePos(2)))
                activePos = node;
            end
        end
    end
    openSet(:,i) = [];
    closedSet = [closedSet, [activePos(1); activePos(2)]];
    
    if([activePos(1), activePos(2)] == targetloc)
       path = [targetloc(1); targetloc(2)];
       prevNode = parent(targetloc(1), targetloc(2),:);
       prevNode = [prevNode(1,1,1); prevNode(1,1,2)];
       while(prevNode(1) ~= rot90(startloc))
          path = [prevNode, path];
          prevNode = parent(prevNode(1), prevNode(2),:);
          prevNode = [prevNode(1,1,1); prevNode(1,1,2)];
       end
       path = [[startloc(1); startloc(2)], path];
       path = flip(rot90(path));
       return;
    end
    
    
    for x = -1:1
        for y = -1:1
            if(abs(x) + abs(y) == 1)
                neighbourPos = [activePos(1,1) + x, activePos(2,1) + y];
                
                neighbour = m(neighbourPos(1), neighbourPos(2));
                
                if (neighbour == 1 | isMemberOF(closedSet, neighbourPos) == 1)
                    continue;
                end
                costtoNeighbour = gCost(activePos(1), activePos(2)) + 1;
                if(costtoNeighbour < gCost(neighbourPos(1), neighbourPos(2)) | isMemberOF(openSet, neighbourPos) == 0)
                    gCost(neighbourPos(1), neighbourPos(2)) = costtoNeighbour;
                    hCost(neighbourPos(1), neighbourPos(2)) = 1;
                    parent(neighbourPos(1), neighbourPos(2), :) = activePos;
                    
                    if(isMemberOF(openSet, neighbourPos) == 0)
                        openSet = [openSet, [neighbourPos(1);neighbourPos(2)]];
                    end
                end
            end
        end
    end
end

function [isTrue] = isMemberOF(array,element)
    arraySize = size(array);
    for i=1:arraySize(2)
        if(element(1) == array(1,i) && element(2) == array(2,i))
           isTrue = 1;
           return;
        end 
    end
    isTrue = 0;