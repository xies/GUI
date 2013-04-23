function varargout = batch_pulse_viewer(varargin)
% BATCH_PULSE_VIEWER MATLAB code for batch_pulse_viewer.fig
%      BATCH_PULSE_VIEWER, by itself, creates a new BATCH_PULSE_VIEWER or raises the existing
%      singleton*.
%
%      H = BATCH_PULSE_VIEWER returns the handle to a new BATCH_PULSE_VIEWER or the handle to
%      the existing singleton*.
%
%      BATCH_PULSE_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCH_PULSE_VIEWER.M with the given input arguments.
%
%      BATCH_PULSE_VIEWER('Property','Value',...) creates a new BATCH_PULSE_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batch_pulse_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batch_pulse_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batch_pulse_viewer

% Last Modified by GUIDE v2.5 23-Apr-2013 14:08:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batch_pulse_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @batch_pulse_viewer_OutputFcn, ...
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


% --- Executes just before batch_pulse_viewer is made visible.
function batch_pulse_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batch_pulse_viewer (see VARARGIN)

switch numel(varargin)
    case 2
        fits = varargin{1};
        embryo_stack = varargin{2};
    otherwise
        error('2 inputs: fits, embryo_stack');
end
%Input
handles.fits = fits;
handles.embryo_stack = embryo_stack;

%Set fitID selecter
set(handles.fit_selecter,'String',cellfun(@num2str,{fits.fitID},'UniformOutput',0));
set(handles.fit_selecter,'Value',1);

handles = update_plotter(handles);

% Choose default command line output for batch_pulse_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batch_pulse_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = batch_pulse_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------- Plotters ----------------------------
function handles = update_plotter(handles)

% get selected fit
allIDs = get(handles.fit_selecter,'String');
fitID = get(handles.fit_selecter,'Value');
fitID = str2double(allIDs(fitID));
this_fit = handles.fits.get_fitID(fitID);

% update handles
handles.fitID = fitID;
handles.this_fit = this_fit;

frames = this_fit.aligned_time;

% plot myosin + area
ax = plotyy(handles.plot_axes, ...
   frames, this_fit.area, ...
   frames, this_fit.myosin);
legend('Area','Myosin');
ylabel(ax(2), 'Myosin intensity (a.u.)');
ylabel(ax(1), 'Apical area (\mum^2)');
xlabel(ax(1), 'Aligned time (sec)');
title(['Embryo #' num2str(this_fit.embryoID) ', EDGE #' num2str(this_fit.cellID)...
    ', center = ' num2str(this_fit.center) ' sec']);

% update slider bounds
set( handles.frame_selecter, ...
    'Min', nanmin(this_fit.margin_frames) , ...
    'Max', nanmax(this_fit.margin_frames), ...
    'SliderStep', [1, 1]/(numel(this_fit.margin_frames) - 1), ...
    'Value', nanmin(this_fit.margin_frames) );

% update movies
handles = update_movie(handles);


function handles = update_movie(handles)

% get current fit
this_fit = handles.this_fit;
this_embryo = handles.embryo_stack( this_fit.embryoID );

% construct input structure for make_cell_img
h.vx = this_embryo.vertex_x; h.vy = this_embryo.vertex_y;
h.cellID = this_fit.cellID;
h.input = this_embryo.input;
h.channels = {'Membranes','Myosin'};
h.border = 'on';
h.axes = handles.movie_axes;

cla(h.axes);
set(h.axes,'XTick',[],'YTick',[]);

selected_frame = get( handles.frame_selecter, 'Value');
h.frames2load = selected_frame;
handles.frame = selected_frame;

% update text
set( handles.current_frame,'String',num2str( selected_frame ) );
set( handles.time_display, 'String', ...
    num2str( this_fit.aligned_time( this_fit.margin_frames == selected_frame ) ) );

% draw vertical bar on
hold( handles.plot_axes );


make_cell_img(h);


% --------------- Updaters + creators -----------------

% --- Executes on selection change in fit_selecter.
function fit_selecter_Callback(hObject, eventdata, handles)
% hObject    handle to fit_selecter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = update_plotter(handles);
% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns fit_selecter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_selecter


% --- Executes during object creation, after setting all properties.
function fit_selecter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_selecter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function frame_selecter_Callback(hObject, eventdata, handles)
% hObject    handle to frame_selecter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.frame_selecter,'Value',fix(get(hObject,'Value')));

handles = update_movie(handles);

% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function frame_selecter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_selecter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end