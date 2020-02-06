function varargout = LineMapScan(varargin)
% LINEMAPSCAN MATLAB code for LineMapScan.fig
%      LINEMAPSCAN, by itself, creates a new LINEMAPSCAN or raises the existing
%      singleton*.
%
%      H = LINEMAPSCAN returns the handle to a new LINEMAPSCAN or the handle to
%      the existing singleton*.
%
%      LINEMAPSCAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEMAPSCAN.M with the given input arguments.
%
%      LINEMAPSCAN('Property','Value',...) creates a new LINEMAPSCAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LineMapScan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LineMapScan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LineMapScan

% Last Modified by GUIDE v2.5 05-Feb-2020 23:49:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LineMapScan_OpeningFcn, ...
                   'gui_OutputFcn',  @LineMapScan_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LineMapScan is made visible.
function LineMapScan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LineMapScan (see VARARGIN)

% Choose default command line output for LineMapScan
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Get the plotCorrObj from the main GUI (Manuvent_corr)
if ~isempty(findobj('Tag', 'Manuvent_corr'))
    MC_h = findobj('Tag', 'Manuvent_corr');
    MC_data = guidata(MC_h);
    MC_passed = get(MC_data.Line_scan, 'UserData');
    LineScanObj = MC_passed.LineScanObj;
    
    %Store useful information
    handles.Load_line.UserData.Avg_line = LineScanObj.Avg_line;
    handles.Load_line.UserData.Rec_rotated = LineScanObj.Rec_rotated;
    handles.Load_line.UserData.h_rec = LineScanObj.h_rec;
    handles.Load_line.UserData.filename = LineScanObj.filename;
    try
        handles.Load_line.UserData.Avg_noise = LineScanObj.Avg_noise;
        disp('Detected background noise signal!')
    catch
        warning('Did not specify background noise!');
    end
    
    clear MC_data MC_passed;

    %Show 2D line map
    Avg_line = LineScanObj.Avg_line;
    showLine2D(handles, Avg_line)
    
    %Report progress
    handles.Progress_report.String = 'Loaded LineScanObj from the main GUI!';
end
% UIWAIT makes LineMapScan wait for user response (see UIRESUME)
% uiwait(handles.LineMapScan);


