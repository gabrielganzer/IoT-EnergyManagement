function digitizer(action,varargin)

% DIGITIZER digitize a scanned or downloaded linear graph. 
% 	Digitzer operates as a GUI utility, that does not require any input
% 	arguments. By starting the GUI, an empty figure appears with three 
%       menu contols: Image, Input, Preferences
%
% 	Image: 
%	- Load an image
%	  An image will be asked for the is compatible with the 
%	  imread command.
% 
% 	- Calibrate the image
%	  You can choose 2 points on the graph. 
%	  The arrow keys on the keyboard will move the last entered point with small steps to accurately place your calibration points. 
%	  The input is cyclic for two points i.e. the third input will replace the first input etc.
%	  To finish input press the 2nd mouse button, after which the numeric values of the two points can be entered. 
%	  While calibrating, the menus are enabled.
%
%	- Reset image
%	  Will delete any calibration and input data, apart from data that has already been saved (See section save data).
%
%   - Clearimage
%	  Will delete image, calibration and remove digitized data%	  
%
% 	Input:
%	- Start input
%	  Mouse button 1: Add a new point
%	  Mouse button 3: Removes the last point
%	  Mouse button 2: Ends input
%	  You can start and stop input at will, for example to save, recalibrate or change the accuracy.
%
%	- Save input
%	  The digitized data is stored in an ascii "graph_file_name.txt"
%
%	  Example of output:
%     	  sample.jpg
%	   1.00000000,168.20000000
%	  31.00000000,241.20000000
%	  62.00000000,297.60000000
%	  93.00000000,344.70000000
% 	 125.00000000,354.10000000
%     	 152.00000000,351.80000000
%     	 181.00000000,394.10000000
%     	 216.00000000,372.90000000
%     	 243.00000000,521.17650000
%     	 276.00000000,568.23530000 
%
%	- Preferences:
%	  Allows you to change accuracy, key steps and visualization.
% 	  Note that colors have to be written conform the matlab expressions i.e.
%	  black,red,k,r.
%	
% 	  Input accuracy: The input will snap to the rounded value as specified in
%	  the preferences.
%	  During input, arrow keys will move the last point in steps according to the scale of
%	  the graph as defined in the preferences.
%
%  
% The digitzer requires round2 
% 
% Update Feb 18th 2011 : 
% Replaced imshow for image command
% GUI will ask to check preferences after image calibration

if nargin==0
    action = 'Initialize';    
else
    
end

feval(action,varargin{:});

return

function Initialize

try
    editingtool('Off')
end

% define figure position and size
screensize = get(0,'ScreenSize');
figpos = screensize*0.33 + [0.33*screensize(3),0.33*screensize(4),0,0];

ud.h.fig = figure('Name','Graph digitizer', ...
    'NumberTitle','off','HandleVisibility','on','Position',figpos, ...
    'BusyAction','Queue','Interruptible','off', 'Color', [1,1,1],...
    'NextPlot','Add','DoubleBuffer','On','IntegerHandle','off',...
    'Menubar','none','Visible','on');

% menus   
ud.h.Image = uimenu('Label','Image');
ud.h.Input = uimenu('Label','Digitization');
ud.h.Preference = uimenu('Label','Preferences');

% menu 1: image
ud.h.Image1 = uimenu(ud.h.Image,'Label','Load image',...
        'Callback','digitizer(''load_image'')');
ud.h.Image2 = uimenu(ud.h.Image,'Label','Calibrate image',...
        'Callback','digitizer(''calibrate_image'')',...
        'enable','off');
ud.h.Image3 = uimenu(ud.h.Image,'Label','Reset image',...
        'Callback','digitizer(''reset_image'')',...
        'enable','off');
ud.h.Image4 = uimenu(ud.h.Image,'Label','Remove image',...
        'Callback','digitizer(''clear_image'')',...
        'enable','off'); 

% menu 2: Input
ud.h.Input1 = uimenu(ud.h.Input,'Label','Start input image',...
        'Callback','digitizer(''click_image'')',...
        'enable','off');
