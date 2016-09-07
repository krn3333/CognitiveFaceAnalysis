clear all;
clc;
close all;
while (1==1)
    choice=menu('Facial Expression Recognition',...
                'Create database',...
                'Training for feature selection',...
                'Training SVM',...
                'Test Face Detection',...
                'Test Facial Expression',...
                'Exit');
    if (choice ==1)
        % creat database 
        CreateDatabase;
    elseif (choice ==2)
        % feature selection sby AdaBoost
        TrainFeaSelectECOC;
    elseif  (choice == 3)
        % training by SVM
        TrainSVM1toallECOC;
    elseif (choice == 4)
        % testing face detection
        TestFaceDetect;
    elseif (choice == 5)
        % test facial expression recognition on photos
        TestPhoto1toall;
    elseif (choice == 6)
        % exit program
        clear all;
        clc;
        close all;
        return;
    end
end