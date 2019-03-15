function [pd1,pd2,pd3,pd4,pd5] = createFit(X_sec_mean,filename)
%CREATEFIT    Create plot of datasets and fits
%   [PD1,PD2,PD3,PD4,PD5] = CREATEFIT(X_SEC_MEAN)
%   Creates a plot, similar to the plot in the main distribution fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with dfittool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  5
%
%   See also FITDIST.

% This function was automatically generated on 20-Feb-2019 15:22:00

% Output fitted probablility distributions: PD1,PD2,PD3,PD4,PD5

% Data from dataset "X_sec_mean data":
%    Y = X_sec_mean

% Force all inputs to be column vectors
X_sec_mean = X_sec_mean(:);

% Prepare figure
%clf;
%hold on;
LegHandles = []; LegText = {};


figure1 = figure('Renderer', 'painters', 'Position', [50 50 1600 900]);
 
% Create axes
axes1 = axes('Parent',figure1);
set(axes1, 'YScale', 'log')
hold(axes1,'on');

% --- Plot data originally in dataset "X_sec_mean data"
[CdfY,CdfX] = ecdf(X_sec_mean,'Function','survivor');  % compute empirical function
hLine = stairs(CdfX,CdfY,'Color',[0 0 0],'Marker','diamond', 'MarkerSize',10);
xlabel('$\Delta$RTT (s)','Interpreter','latex');
ylabel('CCDF')
LegHandles(end+1) = hLine;
LegText{end+1} = 'Observations';

set(axes1, 'YLim',[min(CdfY(CdfY>min(CdfY))) max(CdfY)]);
set(axes1, 'XLim',[min(CdfX) max(CdfX(CdfY>min(CdfY)))]);


% Create grid where function will be computed
XLim = get(gca,'XLim');
XLim = XLim + [-1 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);


% --- Create fit "Normal"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd1 = ProbDistUnivParam('normal',[ 0.003056960090408, 0.00536611733219])
pd1 = fitdist(X_sec_mean, 'normal');
YPlot = cdf(pd1,XGrid);
YPlot = 1 - YPlot;
hLine = plot(XGrid,YPlot,'LineStyle',':','Color',[1 0 0], 'LineWidth',2,...
    'Marker','none', 'MarkerSize',10);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Normal';

% --- Create fit "Lognormal"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd2 = ProbDistUnivParam('lognormal',[ -6.083580418897, 0.5765888156189])
pd2 = fitdist(X_sec_mean, 'lognormal');
YPlot = cdf(pd2,XGrid);
YPlot = 1 - YPlot;
hLine = plot(XGrid,YPlot,'Marker','v','LineStyle','--', 'Color',[0 0 1], 'LineWidth',2,...
     'MarkerSize',10);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Lognormal';

% --- Create fit "GEV"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd3 = ProbDistUnivParam('generalized extreme value',[ 0.3285113015899, 0.0008146475751415, 0.00183212997395])
pd3 = fitdist(X_sec_mean, 'generalized extreme value');
YPlot = cdf(pd3,XGrid);
YPlot = 1 - YPlot;
hLine = plot(XGrid,YPlot,'Marker','^','Color',[0 1 0], 'MarkerSize',10);
LegHandles(end+1) = hLine;
LegText{end+1} = 'GEV';

% --- Create fit "Burr"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd4 = ProbDistUnivParam('burr',[ 0.001726609738647, 4.956128999034, 0.5004341218462])
pd4 = fitdist(X_sec_mean, 'burr');
YPlot = cdf(pd4,XGrid);
YPlot = 1 - YPlot;
hLine = plot(XGrid,YPlot,'LineStyle','-.',...
 'Color',[0 0.447058826684952 0.74117648601532], 'LineWidth',2,...
    'Marker','none', 'MarkerSize',10);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Burr';

% --- Create fit "fit 5"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd5 = ProbDistUnivParam('stable',[ 1.377901701809, 0.9999999999998, 0.0005496977822915, 0.001968351662108])
pd5 = fitdist(X_sec_mean, 'stable');
YPlot = cdf(pd5,XGrid);
YPlot = 1 - YPlot;
hLine = plot(XGrid,YPlot,'Color',[1 0 1],...
    'LineStyle','--', 'Color',[0.501960813999176 0.501960813999176 0.501960813999176], 'LineWidth',2,...
    'Marker','none', 'MarkerSize',10);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Stable';


% Create multiple lines using matrix input to semilogy
% semilogy1 = semilogy(X2,YMatrix1,'LineWidth',2,'Parent',axes1);
% set(semilogy1(1),'DisplayName','Normal','LineStyle',':','Color',[1 0 0]);
% set(semilogy1(2),'DisplayName','Lognormal','Marker','v','LineStyle','--',...
% 'Color',[0 0 1]);
% set(semilogy1(3),'DisplayName','GEV','Marker','^','Color',[0 1 0]);
% set(semilogy1(4),'DisplayName');




set(axes1,'FontName','Times New Roman','FontSize',30,'XGrid','on','YGrid',...
'on','YMinorTick','on','YScale','log','XScale','log');

% Adjust figure
box on;
hold off;

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 30, 'Location', 'southwest');

set(hLegend,'Interpreter','none');

saveas(figure1,filename,'epsc')