ud.h.Input2 = uimenu(ud.h.Input,'Label','Save digitized data to ascii',...
        'Callback','digitizer(''write_data'')',...
        'enable','off'); 
ud.h.Input3 = uimenu(ud.h.Input,'Label','Plot digitized data',...
        'Callback','digitizer(''plot_data'')',...
        'enable','off');
ud.h.Input4 = uimenu(ud.h.Input,'Label','Remove digitized data',...
        'Callback','digitizer(''clear_data'')',...
        'enable','off'); 

% menu 3: preferences
ud.h.Preference1 = uimenu(ud.h.Preference,'Label','Preferences',...
        'Callback','digitizer(''prefs'')',...
        'enable','on'); 

% axes 1
ud.h.ax1 = axes;
set(ud.h.ax1,'Position',[0.01 0.01 0.89 0.89]);
set(ud.h.ax1,'Visible','off');

% axes 2
ud.h.ax2 = axes;
set(ud.h.ax2,'Position',[0.8 0.9 0.19 0.09]);
set(ud.h.ax2,'Visible','off');

% defaults
ud.data = [];
ud.x = [];
ud.y= [];
ud.preference = {'0','0','1','1','black','red','2','s','data'};
ud.decimalx = str2double(cell2mat(ud.preference(1)));
ud.decimaly = str2double(cell2mat(ud.preference(2)));
ud.stepx = str2double(cell2mat(ud.preference(3)));
ud.stepy = str2double(cell2mat(ud.preference(4)));
ud.linecolor = char(ud.preference(5));
ud.facecolor = char(ud.preference(6));
ud.linewidth = str2double(ud.preference(7));
ud.marker = char(ud.preference(8));
ud.h.digitized = plot(ud.h.ax1,0,0);
set(ud.h.ax1,'Visible','off');

% set userdata
set(ud.h.fig,'UserData',ud);
        
function load_image

% get userdata
ud = get(gcf,'UserData');

% reset digitizer data
ud.i = 1; 
if ~isempty(ud.x)
    ud.x = [];
    ud.y = [];
end

if isfield(ud,'calibration')
    ud = rmfield(ud,'calibration');    
end

% load image and show in axis
[ud.filename ud.path] =uigetfile('*.*','Select image file');

% load and set all
if ~isequal(ud.filename,0)
    % load image
    ud.image = imread([ud.path ud.filename]);
    
    % show image
    delete(ud.h.ax1);
    % axes 1
    ud.h.ax1 = axes;
    set(ud.h.ax1,'Position',[0.01 0.01 0.89 0.89]);
    set(ud.h.fig,'CurrentAxes',ud.h.ax1);
    image(ud.image); hold on;
    
    % default digitized plot
    ud.h.digitized = plot(ud.h.ax1,0,0);
    set(ud.h.digitized,'Color',ud.linecolor);
    set(ud.h.digitized,'LineWidth',ud.linewidth);
    set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
    set(ud.h.digitized,'Marker',ud.marker);
    
    % enable/disable menus
    set(ud.h.Image2,'Enable','on');
    set(ud.h.Input1,'Enable','off');
    set(ud.h.Input2,'Enable','off');
    set(ud.h.Input3,'Enable','off');
    set(ud.h.Input4,'Enable','off');
    set(ud.h.Image3,'Enable','off');
    set(ud.h.Image4,'Enable','on');
    set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename ' : image loaded']);

    % set userdata
    set(ud.h.fig,'UserData',ud);
end

function calibrate_image

%% Get userdata
ud = get(gcf,'UserData');
set(ud.h.Image,'Enable','off');
ud.h.cal(1)=scatter(0,0,'r.');
ud.h.cal(2)=scatter(0,0,'r.');
x=[]; y = [];

