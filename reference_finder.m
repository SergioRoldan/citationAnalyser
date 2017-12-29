function [num_citations, citations, error] = reference_finder(researcher_surname, paper_name, others, paper_directory)
    num_citations = 0;
    citations = {''};
    paper = extractFileText(paper_directory);
    cut_chars = 50;
    paper_char = convertStringsToChars(paper);
    pos_references_title = strfind(paper, 'REFERENCES');
    
    if(size(pos_references_title) == [0,0])
        pos_references_title = strfind(paper, 'References');
    end
    
    paper_cut_to_references = paper_char(pos_references_title:length(paper_char));
    paper_cut_to_references_char = convertStringsToChars(paper_cut_to_references);
    
    paper_without_references = paper_char(1:pos_references_title);
    paper_without_references_char = convertStringsToChars(paper_without_references);
    %length(paper_without_references);
    
    pos_surname = strfind(paper_cut_to_references, researcher_surname);
    %Correction in case the surname of the researcher is mentioned also in
    %the abstract
    [~, mentions] = size(pos_surname);
    if(mentions>1)
        pos_surname = pos_surname(1,mentions);
    end
    
    pos_others = strfind(paper_cut_to_references,others);
    %Correction in case the 'other' field of the researcher is mentioned
    %also in the abstract
    [~, mentions] = size(pos_others);
    if(mentions>1)
        pos_others = pos_others(1,mentions);
    end
    
    pos_paper_name = strfind(paper_cut_to_references, paper_name);
    %Correction in case the paper's name of the researcher is mentioned
    %also in the abstract
    [~, mentions] = size(pos_paper_name);
    if(mentions>1)
        pos_paper_name = pos_paper_name(1,mentions);
    end
    
    pos_valid = 0;
    error = 0;
    
    %Selects one of the found valid positions for the reference text 
    if(pos_surname ~= 0)
     pos_valid = pos_surname;
    elseif (size(pos_others) ~= 0)
     pos_valid = pos_others;
    elseif (size(pos_paper_name) ~= 0)
     pos_valid = pos_paper_name;
    end

    %If there actually isn't a valid position for the reference, the
    %function returns error = 1 
    if(pos_valid == 0)
     error = 1;
    end
    
    if(error == 0)
        %Algorithm to find out the reference number, taking into account that
        %the references always appears like the IEEE standard (in between [])
        pos_right = pos_valid;
        char = paper_cut_to_references_char(pos_right);

        while(char ~= ']')
         pos_right = pos_right-1;
         char = paper_cut_to_references_char(pos_right);
        end
        pos_left= pos_right;
        while(char ~= '[')
         pos_left = pos_left-1;
         char = paper_cut_to_references_char(pos_left);
        end

        reference_number = paper_cut_to_references_char(pos_left:pos_right);

        %Once we have the reference number, the position of all the citations
        %is found, taking into account that the last match will be the one for
        %the reference
        pos_references = strfind(paper_without_references, reference_number);
        [~, num_citations] = size(pos_references);
        for i = 1:num_citations
            citations(1,i) = {''};
        end
        %The citations are cutted down in order to analyse them separately. In
        %order to cut the hole citation, a symmetric number of characters are
        %selected to the left and to the right
        for i=1:num_citations
         pos1 = pos_references(1,i)-cut_chars;
         pos2 = pos_references(1,i)+cut_chars;
         citations(1,num_citations) = {paper_without_references_char(pos1:pos2)};
        end
    end
end



