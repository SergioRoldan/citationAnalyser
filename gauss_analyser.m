function [Gauss_out] = gauss_analyser(match)
    % Citations classifier
    i_plot=1;                               % 1 dibuja BD
    i_lineal=1;                             % Linear Classifier
    i_gauss=1; 
    
    %Loading Database
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
    % GeneraciOn BD Train (60 %), Cross Validation (20%) y BD Test (20%)

    % Generacion BD Train, BD Validation, BD Test
    N_train=round(0.9*N_datos);
    N_val=N_datos-N_train;

    % Train
    X_train=X(1:N_train,:);
    Labs_train=Labs(1:N_train);

    %Val: Validation
    X_val=X(N_train+1:N_train+N_val,:);
    Labs_val=Labs(N_train+1:N_train+N_val);

    clear indexperm

    % Clasificador kernel gaussiano
    Err_val_min = 1;
    Err_train = zeros(50,5);
    Err_val = zeros(50,5);
    P_opt = 0;
    h_opt = 0;

    j = 1;
    if i_gauss ==1
        for P = 0.01:0.1:5
            i = 1;
            for h = [1 2.5 10 25 100]
                Gauss_model = fitcsvm(X_train, Labs_train, 'BoxConstraint',P,'KernelFunction','RBF','KernelScale',h);
                Gauss_out = predict(Gauss_model, X_train);
                Err_train(j,i)=sum(Gauss_out~=Labs_train)/length(Labs_train);
                Gauss_out = predict(Gauss_model, X_val);
                Err_val(j,i)=sum(Gauss_out~=Labs_val)/length(Labs_val);
                if Err_val(j,i) < Err_val_min
                    Err_val_min = Err_val(j,i);
                    Gauss_model_min = Gauss_model;
                    P_opt = P;
                    h_opt = h;
                end
                i = i+1;
            end
            j = j+1;
        end
    end

    clear i_gauss


    % Predict labels
    %Obtain match vector
    %Check the validity of the match vector
    N_feat_new=size(match,2);
    if N_feat_new ~= N_feat
        error('Characteristics vector dimension mismatch')
    end
    Gauss_out = predict(Gauss_model_min, match);
    
end