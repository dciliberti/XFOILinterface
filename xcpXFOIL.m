close all
clearvars
clc

%% Create a new instance of the XFOIL class, and set some properties
xf = XFOIL;
xf.KeepFiles = true; % Set it to true to keep all intermediate files created (Airfoil, Polars, ...)
xf.Visible = false;    % Set it to false to hide XFOIL plotting window

%% Create a NACA 5-series airfoil
xf.Airfoil =  Airfoil.createNACA4('2412',150);

%% Setup the action list

%Add five filtering steps to smooth the airfoil coordinates and help convergence
xf.addFiltering(5);

%Switch to OPER mode, and set Reynolds = 3E7, Mach = 0.1
% Set Reynolds = inf to run inviscid analysis
xf.addOperation(inf);

%Set maximum number of iterations
xf.addIter(100)

%Initializate the calculations
% xf.addAlpha(0,true);
xf.addCL(0,true);

%Create a new polar
xf.addPolarFile('Polar.txt');

% Calculate a sequence of angle of attack
% aseq = -4:1:10;
% xf.addAlpha(aseq);

%Another option is to keep all the CP curves, replace the previous line with this:
clseq = 1.5 * (1 - cosd(linspace(10,90,25)));
for cl = clseq
   xf.addCL(cl);
   xf.addActions(sprintf('CPWR cl_%.2f.txt',cl));
end

%Close the polar file
xf.addClosePolarFile;

%And finally add the action to quit XFOIL
xf.addQuit;

%% Now we're ready to run XFOIL
xf.run
disp('Running XFOIL, please wait...')

%% Wait up to 10 seconds for it to finish... 
%It is possible to run more than one XFOIL instance at the same time
finished = xf.wait(10); 

%% If successfull, read and plot the polar
if finished
    disp('XFOIL analysis finished.')

    % Read Cp data
    c = 0;
    CpData = zeros(160, numel(clseq));
    CpDataTable = cell(1,numel(clseq));
    for cl = clseq
        c = c + 1;
        CpDataTable{c} = readCpFile(['cl_', num2str(cl,'%.2f'), '.txt']);
        CpData(:,c) = CpDataTable{c}.Cp;
    end

    % Read polar data and get angle of attack from Cl
    PolarData = readPolarFile('Polar.txt');
    aseq = PolarData.alpha;

    % Find center of pressure
    x = CpDataTable{1}.x;   % x coordinates
    y = CpDataTable{1}.y;   % y coordinates
    xref = 0.0;             % x coordinate of moment reference point
    yref = 0.0;             % y coordinate of moment reference point
    Cl = zeros(numel(aseq),1);
    Cm = zeros(numel(aseq),1);
    for c = 1:length(aseq)
        alpha = aseq(c);
        dx = x*cosd(alpha) + y*sind(alpha);
        % dy = y*cosd(alpha) - x*sind(alpha);
        Cl(c) = trapz(dx,CpData(:,c));
        Cm(c) = trapz(x,-CpData(:,c).*(x-xref)) + trapz(y,-CpData(:,c).*(y-yref));
    end
    % coordinate of center of pressure w.r.t xref
    xcp = -Cm ./ Cl;

    figure
    plot(x,y,'k-')
    hold on
    quiver(xcp, zeros(numel(xcp),1), zeros(numel(xcp),1), Cl, 0)
    hold off
    axis equal
    xlim([-0.1, ceil(xcp(1)+0.1)]);
    title('Lift vector position')
    xlabel('x/c')

    figure
    tbl = table(aseq,Cl,Cm,xcp);
    tbl = renamevars(tbl, 'aseq', 'alpha');
    vars = {["Cl", "Cm"], "xcp"};
    s = stackedplot(tbl,vars,"GridVisible","on");
    s.XVariable = 'alpha';
    s.AxesProperties(2).YLimits = [0, ceil(max(xcp))]; 
else
    xf.kill;
end