function showLine2D(handles, Avg_line)
%Show 2D line map at the Line_2D axes

    %Specify current axis
    set(handles.LineMapScan,'CurrentAxes',handles.Line_2D)
    %Show 2D line map
    imagesc(handles.Line_2D, Avg_line'); colormap jet;
    colorbar(handles.Line_2D); 
    axis(handles.Line_2D, 'image');
    caxis(handles.Line_2D,[0, 0.3]);



% --- Outputs from this function are returned to the command line.
function varargout = LineMapScan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Smooth_checkbox.
function Smooth_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Smooth_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Smooth_checkbox
handles.Line_scan.UserData.SmoothFlag = hObject.Value;
switch hObject.Value
    case 1
        handles.Progress_report.String = 'Will do smoothing!';
    case 0
        handles.Progress_report.String = 'Will not do smoothing!';
        handles.Smooth_spatial.String = '1';
        handles.Smooth_temporal.String = '1';
end


function Smooth_spatial_Callback(hObject, eventdata, handles)
% hObject    handle to Smooth_spatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Smooth_spatial as text
%        str2double(get(hObject,'String')) returns contents of Smooth_spatial as a double


% --- Executes during object creation, after setting all properties.
function Smooth_spatial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Smooth_spatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Smooth_temporal_Callback(hObject, eventdata, handles)
% hObject    handle to Smooth_temporal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Smooth_temporal as text
%        str2double(get(hObject,'String')) returns contents of Smooth_temporal as a double



% --- Executes during object creation, after setting all properties.
function Smooth_temporal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Smooth_temporal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshold as text
%        str2double(get(hObject,'String')) returns contents of Threshold as a double


% --- Executes during object creation, after setting all properties.
function Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Use_default.
function Use_default_Callback(hObject, eventdata, handles)
% hObject    handle to Use_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Progress_report.String = 'Use default parameters!';

%Set/Display default parameters
handles.Smooth_spatial.String = '3';
handles.Smooth_temporal.String = '5';
handles.Threshold.String = '0.02';
handles.Smooth_checkbox.Value = 1;



% --- Executes on button press in Line_scan.
function Line_scan_Callback(hObject, eventdata, handles)
% hObject    handle to Line_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Set/Display default parameters

%Show progress
handles.Progress_report.String  = 'Line scanning...';

%Get current parameters
param.spatial_span = str2double(handles.Smooth_spatial.String);
param.temporal_span = str2double(handles.Smooth_temporal.String);
param.threshold = str2double(handles.Threshold.String);

%Find coincident peaks (events)
Avg_line = handles.Load_line.UserData.Avg_line;
tic; 
[co_peaks, Avg_line_smoothed, w_spatial, w_temporal] = findCoPeaks(Avg_line, param); 
toc;

%Do further rejection if background noise has been specified
try
    Avg_noise = handles.Load_line.UserData.Avg_noise;
    Region_avg = nanmean(Avg_line,2);
    Save_vec = Avg_noise < Region_avg;
    Save_matrix = repmat(Save_vec, [1, size(Avg_line,2)]);
    co_peaks = co_peaks.* Save_matrix;
    
    %Get spatial and temporal widths
    w_spatial = w_spatial.* co_peaks; 
    w_spatial(w_spatial == 0) = nan; w_spatial = w_spatial(~isnan(w_spatial));
    w_temporal = w_temporal.* co_peaks; 
    w_temporal(w_temporal == 0) = nan; w_temporal = w_temporal(~isnan(w_temporal));
    disp('Process with rejecting background spillover!')
catch
    %Get spatial and temporal widths 
    w_spatial = w_spatial.* co_peaks; 
    w_spatial(w_spatial == 0) = nan; w_spatial = w_spatial(~isnan(w_spatial));
    w_temporal = w_temporal.* co_peaks; 
    w_temporal(w_temporal == 0) = nan; w_temporal = w_temporal(~isnan(w_temporal));
    disp('Process without rejecting background spillover!')
end

%Save useful information
hObject.UserData.co_peaks = co_peaks;
hObject.UserData.w_spatial = w_spatial;
hObject.UserData.w_temporal = w_temporal;

%Show smoothed 2D line map
showLine2D(handles, Avg_line_smoothed)

%Superimpose events
[x, y] = find(co_peaks);
hold(handles.Line_2D, 'on')
plot(handles.Line_2D, x, y, 'wo','LineWidth',2);
handles.Line_2D.XLim = [0, 1000];
handles.Progress_report.String = 'Events + smoothed line map';
hold(handles.Line_2D, 'off')

handles.Progress_report.String  = 'Scan completed!';


function [co_peaks, Avg_line_smoothed, w1, w2] = findCoPeaks(Avg_line, param)
%   Find coincident peaks based on spatial and temporal line scans.
%   Inputs:
%       Avg_line      2D line map
%       param         parameter for smoothing and thresholding
    
    spatial_span = param.spatial_span; %spatial span for smoothing
    temporal_span = param.temporal_span; %temporal span for smoothing
    
    %Spans must be odd for smooth function
    if ~mod(spatial_span,2)
        spatial_span = spatial_span + 1;
    end
    if ~mod(temporal_span,2)
        temporal_span = temporal_span + 1;
    end
    
    threshold = param.threshold; %Threhold for significant events
        
    %Temporal line scan pixel by pixel
    peak_l2 = zeros(size(Avg_line)); %Binary matrix for peaks identified temporally
    w2 = nan(size(Avg_line)); %Matrix to record all the widths (temporal)
    Avg_line_smoothed =  zeros(size(Avg_line));
    
    for i = 1:size(Avg_line,2)
        cur_trace = Avg_line(:,i);
        cur_trace_smoothed = smooth(cur_trace, temporal_span);
        Avg_line_smoothed(:,i) = cur_trace_smoothed;
        [~, l2_, w2_, ~] = findpeaks(cur_trace_smoothed,...
            'MinPeakDistance', 5, 'MinPeakWidth', 3);
        peak_l2(l2_,i) = 1;
        w2(l2_,i) = w2_;
    end
    
    %Spatial line scan frame by frame
    peak_l1 = zeros(size(Avg_line)); %Binary matrix for peaks identified spatially
    w1 = nan(size(Avg_line)); %Matrix to record all the widths (spatial)
    MinPeakDistance = round(size(Avg_line,2)/15); %Adjust it with the width of IC
    for i = 1:size(Avg_line,1)
        cur_trace = Avg_line_smoothed(i,:);
        cur_trace_smoothed = smooth(cur_trace, spatial_span);
        Avg_line_smoothed(i,:) = cur_trace_smoothed;
        [~, l1_, w1_, ~] = findpeaks(cur_trace_smoothed, ...
            'MinPeakDistance', MinPeakDistance, 'MinPeakWidth', 3);
        peak_l1(i,l1_) = 1;
        w1(i,l1_) = w1_;
    end
    
    %Binary matrix: whether a pixel is active given threshold
    Active_pixels = Avg_line_smoothed > threshold;
    
    %Events should be postive in all three conditions
    co_peaks = peak_l1 .* peak_l2 .* Active_pixels;
    
    



% --- Executes on button press in Load_line.
function Load_line_Callback(hObject, eventdata, handles)
% hObject    handle to Load_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename,path]=uigetfile('*.mat','Please load the movie (mat) file!');
    load(fullfile(path,filename));
    
    %Store useful information
    handles.Load_line.UserData.Avg_line = Avg_line;
    handles.Load_line.UserData.Rec_rotated = Rec_rotated;
    handles.Load_line.UserData.h_rec = h_rec;
    handles.Load_line.UserData.filename = filename;
    try
        handles.Load_line.UserData.Avg_noise = Avg_noise;
        disp('Detected background noise signal!')
    catch
        warning('Did not specify background noise!');
    end
    
    %Show the line map
    showLine2D(handles, Avg_line)
    
    %Report progress
    handles.Progress_report.String = 'File loaded!';