%% Input
button = 1; i = 2; clrs='bg';
while button ~= 2
    [tx,ty,button] = ginput(1); 

    switch button
        case 1
            % cycle i
            if i == 1
                i = 2;
            else
                i = 1;
            end
            
            % set data
            x(i) = tx;
            y(i) = ty;
            
            % plot
            delete(ud.h.cal(i));
            ud.h.cal(i) = scatter(ud.h.ax1,x(i),y(i),clrs(i),'filled');
        case 2
            if size(x,2) == 1 ; button = 1; end
        case 28
            % correct x
            x(i) = x(i)-0.5;
            
            % plot
            delete(ud.h.cal(i));
            ud.h.cal(i) = scatter(ud.h.ax1,x(i),y(i),clrs(i),'filled');
        case 29
            % correct x
            x(i) = x(i)+0.5;
            
            % plot
            delete(ud.h.cal(i));
            ud.h.cal(i) = scatter(ud.h.ax1,x(i),y(i),clrs(i),'filled');
        case 30
            % correct y
            y(i) = y(i)-0.5;
            
            % plot
            delete(ud.h.cal(i));
            ud.h.cal(i) = scatter(ud.h.ax1,x(i),y(i),clrs(i),'filled');
        case 31
            % correct y
            y(i) = y(i)+0.5;
            
            % plot
            delete(ud.h.cal(i));
            ud.h.cal(i) = scatter(ud.h.ax1,x(i),y(i),clrs(i),'filled');
    end           
end

[values] = inputdlg({'x value blue','y value blue','x value green','y value green'},'enter value',[1,35; 1,35; 1,35; 1,35],{num2str(x(1)) , num2str(y(1)) , num2str(x(2)) , num2str(y(2))});
[factor] = inputdlg({'y value conversion factor'},'correction factor',[1,35],{'1'});

%% Process input
if ~isempty(values)
    if x(1) < x(2) && y(1) > y(2)
        ud.calibration(1,:)=[x(1) y(1) str2double(cell2mat(values(1))) str2double(cell2mat(values(2)))];
        ud.calibration(2,:)=[x(2) y(2) str2double(cell2mat(values(3))) str2double(cell2mat(values(4)))];
    elseif x(1) > x(2) && y(1) < y(2)
        ud.calibration(2,:)=[x(2) y(2) str2double(cell2mat(values(3))) str2double(cell2mat(values(4)))];
        ud.calibration(1,:)=[x(1) y(1) str2double(cell2mat(values(1))) str2double(cell2mat(values(2)))];
    elseif x(1) > x(2) && y(1) > y(2)
        ud.calibration(1,:)=[x(2) y(1) str2double(cell2mat(values(3))) str2double(cell2mat(values(2)))];
        ud.calibration(2,:)=[x(1) y(2) str2double(cell2mat(values(1))) str2double(cell2mat(values(4)))];
    elseif x(1) < x(2) && y(1) < y(2)
        ud.calibration(1,:)=[x(1) y(2) str2double(cell2mat(values(1))) str2double(cell2mat(values(4)))];
        ud.calibration(2,:)=[x(2) y(1) str2double(cell2mat(values(3))) str2double(cell2mat(values(2)))];
    end
                
    delete(ud.h.cal(1)); 
    delete(ud.h.cal(2));

    % Update Plot
    if ~isempty(ud.data)
        % plot on image
        delete(ud.h.digitized);            
        ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
        set(ud.h.digitized,'Color',ud.linecolor);
        set(ud.h.digitized,'LineWidth',ud.linewidth);
        set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
        set(ud.h.digitized,'Marker',ud.marker);            

        % plot on graph
        ud.data=[]; set(ud.h.ax2,'Visible','on');
        ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
        ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
        cla(ud.h.ax2);
        h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2));
        set(h,'Color',ud.linecolor);
        set(h,'LineWidth',ud.linewidth);
        set(h,'MarkerFaceColor',ud.facecolor);
        set(h,'Marker',ud.marker);
        grid(ud.h.ax2,'on');
        set(ud.h.ax2,'YLim',[min(ud.calibration(:,4)) max(ud.calibration(:,4))]);
        set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

    end

    set(ud.h.Image,'Enable','on');
    set(ud.h.Image2,'Enable','on');
    set(ud.h.Input1,'Enable','on');    
    set(ud.h.Input2,'Enable','on');
    set(ud.h.Input3,'Enable','on');
    set(ud.h.Input4,'Enable','on');
    set(ud.h.Image3,'Enable','on');
    set(ud.h.Image4,'Enable','on');
    set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) ']);
    
