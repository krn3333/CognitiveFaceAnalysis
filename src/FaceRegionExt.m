function [faceregion]=FaceRegionExt(im)
process=1;

switch process
    case 1
        faceregion=FaceDetect_default (im);
    case 2
        [face rect im_out] = FaceDetect (im);

       [lx,ly,rx,ry]=EyeDetect(face);
       lx=lx+rect(1);
       ly=ly+rect(2);
       rx=rx+rect(1);
       ry=ry+rect(2);
        nW=64, nH=64, nStdW=64, nStdH=64, nX1=16, nY1=14, nX2=48, nY2=14;
        mTransform=zeros(3);

        %############################
        sx1 = lx;
        sy1 = ly;
        sx2 = rx;
        sy2 = ry;
        dx1 = nX1 * nW / nStdW;
        dx2 = nX2 * nW / nStdW;
        dy1 = nY1 * nH / nStdH;
        dy2 = nY2 * nH / nStdH;

        sourceMidX = (sx1 + sx2)*0.5;
        sourceMidY = (sy1 + sy2)*0.5;
        destMidX = (dx1 + dx2)*0.5;
        destMidY = (dy1 + dy2)*0.5;
        mTranslate1=eye(3),mTranslate1(1,3)=-sourceMidX,mTranslate1(2,3)=-sourceMidY;
        mTranslate2=eye(3),mTranslate2(1,3)=destMidX,mTranslate2(2,3)=destMidY;

        sdist = sqrt((sx1 - sx2)^2 + (sy1 - sy2)^2);
        ddist = sqrt((dx1 - dx2)^2 + (dy1 - dy2)^2);
        s = ddist/sdist;
        mScale=eye(3),mScale(1,1)=s,mScale(2,2)=s;

        stheta = atan((sy2 -sy1)/(sx2 - sx1));
        dtheta = atan((dy2 -dy1)/(dx2 - dx1));
        theta  = dtheta - stheta;
        mRotate=eye(3),
        mRotate(1,1)=cos(theta), mRotate(2,2)=cos(theta);
        mRotate(1,2)=-sin(theta), mRotate(2,1)=sin(theta);

        mT=mScale*mTranslate1;
        mT1=mRotate*mT;
        mTransform=mTranslate2*mT1;

        mInverse = inv(mTransform);
        J=zeros(64);
        point=zeros(3,1);
        for i=1:64
            for j=1:64
                point(1)=i;
                point(2)=j;
                point(3)=1;
                pt1=mInverse*point;
                x = pt1(1) / pt1(3);
                y = pt1(2) / pt1(3);
                xfrac = (x - floor(x));
                yfrac = (y - floor(y));
                xLower = floor(x); xLower = max(xLower, 1); xLower = min(xLower, size(im,2));
                xUpper = ceil(x); xUpper = max(xUpper, 1); xUpper = min(xUpper, size(im,2));
                yLower = floor(y); yLower = max(yLower, 1); yLower = min(yLower, size(im,1));
                yUpper = ceil(y); yUpper = max(yUpper, 1); yUpper = min(yUpper, size(im,1));
                valUpper = im(yUpper,xLower)*(1.0-xfrac) + im(yUpper,xUpper)*(xfrac);
                valLower = im(yLower,xLower)*(1.0-xfrac) + im(yLower,xUpper)*(xfrac);
                J(j,i)=valLower*(1.0-yfrac) + valUpper*(yfrac);
            end
        end
        faceregion = J;
end

end