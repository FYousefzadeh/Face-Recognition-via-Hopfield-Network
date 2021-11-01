clear all ;
clc ;
%% Part A

%% Train :

cd('Datasets');
cd('PartA');
cd('yaleface');
cd('TrainData');
imagefiles = dir('*.normal');
l=length(imagefiles);
for i=1:l
    x = imagefiles(i).name;
    im_train = imread(x);
    r(:,:,i)=imresize(im_train,[32 32]);
    s(:,i)=reshape(r(:,:,i),32*32,1);
    bin_s(:,:,i) = dec2bin(s(:,i)) - '0';
    bin_s(bin_s==0)=-1;
end
for y = 1:size(bin_s,2)
    for x = 1:size(bin_s,3)
        Input_vector(:,x,y) = bin_s(:,y,x);
    end
end

net1=newhop(Input_vector(:,:,1));
net2=newhop(Input_vector(:,:,2));
net3=newhop(Input_vector(:,:,3));
net4=newhop(Input_vector(:,:,4));
net5=newhop(Input_vector(:,:,5));
net6=newhop(Input_vector(:,:,6));
net7=newhop(Input_vector(:,:,7));
net8=newhop(Input_vector(:,:,8));

%% Test
cd('..');
cd('TestData');
imagefiles = dir();
l_test=length(imagefiles);
k=1;
j=1;
for i=3:l_test        
    x= imagefiles(i).name;
    im= imread(x);
    r_test(:,:,i)=imresize(im,[32 32]);
    s_test(:,i)=reshape(r_test(:,:,i),32*32,1);
    bin_s_test(:,:,i) = dec2bin(s_test(:,i)) - '0';
end
r_test(:,:,1:2)=[];
s_test(:,1:2)=[];
bin_s_test(:,:,1:2)=[];
for i=1:70
        y1=net1(1,[],[bin_s_test(:,1,i)]);
        y2=net2(1,[],[bin_s_test(:,2,i)]);
        y3=net3(1,[],[bin_s_test(:,3,i)]);
        y4=net4(1,[],[bin_s_test(:,4,i)]);
        y5=net5(1,[],[bin_s_test(:,5,i)]);
        y6=net6(1,[],[bin_s_test(:,6,i)]);
        y7=net7(1,[],[bin_s_test(:,7,i)]);
        y8=net8(1,[],[bin_s_test(:,8,i)]);
        Y(:,:,i) = [y1,y2,y3,y4,y5,y6,y7,y8];
end
Y(Y >= 0.5) = 1;
Y(Y < 0.5) = 0; 
temp1 = char(Y + 48);
for k = 1:size(Y,3)
    Y_vector(:,k) = bin2dec(temp1(:,:,k));
    Output(:,:,k) = reshape(Y_vector(:,k),[32 32]);
end
for k = 1:70
    for x = 1:7
        temp2(k,x) = sqrt(sum(sum((Output(:,:,k) - double(r(:,:,x))).^2)));
    end
end
dif = temp2';
[A(:,1),A(:,2)] = min(dif);
for k = 1:70
    figure;
    subplot(1,3,1)
    imshow(r_test(:,:,k))
    title('Test Image')
    subplot(1,3,2)
    imshow(Output(:,:,k),[])
    title('Retrieved Image')
    subplot(1,3,3)
    imshow(r(:,:,A(k,2)),[])
    title('Most matched normal Image')
end
% acuracy
bin = [1;2;3;4;5;6;7];
nu = 0;
for i = 1:7
    b = bin(i,:);
    for j= 1:10
        nu = nu+1;
        Test_Lable(nu,1)= b;
    end
end
ac(A(:,2) == Test_Lable) = 1;
acuracy = ac';
acuracy_img1 = acuracy(1:10);
Accuracy_subject1 = mean(acuracy_img1) * 100
acuracy_img2 = acuracy(11:20);
Accuracy_subject2 = mean(acuracy_img2) * 100
acuracy_img3 = acuracy(21:30);
Accuracy_subject3 = mean(acuracy_img3) * 100
acuracy_img4 = acuracy(31:40);
Accuracy_subject4 = mean(acuracy_img4) * 100
acuracy_img5 = acuracy(41:50);
Accuracy_subject5 = mean(acuracy_img5) * 100
acuracy_img6 = acuracy(51:60);
Accuracy_subject6 = mean(acuracy_img6) * 100
acuracy_img7 = acuracy(61:70);
Accuracy_subject7 = mean(acuracy_img7) * 100
Accuracy_Total = mean(acuracy) * 100