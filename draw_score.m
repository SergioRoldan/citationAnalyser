function draw_score(paper_score,axes)
    % parametres
    percent = paper_score;
    temps = 1.5;%segons
    num_steps = 500;
    delta = temps/num_steps;
    direccio = 1; %(1 horari, -1 antihorari)
    angle_inicial=90;
    t = linspace(0,direccio * 2*pi * percent / 100, num_steps);

    %figure
    for i = 1:num_steps
        plot(sin(t(1:i)+2*pi/360*angle_inicial-pi/2)...
            ,cos(t(1:i)+2*pi/360*angle_inicial-pi/2),'LineWidth',9, 'Color',[0.6 0.89 0.85], 'Parent',axes)
        set(axes,'Color', [0.94 0.94 0.94])
        set(axes,'visible','off');
        axes.XLim = [-1.3 1.3];
        axes.YLim = [-1.3 1.3];
        pause(delta)
    end
    hold on
    text(axes, 0 ,0, strcat(num2str(paper_score),'%'), 'Color',[0.6 0.89 0.85], 'FontSize', 36, 'HorizontalAlignment', 'center', 'FontName', 'Apple Symbols')
    
end