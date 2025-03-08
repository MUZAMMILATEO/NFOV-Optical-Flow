function [] = errorplot(X,Y,curve_thickness,axis_thickness,xlabel0,ylabel0,labelsize,mark_size,xlim0,ylim0)
p = plot(X,Y,'b-d','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[1 0.3 0.01],'MarkerSize',mark_size,'LineWidth',curve_thickness)
hold on
xlim(xlim0);
ylim(ylim0);
xlabel(xlabel0,'FontSize',labelsize);
ylabel(ylabel0,'FontSize',labelsize);
set(gca,'xtick',0:0.1:1.2)
set(gca,'LineWidth',axis_thickness)

end

