% Step2: loading train data and test data
load traindb;
load traindblabel;
load testdb;
load testdblabel;
classnum=6;

MaxIter = 5; % boosting iterations
traindblabel1=traindblabel;
testdblabel1=testdblabel;

mECOC=[
    1 0 0;%Angry
    0 1 0;%Disgust
    0 1 1;%Fear
    0 0 1;%Happy
    1 1 0;%Sad 
    1 0 1 %Surprise
    ];
err=zeros(classnum,2);
traindb=[traindb testdb];
for i=1:size(mECOC,2)
    traindblabel1=-ones(size(traindblabel,1),size(traindblabel,2));
    testdblabel1=-ones(size(testdblabel,1),size(testdblabel,2));
    for iclass=1:classnum
        if mECOC(iclass,i)==1
            for isam=1:length(traindblabel)
                if traindblabel(isam) == iclass
                    traindblabel1(isam)=1;
                end
            end
            for isam=1:length(testdblabel)
                if testdblabel(isam) == iclass
                    testdblabel1(isam)=1;
                end
            end
        end
    end


    traindblabel1=[traindblabel1 testdblabel1];
    weak_learner = tree_node_w(1); % pass the number of tree splits to the constructor
    if i==1
        [RLearners1 RWeights1] = RealAdaBoost(weak_learner, traindb, traindblabel1, MaxIter);
        ResultTrainR1 = sign(Classify(RLearners1, RWeights1, traindb));
        err(i,1)  = sum(traindblabel1 ~= ResultTrainR1) / length(traindblabel1);
    elseif i==2
        [RLearners2 RWeights2] = RealAdaBoost(weak_learner, traindb, traindblabel1, MaxIter);
        ResultTrainR2 = sign(Classify(RLearners2, RWeights2, traindb));
        err(i,1)  = sum(traindblabel1 ~= ResultTrainR2) / length(traindblabel1);
    elseif i==3
        [RLearners3 RWeights3] = RealAdaBoost(weak_learner, traindb, traindblabel1, MaxIter);
        ResultTrainR3 = sign(Classify(RLearners3, RWeights3, traindb));
        err(i,1)  = sum(traindblabel1 ~= ResultTrainR3) / length(traindblabel1);
    end
    
    if i==1
        disp('  TrainErr');
    end
    
end
disp(err);
save RLearners1 RLearners1;
save RLearners2 RLearners2;
save RLearners3 RLearners3;
