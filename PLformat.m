%%
%April 09, 2016
%By Dinkisa A.
%%
function [ out_data ] = PLformat( in_data,resolution, area,defaultValue)

    LLx = area(1);
    LLy = area(3);
    URx = area(2);
    URy = area(4);
    Num_grid_H = (URx - LLx)/resolution;%horizontal number of grid
    Num_grid_V = (URy - LLy)/resolution;%vertical number of grid
    tot_pixel = (Num_grid_H + 1) * (Num_grid_V + 1);
    temp = zeros(tot_pixel,3);
    for grid_H = 1:(Num_grid_H + 1)
        H_temp = (grid_H - 1)*resolution + resolution/2;
        for grid_V = 1:(Num_grid_V + 1)
            V_temp = (grid_V - 1)*resolution + resolution/2;
            temp(grid_V + (grid_H-1)*(Num_grid_V + 1),:) = [LLx + H_temp,LLy + V_temp, defaultValue];
        end
    end
    [row,col] = size(in_data);
    for r = 1:row
       xx = in_data(r,1);
       yy = in_data(r,2);
       for pp = 1:tot_pixel
           if temp(pp,1) == xx
               if temp(pp,2) == yy
                   temp(pp,3) = in_data(r,3);
               end
           end
       end   
    end
    temp02 = vec2mat(temp(:,3),Num_grid_V + 1);
    temp03 = temp02';
    for pp = 1:(Num_grid_V + 1)
        out_data(pp,:) = temp03(Num_grid_V + 1 - pp + 1,:);
    end 
%     out_data = temp03;
end

