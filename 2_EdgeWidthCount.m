% function [edgeX, edgeY, imageExtremes] = edgeWidthCount(Bx, By, image)
function [edgeWidth] = EdgeWidthCount(BinX, BinY, image)
%********************************
% function:
%    input:  Bx:
%            By:
%            image: 
%   output:  edgeWidth:
%********************************
[row, col] = size(BinX);

%将边赋值为0
BinX(:,1)   = zeros(row,1);
BinX(:,col) = zeros(row,1);
BinY(1,:)   = zeros(1,col);
BinY(row,:) = zeros(1,col);
edgeWidth = zeros(1, col);   %定义宽度统计
edgeX = 1 : col;

% 在原图像中表示极值点
%  1 表示极大值点
% -1 表示极小值点
% imageExtremes = double(image);
for i = 1 : row
   peaks =  imregionalmax(image(i,:));
%    X =  image(i, :);
   tmax = edgeX(peaks);
   
   
   valley = imregionalmin(image(i,:));
%    Y = image(i,:);
   tmin = edgeX(valley);
   
   %统计边缘宽度
   for j = 1 : col
       toMaxNearest = 0;
       toMinNearest = 0;
       
       maxNearest = abs(tmax - j);                    %所有极大值的位置
       [minMaxNearest, minMaxLoc] = min(maxNearest);  %距离该点最近的极大值的距离
       minNearest = abs(tmin -j);                     %所有极小值的位置
       [minMinNearest, minMinLoc] = min(minNearest);  %距离该点最近的极小值的距离
       
%        if minMaxNearest == 0
       if minMaxNearest > minMinNearest  %该点离极小值近           
           if j > minMinLoc  %极小值在该点左边2
               toMaxNearest = min(maxNearest(maxNearest > minMinNearest)); %到右侧第一个极大值点的距离
           else  
               if j < minMinLoc % 不计算本是极值点的点
                 toMaxNearest =  max(maxNearest(maxNearest > minMinNearest)); %到左侧第一个极大值点的距离
               end
           end
           distance = minMinNearest + toMaxNearest;
       else  %该点离极大值近
           if j > minMaxLoc
               toMinNearest = min(minNearest(minNearest > minMaxNearest)); %到右侧第一个极小值点的距离
           else
               if j < minMaxLoc
                   toMinNearest = max(minNearest(minNearest > minMaxNearest)); %到左侧第一个极小值点的距离
               end
           end
           distance = minMaxNearest + toMinNearest;            
       end
       
       if distance == 0
           continue;
       else
           edgeWidth(1, distance) = edgeWidth(1, distance) + 1;
       end
   end

   trow = i*ones(1, length(tmax));
   imageExtremes(sub2ind(size(imageExtremes),trow,tmax)) =  1;    
   imageExtremes(sub2ind(size(imageExtremes),trow,tmin)) = -1;   
end
imageExtremes(find(~(imageExtremes == 1 | imageExtremes == -1))) = 0;








