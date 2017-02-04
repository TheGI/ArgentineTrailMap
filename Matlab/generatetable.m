anttype = {'a', 'w'};
trunktype = {'np', 'p', 'wup', 'mup', 'n'};
basetype = {'np', 'p', 'm', 'n'};
strengthtype = {'we', 'ma'};
distancetype = {'pa', 'fu'};

trunkvalue = {'0', '1', '2', '3', '4'};
basevalue = {'0','1','3','4'};
strengthvalue = {'7','8'};
distancevalue = {'5','6'};

for i = 1:size(anttype,2)
    for j = 1:size(trunktype,2)
        for k = 1:size(basetype,2)
            nodetable(k + size(basetype,2) * (j-1) + ...
                size(basetype,2)*size(trunktype,2) * (i-1)) = ...
                strcat(anttype(i),trunktype(j),basetype(k));
        end
    end
end


for i = 1:20
    for j = 1:20
        nodetable(j + (i-1)*20 + 40) = ...
            strcat(nodetable(i),nodetable(j+20));
    end
end

for i = 1:20
    for j = 1:20
        nodetable(j + (i-1)*20 + 440) = ...
            strcat(nodetable(j+20),nodetable(i));
    end
end

for i = 1:size(anttype,2)
    for j = 1:size(trunkvalue,2)
        for k = 1:size(basevalue,2)
            nodecode(k + size(basevalue,2) * (j-1) + ...
                size(basevalue,2)*size(trunkvalue,2) * (i-1)) = ...
                strcat(trunkvalue(j),basevalue(k));
        end
    end
end

for i = 1:20
    for j = 1:20
        nodecode(j + (i-1)*20 + 40) = ...
            strcat(nodecode(i),nodecode(j+20));
    end
end

for i = 1:20
    for j = 1:20
        nodecode(j + (i-1)*20 + 440) = ...
            strcat(nodecode(j+20),nodecode(i));
    end
end

for i = 1:size(anttype,2)
    for j = 1:size(strengthtype,2)
        for k = 1:size(distancetype,2)
            edgetable(k + size(distancetype,2) * (j-1) + ...
                size(distancetype,2)*size(strengthtype,2) * (i-1)) = ...
                strcat(anttype(i),strengthtype(j),distancetype(k));
        end
    end
end

for i = 1:4
    for j = 1:4
        edgetable(j + (i-1)*4 + 8) = ...
            strcat(edgetable(i),edgetable(j+4));
    end
end

for i = 1:4
    for j = 1:4
        edgetable(j + (i-1)*4 + 24) = ...
            strcat(edgetable(j+4),edgetable(i));
    end
end

for i = 1:size(anttype,2)
    for j = 1:size(strengthvalue,2)
        for k = 1:size(distancevalue,2)
            edgecode(k + size(distancevalue,2) * (j-1) + ...
                size(distancevalue,2)*size(strengthvalue,2)*(i-1))= ...
                strcat(strengthvalue(j),distancevalue(k));
        end
    end
end

for i = 1:4
    for j = 1:4
        edgecode(j + (i-1)*4 + 8) = ...
            strcat(edgecode(i),edgecode(j+4));
    end
end

for i = 1:4
    for j = 1:4
        edgecode(j + (i-1)*4 + 24) = ...
            strcat(edgecode(j+4),edgecode(i));
    end
end