function [total_citations, positive_citations, negative_citations, lazy_citations] = valoration(researcher_surname, paper_name, others, paper_citating_directory)
    total_citations = 0; 
    positive_citations = 0;
    negative_citations = 0;
    lazy_citations = 0;
    [num_citations, citations, error] = reference_finder(researcher_surname, paper_name, others, paper_citating_directory);
    if(error == 1)
        num_citations = 0;
    end
    total_citations = num_citations;
    lazy_citations = 0;
    negative_citations = 0;
    positive_citations = 0;
    if(error == 0) 
        for i = 1:num_citations
            citation = citations{1,i};
            [valoration, ~] = citation_analysis(citation);

            if(valoration == 0)
                lazy_citations = lazy_citations + 1;
            elseif(valoration == 1)
                 negative_citations = negative_citations + 1;
            elseif(valoration == 2)
                    positive_citations = positive_citations + 1;
            end
            
        end
    end
                    
    end