catch
    msgbox('Can not load the file/sth wrong with the data!', 'Error!')
end
    


% --- Executes on button press in Do_dimReduction.
function Do_dimReduction_Callback(hObject, eventdata, handles)
% hObject    handle to Do_dimReduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI_dimReduction();


% --- Executes on button press in Label_movie.
function Label_movie_Callback(hObject, eventdata, handles)
% hObject    handle to Label_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Construct each frame

try
    %Load related variables
    Avg_line = handles.Load_line.UserData.Avg_line;
    co_peaks = handles.Line_scan.UserData.co_peaks;
    start_frame = 1; end_frame = size(Avg_line,1);

    handles.Progress_report.String = 'Labeling locations...';%Update progres

        parfor i = start_frame:end_frame
            %Construct each frame
            h = figure('visible','off');
            cur_line = Avg_line(i,:);
            cur_frame = repmat(cur_line,[11,1]); %Expand the line to a rectangle
            imshow(mat2gray(cur_frame));
            hold on
            if i>start_frame+2 && i<end_frame-2
                [~,x] = find(co_peaks(i-2:i+2,:));
                plot(x,6.*ones(length(x),1),'ro','MarkerSize',1,'LineWidth',2) %Label the center
            end
            hold off
            F(i) = getframe(h);
            close(h)   
            if mod(i,100) == 0
                disp(num2str(i));
            end
        end

        F = F(start_frame:end_frame);

        %Create output labeled movie name
        OutputName = ['Labeled_movie_' num2str(start_frame) '_' num2str(end_frame) '.avi'];

        % create the video writer with 25 fps
        writerObj = VideoWriter(OutputName);
        writerObj.FrameRate = 25;
        % set the seconds per image
        % open the video writer
        open(writerObj);
        % write the frames to the video
        for i=1:length(F)
            % convert the image to a frame
            frame = F(i);    
            writeVideo(writerObj, frame);
        end
        % close the writer object
        close(writerObj);
    
    handles.Progress_report.String = 'Movie labeled!';%Update progres
catch
    msgbox('Can not detect line movie/line scan result!', 'Error!')
end