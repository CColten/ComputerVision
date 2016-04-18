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

%���߸�ֵΪ0
BinX(:,1)   = zeros(row,1);
BinX(:,col) = zeros(row,1);
BinY(1,:)   = zeros(1,col);
BinY(row,:) = zeros(1,col);
edgeWidth = zeros(1, col);   %������ͳ��
edgeX = 1 : col;

% ��ԭͼ���б�ʾ��ֵ��
%  1 ��ʾ����ֵ��
% -1 ��ʾ��Сֵ��
% imageExtremes = double(image);
for i = 1 : row
   peaks =  imregionalmax(image(i,:));
%    X =  image(i, :);
   tmax = edgeX(peaks);
   
   
   valley = imregionalmin(image(i,:));
%    Y = image(i,:);
   tmin = edgeX(valley);
   
   %ͳ�Ʊ�Ե���
   for j = 1 : col
       toMaxNearest = 0;
       toMinNearest = 0;
       
       maxNearest = abs(tmax - j);                    %���м���ֵ��λ��
       [minMaxNearest, minMaxLoc] = min(maxNearest);  %����õ�����ļ���ֵ�ľ���
       minNearest = abs(tmin -j);                     %���м�Сֵ��λ��
       [minMinNearest, minMinLoc] = min(minNearest);  %����õ�����ļ�Сֵ�ľ���
       
%        if minMaxNearest == 0
       if minMaxNearest > minMinNearest  %�õ��뼫Сֵ��           
           if j > minMinLoc  %��Сֵ�ڸõ����2
               toMaxNearest = min(maxNearest(maxNearest > minMinNearest)); %���Ҳ��һ������ֵ��ľ���
           else  
               if j < minMinLoc % �����㱾�Ǽ�ֵ��ĵ�
                 toMaxNearest =  max(maxNearest(maxNearest > minMinNearest)); %������һ������ֵ��ľ���
               end
           end
           distance = minMinNearest + toMaxNearest;
       else  %�õ��뼫��ֵ��
           if j > minMaxLoc
               toMinNearest = min(minNearest(minNearest > minMaxNearest)); %���Ҳ��һ����Сֵ��ľ���
           else
               if j < minMaxLoc
                   toMinNearest = max(minNearest(minNearest > minMaxNearest)); %������һ����Сֵ��ľ���
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








