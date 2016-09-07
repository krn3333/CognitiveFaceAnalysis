clear all;
close all;
load traindb;
load traindblabel;
load testdb;
load testdblabel;

load RLearners1;
load RLearners2;
load RLearners3;

classnum=6;
traindb=(traindb)/256;
testdb=(testdb)/256;

c = 1000;
lambda = 1e-7;
kerneloption= 2;
kernel='gaussian';
verbose = 1;

traindb=[traindb testdb];
traindblabel=[traindblabel testdblabel];

traindb_svmlabel=traindblabel';
testdb_svmlabel=testdblabel';

a=[];
for i=1:3
    if (i==1)
        for k = 1 : length(RLearners1)
           out=get_dim(RLearners1{k});
            a=[a out];
        end
    elseif i==2
        for k = 1 : length(RLearners2)
           out=get_dim(RLearners2{k});
            a=[a out];
        end
    elseif i==3
        for k = 1 : length(RLearners3)
           out=get_dim(RLearners3{k});
            a=[a out];
        end
    end
end

idxarray=zeros(1,size(traindb,1));

traindb_svm = [];
testdb_svm = [];
for k = 1 : length(a)
   if (idxarray(a(k))==1)
       continue;
   end
  traindb_svm=[traindb_svm traindb(a(k),:)'];
  testdb_svm=[testdb_svm testdb(a(k),:)'];
  idxarray(a(k))=1;
end


dbidx = zeros(10, size(traindb_svm,1));
for i=1:size(traindb_svm,1)
    ifold=round(rand(1)*10 + 0.5);
    dbidx(ifold,i)=1;
end
totaldb=traindb_svm;
totaldb_label=traindb_svmlabel;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trainrecograte=[];
testrecograte=[];
for iFold=1:10
    traindb_svm=[], traindb_svmlabel=[], testdb_svm=[], testdb_svmlabel=[];
    for isam=1:size(totaldb,1)
        if (dbidx(iFold,isam) == 1)
            testdb_svm=[testdb_svm' totaldb(isam,:)']';
            testdb_svmlabel=[testdb_svmlabel' totaldb_label(isam,:)']';
        else
            traindb_svm=[traindb_svm' totaldb(isam,:)']';
            traindb_svmlabel=[traindb_svmlabel' totaldb_label(isam,:)']';
        end
    end
    clear xsup, clear w, clear b, clear nbsv;
    
    nbclass=6;
    [xsup,w,b,nbsv]=svmmulticlassoneagainstall(traindb_svm,traindb_svmlabel,nbclass,c,lambda,kernel,kerneloption,verbose);
    [ytrain,maxi] = svmmultival(traindb_svm,xsup,w,b,nbsv,kernel,kerneloption);
    [ytest,maxi] = svmmultival(testdb_svm,xsup,w,b,nbsv,kernel,kerneloption);

    filename=sprintf('recograteSVM1toall_fold_%d.txt',iFold);
    fid = fopen(filename, 'w');
    recognum=0;
    numImage=size(traindb_svm,1);
    for k=1:numImage
        if ytrain(k) == traindb_svmlabel(k)
            recognum = recognum + 1;
        end
    end
    trainrecograte(iFold) = recognum / numImage*100;
    fprintf (fid, 'train performace  %.2f\n',trainrecograte(iFold));

    recognum=0;
    numImage=size(testdb_svm,1);
    for k=1:numImage
        if ytest(k) == testdb_svmlabel(k)
            recognum = recognum + 1;
            fprintf (fid, '%d  %d : true\n', testdb_svmlabel(k), ytest(k));
        else
            fprintf (fid, '%d  %d : false\n', testdb_svmlabel(k), ytest(k));
        end
    end
    testrecograte(iFold) = recognum / numImage*100;
    fprintf (fid, 'test performace  %.2f',testrecograte(iFold));

    fclose(fid);

    save xsup xsup, save w w, save b b, save nbsv nbsv;

end
meantrainrecog = sum(trainrecograte)/10;
meantestrecog = sum(testrecograte)/10;
filename=sprintf('recograteSVM1toall_fold.txt');
fid = fopen(filename, 'w');
fprintf (fid, 'train    test\n');
for i=1: 10
    fprintf (fid, '%.2f   %.2f\n',trainrecograte(i), testrecograte(i));
end
fprintf (fid, '%.2f   %.2f\n',meantrainrecog, meantestrecog);
fclose(fid);