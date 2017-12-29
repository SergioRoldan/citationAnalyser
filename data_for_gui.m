function [total_citations_all, positive_citations_all, negative_citations_all, lazy_citations_all, citations_list, num_papers, paper_score] = data_for_gui(paper_selection)
    researcher_surname = 'Bragos';
    others = 'Bragós';
    papers_repository = papers_repository_generator();
    [~,long] = size(papers_repository);
    for i=1:long
        temp = papers_repository(i).num;
        if(temp == paper_selection)
            paper_num = i;
        end
    end
    paper_name = papers_repository(paper_num).name;
    paper_directory = papers_repository(paper_num).directory;
    temp=dir([paper_directory '/*.pdf']);
    num_papers=size(temp,1);
    citations_list = papers_repository(paper_num).string;
    total_citations_all = 0;
    positive_citations_all = 0;
    negative_citations_all = 0;
    lazy_citations_all = 0;
    total_citations= zeros(1,num_papers);
    positive_citations= zeros(1,num_papers);
    negative_citations= zeros(1,num_papers);
    lazy_citations = zeros(1,num_papers);
    for paper_citating = 1:num_papers
        paper_citating_directory = strcat(paper_directory,num2str(paper_citating),'.pdf');
        [total_citations(1,i), positive_citations(1,i), negative_citations(1,i), lazy_citations(1,i)] = valoration(researcher_surname, paper_name, others, paper_citating_directory);
        total_citations_all = total_citations_all + total_citations(1,i);
        positive_citations_all = positive_citations_all + positive_citations(1,i);
        negative_citations_all = negative_citations_all + negative_citations(1,i);
        lazy_citations_all = lazy_citations_all + lazy_citations(1,i);
    end
    
    for i = 1:num_papers
        citations_list{2,i} = total_citations(1,i);
    end
    for i = 1:num_papers
        citations_list{3,i} = positive_citations(1,i);
    end
    for i = 1:num_papers
        citations_list{4,i} = negative_citations(1,i);
    end
    for i = 1:num_papers
        citations_list{5,i} = lazy_citations(1,i);
    end
    
    paper_score = (2*positive_citations_all + 0.8*lazy_citations_all - negative_citations_all)*100/total_citations_all;
    if(paper_score > 100)
        paper_score = 100;
    end
    
end