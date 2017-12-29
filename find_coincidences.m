function [match,keywords_found] = find_coincidences(citation)
    [~,~,keywords] = xlsread('keywords.xlsx','Sheet1');
    [~, total_keywords] = size(keywords);
    match = zeros(size(keywords));
    keywords_found(1,1) = {'null'};
    j=1;
    for i=1:total_keywords
        key = keywords{1,i};
        [~, k] = size(strfind(citation,key));
        if(k>0) 
            match(i) = 1;
            keywords_found(1,j) = {key};
            j=j+1;
        end
    end
end
    
