%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% face : face image extracted by face localisation
% rect : face region
% im_out : image which face region was drawed
%
function [face,rect,im_out]=FaceDetect(im)

    % load dictionary for face localisation
    if ~exist('gabor.mat','file')
        fprintf ('Creating Gabor Filters ...');
        create_gabor;
    end
    if exist('net.mat','file')
        load net;
    else
        return;
    end
    try
        im = rgb2gray(im);
    end 

    scale=1;

    scale = 0.17;
    regionArray=[];
    % face localisation in pyramid image by different scaling
    while (1)
        im1 = imresize (im, scale);    
        [m,n]=size(im1);
        [CentroidMatrix,nLabel] = imscan (net,im1);
        for i = 1:nLabel
            a(1) = fix(CentroidMatrix(i).Centroid(2) / scale+0.5);
            a(2) = fix(CentroidMatrix(i).Centroid(1) / scale+0.5);
            a(3) = fix(18 / scale+0.5);
            a(4) = fix(27 / scale+0.5);
            regionArray=[regionArray,a'];
        end
        if (m < 27 | n<18)
            break;
        end
        if (scale > 1.0)
            break;
        end
        scale = scale / 0.8;
        break;
    end
    
    %delete overlapped region
    idxarray=zeros(1,size(regionArray,2));
    removearray=[];
    for i=1:size(regionArray,2)-1
        if (idxarray(i) ~= 0)
            continue;
        end
        region1=regionArray(:,i);
        for j=i+1:size(regionArray,2)
            if (idxarray(j) ~= 0)
                continue;
            end
            region2=regionArray(:,j);
            nSx = max ( region1(1), region2(1) );
            nSy = max (region1(2), region2(2));
            nFx = min (region1(1)+region1(3), region2(1)+region2(3));
            nFy = min (region1(2)+region1(4), region2(2)+region2(4));

            if ( nSx < nFx & nSy < nFy )
                nOverLap = ( nFx - nSx ) * ( nFy - nSy );

                nSx = region1(3) * region1(3);
                nFx = region2(3) * region2(3);

                if ( nOverLap * 100 > min ( nSx, nFx ) * 35 )
                    idxarray(i)=i;
                    removearray=[removearray,i];
                end
            end
            
        end
    end

    regionarray1=[];
    for i=1:size(idxarray,2)
        if idxarray(i) ==0
            regionarray1=[regionarray1,regionArray(:,i)];
        end
    end
    
    % drawing face region on image
    im_out (:,:,1) = im;
    im_out (:,:,2) = im;
    im_out (:,:,3) = im;
    for i = 1:size(regionarray1,2)
        cy=regionarray1(1,i);
        cx=regionarray1(2,i);
        w=regionarray1(3,i);
        h=regionarray1(4,i);
        
        i1=cy-fix(h/2);
        i2=cy+fix(h/2);
        for j = cx-fix(w/2):cx+fix(w/2)
            im_out (i1,j,1)=0;
            im_out (i1,j,2)=255;
            im_out (i1,j,3)=0;            
            im_out (i2,j,1)=0;
            im_out (i2,j,2)=255;
            im_out (i2,j,3)=0;            
        end
        j1=cx-fix(w/2);
        j2=cx+fix(w/2);
        for i=cy-fix(h/2):cy+fix(h/2)
            im_out (i,j1,1)=0;
            im_out (i,j1,2)=255;
            im_out (i,j1,3)=0;            
            im_out (i,j2,1)=0;
            im_out (i,j2,2)=255;
            im_out (i,j2,3)=0;            
        end
    end
    if (size(regionarray1,2) >= 1)
        cy=regionarray1(1,1);
        cx=regionarray1(2,1);
        w=regionarray1(3,1);
        h=regionarray1(4,1);
        rect=[ max(1,cx-fix(w/2)-5) cy-fix(h/2) max(1,w+10) h];
        face=imcrop(im,rect);
    else
        face=[];
        rect=[1 1 0 0];
    end
    
end