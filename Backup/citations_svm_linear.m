%% CBI
% Citations classifier

clear
close all
clc

i_plot=1;                               % 1 dibuja BD
i_lineal=1;                             % Linear Classifier
i_gauss=1;                              % Gaussian Kernel Classifier

%% Loading Database
% Read references.txt file if matlab variable doesn't exist
if ~exist('references.mat', 'file')
    references = dlmread('reference_db.txt','\t');
    save('references','references')
end
% Load variable
load references
Labs=references(:,end);
N_feat=size(references,2)-1;
X=references(:,1:N_feat);
N_datos=length(Labs);

%% Generaci�n BD Train (60 %), Cross Validation (20%) y BD Test (20%)
%Aleatorizaci�n orden de los vectores
%indexperm=randperm(N_datos);
%X=X(indexperm,:);
%Labs=Labs(indexperm);

% Generaci�n BD Train, BD Validation, BD Test
N_train=round(0.9*N_datos);
N_val=N_datos-N_train;

% Train
X_train=X(1:N_train,:);
Labs_train=Labs(1:N_train);

%Val: Validation
X_val=X(N_train+1:N_train+N_val,:);
Labs_val=Labs(N_train+1:N_train+N_val);

clear indexperm
%% Clasificador lineal
if i_lineal ==1
    P = 0.1;
    Linear_model = fitcsvm(X_train, Labs_train, 'BoxConstraint',P);
    fprintf(1,'\n Clasificador SVM lineal\n')
    Linear_out = predict(Linear_model, X_train);
    Err_train=sum(Linear_out~=Labs_train)/length(Labs_train);
    fprintf(1,'error train = %g   \n', Err_train)
    Linear_out = predict(Linear_model, X_val);
    Err_val=sum(Linear_out~=Labs_val)/length(Labs_val);
    fprintf(1,'error val = %g   \n', Err_val)
    fprintf(1,'\n  \n  ')
    % Test confusion matrix
    CM_Linear_val=confusionmat(Labs_val,Linear_out)
    clear Err_train Err_test Linear_out
end
clear i_lineal

%% Predict labels

% Read non labeled file
new_dataset = dlmread('new_dataset.txt','\t');
N_feat_new=size(new_dataset,2);
if N_feat_new ~= N_feat
    error('Characteristics vector dimension mismatch')
end
X_test=new_dataset;

Gauss_out = predict(Linear_model, X_test);