else
    %% Delete if no valid calibration data is given
    set(ud.h.Image,'Enable','on');
    delete(ud.h.cal(1)); 
    delete(ud.h.cal(2));
end

if ~isempty(factor)
    ud.factor = str2double(factor);
else
    ud.factor = 1;
end
       
% set userdata
set(ud.h.fig,'UserData',ud);

digitizer('prefs');

function reset_image
% get userdata
ud = get(gcf,'UserData');

% reset digitizer data
ud.i = 1; 
ud.x = [];
ud.y = [];
ud.data=[];

if isfield(ud,'calibration')
    ud = rmfield(ud,'calibration');    
end

delete(ud.h.digitized);
ud.h.digitized = plot(ud.h.ax1,0,0);
set(ud.h.Image1,'Enable','on');
set(ud.h.Image2,'Enable','on');
set(ud.h.Input1,'Enable','off');
set(ud.h.Input2,'Enable','off');
set(ud.h.Input3,'Enable','off');
set(ud.h.Input4,'Enable','off');
set(ud.h.Image3,'Enable','off');
set(ud.h.Image4,'Enable','on');
set(ud.h.ax2,'Visible','off'); cla(ud.h.ax2);
set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename ' : image resetted']);

% set userdata
set(ud.h.fig,'UserData',ud);

function clear_image

% get userdata
ud = get(gcf,'UserData');

% reset digitizer data
ud.i = 1; 
ud.x = [];
ud.y = [];
ud.data=[];

if isfield(ud,'calibration')
    ud = rmfield(ud,'calibration');    
end

delete(ud.h.digitized);
ud.h.digitized = plot(ud.h.ax1,0,0);
set(ud.h.Image1,'Enable','on');
set(ud.h.Image2,'Enable','off');
set(ud.h.Input1,'Enable','off');
set(ud.h.Input2,'Enable','off');
set(ud.h.Input3,'Enable','off');
set(ud.h.Input4,'Enable','off');
set(ud.h.Image3,'Enable','off');
set(ud.h.Image4,'Enable','off');
set(ud.h.ax2,'Visible','off'); cla(ud.h.ax2);
set(ud.h.fig,'Name','Graph digitizer');

ud = rmfield(ud,'image');
delete(ud.h.ax1);
delete(ud.h.ax2)

% axes 1
ud.h.ax1 = axes;
set(ud.h.ax1,'Position',[0.01 0.01 0.89 0.89]);
set(ud.h.ax1,'Visible','off');

% axes 2
ud.h.ax2 = axes;
set(ud.h.ax2,'Position',[0.8 0.9 0.19 0.09]);
set(ud.h.ax2,'Visible','off');

% set userdata
set(ud.h.fig,'UserData',ud);

function click_image

% get userdata
ud = get(gcf,'UserData');

% disable menus
set(ud.h.Image,'Enable','off');
set(ud.h.Input,'Enable','off');
set(ud.h.Preference,'Enable','off');

