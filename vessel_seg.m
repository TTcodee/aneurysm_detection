function [imgVessel,g2,sdMap,vLog] = vessel_seg(img,maxThick)
    % maxThick = maximum thickness of vessel
    
    G = img;
    ig = imcomplement(G);
    maxThick = maxThick/2;
    
    if mod(maxThick,2)==0 
        maxThick = maxThick+1; 
    end
    maxThick = maxThick*2;
    
    se = zeros(maxThick);
    se(:,ceil(maxThick/2)) = 1;
    se(ceil(maxThick/2),:) = 1;
    g2 = imtophat(ig,se);
    g2 = imadjust(g2);
    
	vImg = g2;
	[row,col] = size(img);
	winSize = round(maxThick/2);
	sdMap = zeros(row,col);
	for r = winSize+1:row-winSize-1
		for c = winSize+1:col-winSize-1
			wGray = g2([r-winSize:r+winSize],[c-winSize:c+winSize]);
			sdMap(r,c) = std(double(wGray(wGray>20)));
		end
    end
    
	sd2 = zeros(row,col);
	thres = prctile(sdMap(:),80);
	for r=1:row
		for c=1:col
			if sdMap(r,c) > thres
				sd2(r,c) = 1;
			end
		end
	end
	vLog = sd2;
	vImg(sd2==0)=0;
		
	vImg = ordfilt2(vImg,3,[0 1 0; 1 1 1; 0 1 0]);
	imgVessel = vImg;
	