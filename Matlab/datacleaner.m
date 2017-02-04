clear all;
load('datafull.mat');
filecode = 2;

switch filecode
    case 1
        mapdata = mapdata1full;
    case 2
        mapdata = mapdata2full;
end

rowsize = size(mapdata,1)-7;
colsize = size(mapdata,2)-1;

generatetable;
nodesize = size(nodetable,2);
edgesize = size(edgetable,2);

for i = 1:colsize
    for j = 1:rowsize
        %% Get date
        total(j + rowsize * (i-1),1) = mapdata(1,i+1);
        
        %% Get Time
        if(isempty(mapdata(2,i+1)))
            total(j + rowsize * (i-1),2) = '';
        else
            total(j + rowsize * (i-1),2) = mapdata(2,i+1);
        end
        
        %% Get Tree or Trail
        if(isempty(findstr(char(mapdata(j+7,1)),'_')))
            total(j + rowsize * (i-1),3) = {0};
        else
            total(j + rowsize * (i-1),3) = {1};
        end
        
        %% Get names of tree or trail
        total(j + rowsize * (i-1),4) = mapdata(j+7,1);
        
        %% Convert data entry
        if(strcmp(mapdata(j+7,i+1),'0'))
            total(j+rowsize*(i-1),5:8) = {0};
        elseif(strcmp(mapdata(j+7,i+1),'N/A'))
            total(j+rowsize*(i-1),5:8) = {9};
        elseif(strcmp(mapdata(j+7,i+1),''))
            total(j+rowsize*(i-1),5:8) = {'*'};
        else
            % Case is node
            nodeindex = find(strcmp(nodetable, mapdata(j+7,i+1)));
            edgeindex = find(strcmp(edgetable, mapdata(j+7,i+1)));
            if(isempty(nodeindex) && isempty(edgeindex))
                total(j+parpool('local')*(i-1),5:8) = {'#'};
            else
                if(~isempty(nodeindex))
                    if((nodeindex > 0) && (nodeindex < 21))
                        % argentine only
                        total(j+rowsize*(i-1),5) = {str2num(nodecode{nodeindex}(1))};
                        total(j+rowsize*(i-1),6) = {str2num(nodecode{nodeindex}(2))};
                        total(j+rowsize*(i-1),7) = {0};
                        total(j+rowsize*(i-1),8) = {0};
                    elseif((nodeindex >= 21) && (nodeindex < 41))
                        % winter only
                        total(j+rowsize*(i-1),5) = {0};
                        total(j+rowsize*(i-1),6) = {0};
                        total(j+rowsize*(i-1),7) = {str2num(nodecode{nodeindex}(1))};
                        total(j+rowsize*(i-1),8) = {str2num(nodecode{nodeindex}(2))};
                        
                    elseif((nodeindex >= 41) && (nodeindex < 441))
                        % argentine and winter
                        total(j+rowsize*(i-1),5) = {str2num(nodecode{nodeindex}(1))};
                        total(j+rowsize*(i-1),6) = {str2num(nodecode{nodeindex}(2))};
                        total(j+rowsize*(i-1),7) = {str2num(nodecode{nodeindex}(3))};
                        total(j+rowsize*(i-1),8) = {str2num(nodecode{nodeindex}(4))};
                        
                    else
                        % winter and argentine
                        total(j+rowsize*(i-1),5) = {str2num(nodecode{nodeindex}(3))};
                        total(j+rowsize*(i-1),6) = {str2num(nodecode{nodeindex}(4))};
                        total(j+rowsize*(i-1),7) = {str2num(nodecode{nodeindex}(1))};
                        total(j+rowsize*(i-1),8) = {str2num(nodecode{nodeindex}(2))};
                    end
                end
                % Case is edge
                index = find(strcmp(edgetable, mapdata(j+7,i+1)));
                if(~isempty(edgeindex))
                    if((edgeindex > 0) && (edgeindex < 5))
                        % argentine only
                        total(j+rowsize*(i-1),6) = {str2num(edgecode{edgeindex}(1))};
                        total(j+rowsize*(i-1),5) = {str2num(edgecode{edgeindex}(2))};
                        total(j+rowsize*(i-1),7) = {0};
                        total(j+rowsize*(i-1),8) = {0};
                    elseif((edgeindex >= 5) && (edgeindex < 9))
                        % winter only
                        total(j+rowsize*(i-1),5) = {0};
                        total(j+rowsize*(i-1),6) = {0};
                        total(j+rowsize*(i-1),8) = {str2num(edgecode{edgeindex}(1))};
                        total(j+rowsize*(i-1),7) = {str2num(edgecode{edgeindex}(2))};
                        
                    elseif((edgeindex >= 9) && (edgeindex < 25))
                        % argentine and winter
                        total(j+rowsize*(i-1),6) = {str2num(edgecode{edgeindex}(1))};
                        total(j+rowsize*(i-1),5) = {str2num(edgecode{edgeindex}(2))};
                        total(j+rowsize*(i-1),8) = {str2num(edgecode{edgeindex}(3))};
                        total(j+rowsize*(i-1),7) = {str2num(edgecode{edgeindex}(4))};
                        
                    else
                        % winter and argentine
                        total(j+rowsize*(i-1),6) = {str2num(edgecode{edgeindex}(3))};
                        total(j+rowsize*(i-1),5) = {str2num(edgecode{edgeindex}(4))};
                        total(j+rowsize*(i-1),8) = {str2num(edgecode{edgeindex}(1))};
                        total(j+rowsize*(i-1),7) = {str2num(edgecode{edgeindex}(2))};
                    end
                end
            end
            
        end
        
    end
    [Y,I]=sort([total{rowsize*(i-1)+1:rowsize*i,3}]);
    B = total(I+rowsize*(i-1),:);
    B_zero = B(find([B{:,3}] == 0),:);
    B_one = B(find([B{:,3}] == 1),:);
    [Y_zero,I_zero] = sort(B_zero(:,4));
    [Y_one,I_one] = sort(B_one(:,4));
    C_zero = B_zero(I_zero,:);
    C_one = B_one(I_one,:);
    total(rowsize*(i-1)+1:rowsize*i,:) = vertcat(C_zero,C_one);
end

header = {'date', 'time', ...
    'tree(0)/trail(1)', 'name', 'L.humile', '', 'P.imparis', ''};
switch filecode
    case 1
        fid = fopen('/Users/GailLee/Documents/GithubWS/ArgentineMapProject/newmapdata1.csv', 'w');
    case 2
        fid = fopen('/Users/GailLee/Documents/GithubWS/ArgentineMapProject/newmapdata2.csv', 'w');
end

fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s\n',header{:});
for i = 1: size(total,1)
    fprintf(fid,'%s, %s, %d, %s, %d, %d, %d, %d\n',total{i,:});
end
fclose(fid)