% start input
button = 1; ud.step=0.1;
while button ~= 2
    [ud.x(ud.i),ud.y(ud.i),button] = ginput(1);
        
    switch button
        case 1
            % compute 
            tx = round2((ud.x(ud.i) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1)))+ud.calibration(1,3),ud.decimalx);
            ty = round2(-(ud.y(ud.i)- ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2)))+ud.calibration(1,4),ud.decimaly);
            ud.x(ud.i) = ud.calibration(1,1) + ((tx-ud.calibration(1,3)) / ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))));
            ud.y(ud.i) = ud.calibration(1,2) - ((ty-ud.calibration(1,4)) / ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))));
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            ud.data=[]; set(ud.h.ax2,'Visible','on');
            ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
            ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
            cla(ud.h.ax2);
            h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
            set(h,'Color',ud.linecolor);
            set(h,'LineWidth',ud.linewidth);
            set(h,'MarkerFaceColor',ud.facecolor);
            set(h,'Marker',ud.marker);
            grid(ud.h.ax2,'on');
            set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
            set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

            % command title
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : ' num2str(tx) ' , ' num2str(ty) ' (' num2str(length(ud.x)) ')']);
            
            % set next step
            ud.i = ud.i+1;
            
            % update workspace
            assignin('base','data',ud.data);
            
        case 2
            % stop data input
            ud.x = ud.x(1:end-1);
            ud.y = ud.y(1:end-1);
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            if ~isempty(ud.x)
                ud.data=[]; set(ud.h.ax2,'Visible','on');
                ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
                ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
                cla(ud.h.ax2);
                h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
                set(h,'Color',ud.linecolor);
                set(h,'LineWidth',ud.linewidth);
                set(h,'MarkerFaceColor',ud.facecolor);
                set(h,'Marker',ud.marker);
                grid(ud.h.ax2,'on');
                set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
                set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

            end

            % set command title            
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : stopped input (' num2str(length(ud.x)) ')']);
            
            % update workspace
            assignin('base','data',ud.data);
            
        case 3
            if length(ud.x) <= 2
                % clear data
                ud.x = [];
                ud.y = [];
                ud.i = 1;
                
                % empty plots
                delete(ud.h.digitized);
                ud.h.digitized = plot(ud.h.ax1,0,0);
                set(gcf,'CurrentAxes',ud.h.ax2); cla;
                set(ud.h.ax2,'Visible','off');
                
                % show command title
                set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : deleted last entry (0)']);
                
            else 
                ud.x = ud.x(1:end-2);
                ud.y = ud.y(1:end-2);
                
                % plot on image
                delete(ud.h.digitized);            
                ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
                set(ud.h.digitized,'Color',ud.linecolor);
                set(ud.h.digitized,'LineWidth',ud.linewidth);
                set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
                set(ud.h.digitized,'Marker',ud.marker);            

                % plot on graph
                ud.data=[]; set(ud.h.ax2,'Visible','on');
                ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
                ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
                cla(ud.h.ax2);
                h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
                set(h,'Color',ud.linecolor);
                set(h,'LineWidth',ud.linewidth);
                set(h,'MarkerFaceColor',ud.facecolor);
                set(h,'Marker',ud.marker);
                grid(ud.h.ax2,'on');
                set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
                set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);
                
                % set next input
                ud.i = ud.i-1;    
                
                % update workspace
                assignin('base','data',ud.data);
            end
            
        case 28
            % skip xy of button pres 
            ud.x = ud.x(1:end-1);
            ud.y = ud.y(1:end-1);
            
            % apply step and calculate x
            tx = (ud.x(ud.i-1) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1)))+ud.calibration(1,3)-ud.stepx;
            ud.x(ud.i-1) = ud.calibration(1,1) + ((tx-ud.calibration(1,3)) / ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))));
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            ud.data=[]; set(ud.h.ax2,'Visible','on');
            ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
            ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
            cla(ud.h.ax2);
            h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
            set(h,'Color',ud.linecolor);
            set(h,'LineWidth',ud.linewidth);
            set(h,'MarkerFaceColor',ud.facecolor);
            set(h,'Marker',ud.marker);
            grid(ud.h.ax2,'on');
            set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
            set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

            % set command title
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : ' num2str(ud.data(end,1)) ' , ' num2str(ud.data(end,2)) ' (' num2str(length(ud.x)) ')']);            
            
            % update workspace
            assignin('base','data',ud.data);
            
        case 29
            % skip xy of button pres 
            ud.x = ud.x(1:end-1);
            ud.y = ud.y(1:end-1);
            
            % apply step and calculate x
            tx = (ud.x(ud.i-1) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1)))+ud.calibration(1,3)+ud.stepx;
            ud.x(ud.i-1) = ud.calibration(1,1) + ((tx-ud.calibration(1,3)) / ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))));
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            ud.data=[]; set(ud.h.ax2,'Visible','on');
            ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
            ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
            cla(ud.h.ax2);
            h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
            set(h,'Color',ud.linecolor);
            set(h,'LineWidth',ud.linewidth);
            set(h,'MarkerFaceColor',ud.facecolor);
            set(h,'Marker',ud.marker);
            grid(ud.h.ax2,'on');
            set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
            set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

            % set command title
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : ' num2str(ud.data(end,1)) ' , ' num2str(ud.data(end,2)) ' (' num2str(length(ud.x)) ')']);
            
            % update workspace
            assignin('base','data',ud.data);
            
        case 30
            % skip xy of button pres 
            ud.x = ud.x(1:end-1);
            ud.y;
            ud.y = ud.y(1:end-1);
            
            % apply step and calculate y
            ty = -(ud.y(ud.i-1)- ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2)))+ud.calibration(1,4)+ud.stepy;
            ud.y(ud.i-1) = ud.calibration(1,2) - ((ty-ud.calibration(1,4)) / ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))));
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            ud.data=[]; set(ud.h.ax2,'Visible','on');
            ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
            ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
            cla(ud.h.ax2);
            h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
            set(h,'Color',ud.linecolor);
            set(h,'LineWidth',ud.linewidth);
            set(h,'MarkerFaceColor',ud.facecolor);
            set(h,'Marker',ud.marker);
            grid(ud.h.ax2,'on');
            set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
            set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);

            % set command title
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : ' num2str(ud.data(end,1)) ' , ' num2str(ud.data(end,2)) ' (' num2str(length(ud.x)) ')']);
            
            % update workspace
            assignin('base','data',ud.data);
            
        case 31
            % skip xy of button pres 
            ud.x = ud.x(1:end-1);
            ud.y = ud.y(1:end-1);
            
            % apply step and calculate y
            ty = -(ud.y(ud.i-1)- ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2)))+ud.calibration(1,4)-ud.stepy;
            ud.y(ud.i-1) = ud.calibration(1,2) - ((ty-ud.calibration(1,4)) / ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))));
            
            % plot on image
            delete(ud.h.digitized);            
            ud.h.digitized = plot(ud.h.ax1,ud.x(:),ud.y(:));
            set(ud.h.digitized,'Color',ud.linecolor);
            set(ud.h.digitized,'LineWidth',ud.linewidth);
            set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
            set(ud.h.digitized,'Marker',ud.marker);            
            
            % plot on graph
            ud.data=[]; set(ud.h.ax2,'Visible','on');
            ud.data(:,1) = ((ud.x(:) - ud.calibration(1,1)) * ((ud.calibration(2,3)-ud.calibration(1,3))/(ud.calibration(2,1)-ud.calibration(1,1))))+ud.calibration(1,3);
            ud.data(:,2) = (-(ud.y(:) - ud.calibration(1,2)) * ((ud.calibration(2,4)-ud.calibration(1,4))/-(ud.calibration(2,2)-ud.calibration(1,2))))+ud.calibration(1,4);
            cla(ud.h.ax2);
            h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2) * ud.factor);
            set(h,'Color',ud.linecolor);
            set(h,'LineWidth',ud.linewidth);
            set(h,'MarkerFaceColor',ud.facecolor);
            set(h,'Marker',ud.marker);
            grid(ud.h.ax2,'on');
            set(ud.h.ax2,'YLim',[min(ud.calibration(:,4) * ud.factor) max(ud.calibration(:,4) * ud.factor)]);
            set(ud.h.ax2,'XLim',[min(ud.calibration(:,3)) max(ud.calibration(:,3))]);
            
            % set command title
            set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : ' num2str(ud.data(end,1)) ' , ' num2str(ud.data(end,2)) ' (' num2str(length(ud.x)) ')']);
            
            % update workspace
            assignin('base',char(ud.preference(9)),ud.data);
    end

    % set views
    if isempty(ud.x)
        set(ud.h.Input2,'Enable','off');
    else
        set(ud.h.Input2,'Enable','on');
    end
