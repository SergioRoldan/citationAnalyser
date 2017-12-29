function [valoration, keywords_found] = citation_analysis(citation)
    [match, keywords_found] = find_coincidences(citation);
    result = gauss_analyser(match);
    if(strcmp(keywords_found(1,1),'null'))
        valoration = 0; %'The analysed citation corresponds to a lazy citation.'
    else
        if(result == 0) 
            valoration = 1; %'The analysed citation possibly corresponds to a negative citation.'
        else 
            valoration = 2; %'The analysed citation corresponds to a positive citation.'
        end
    end
end