end

% set userdata
set(ud.h.fig,'UserData',ud);

% enable menus 
set(ud.h.Image,'Enable','on');
set(ud.h.Input,'Enable','on');
set(ud.h.Preference,'Enable','on');

function write_data
% get userdata
ud = get(gcf,'UserData');

% save data
[filename,pathname] = uiputfile('*.txt','Output filename',ud.path);
fid=fopen([pathname filename],'w');
fprintf(fid,'%s\n',[ud.filename]);
fprintf(fid,'%12.8f,%12.8f\n',ud.data');
fclose(fid);

% set userdata
set(ud.h.fig,'UserData',ud);

set(ud.h.fig,'Name',['Graph digitizer - ' ud.filename '(c) : wrote ' num2str(length(ud.x)) ' entries to ' filename '.txt']);

function plot_data

% get userdata
ud = get(gcf,'UserData');

screensize = get(0,'ScreenSize');
figpos = screensize*0.4 + [0.1*screensize(3),0.01*screensize(4),0,0];

figure('Name',['Graph digitizer - ' ud.filename '(c) : Digitized data'], ...
    'NumberTitle','off','HandleVisibility','on','Position',figpos, ...
    'BusyAction','Queue','Interruptible','off', 'Color', [1,1,1],...
    'NextPlot','Add','DoubleBuffer','On','IntegerHandle','off',...
    'Menubar','none','Visible','on');

plot(ud.data(:,1),ud.data(:,2),'ko-','MarkerFaceColor','r','LineWidth',2);
grid on;

function clear_data

switch questdlg('Clear digitized data','Are you sure you want to remove the digitized data','Yes','No','No');
    case 'Yes'
        % get userdata
        ud = get(gcf,'UserData');
        ud.i = 1; 
        ud.x = [];
        ud.y = [];
        ud.data=[];
        delete(ud.h.digitized);
        ud.h.digitized = plot(ud.h.ax1,0,0);
        % set userdata
        set(ud.h.fig,'UserData',ud);
end

function prefs

% get userdata
ud = get(gcf,'UserData');

[ud.preference] = inputdlg({'x input accuracy (decimals)','y input accuracy (decimals)','key step size x','key step size y','line color','facecolor','linewidth','marker symbol (+ o * . x s d ^ v < > p h)','Workspace output variable'},'Preferences',[1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40; 1,40],ud.preference);

if ~isempty(ud.preference)
    ud.decimalx = str2double(cell2mat(ud.preference(1)));
    ud.decimaly = str2double(cell2mat(ud.preference(2)));
    ud.stepx = str2double(cell2mat(ud.preference(3)));
    ud.stepy = str2double(cell2mat(ud.preference(4)));
    ud.linecolor = char(ud.preference(5));
    ud.facecolor = char(ud.preference(6));
    ud.linewidth = str2double(ud.preference(7));
    ud.marker = char(ud.preference(8));

    % update styling of image plot
    set(ud.h.digitized,'Color',ud.linecolor);
    set(ud.h.digitized,'LineWidth',ud.linewidth);
    set(ud.h.digitized,'MarkerFaceColor',ud.facecolor);
    set(ud.h.digitized,'Marker',ud.marker);

    % reset the graph
    if ~isempty(ud.x)
        cla(ud.h.ax2);
        h = plot(ud.h.ax2,ud.data(:,1),ud.data(:,2));
        set(h,'Color',ud.linecolor);
        set(h,'LineWidth',ud.linewidth);
        set(h,'MarkerFaceColor',ud.facecolor);
        set(h,'Marker',ud.marker);
    end

    % set userdata
    set(ud.h.fig,'UserData',ud);
end




