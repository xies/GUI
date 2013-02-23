function varargout = match_viewer(varargin)
% MATCH_VIEWER MATLAB code for match_viewer.fig
%      MATCH_VIEWER, by itself, creates a new MATCH_VIEWER or raises the existing
%      singleton*.
%
%      H = MATCH_VIEWER returns the handle to a new MATCH_VIEWER or the handle to
%      the existing singleton*.
%
%      MATCH_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATCH_VIEWER.M with the given input arguments.
%
%      MATCH_VIEWER('Property','Value',...) creates a new MATCH_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before match_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to match_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help match_viewer

% Last Modified by GUIDE v2.5 23-Feb-2013 14:22:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @match_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @match_viewer_OutputFcn, ...
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


% --- Executes just before match_viewer is made visible.
function match_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to match_viewer (see VARARGIN)

% Choose default command line output for match_viewer
handles.output = hObject;

% Get data
pulse = varargin{1}; handles.pulse = pulse;
categories = pulse.categories;

cells = varargin{2}; handles.cells = cells;
embryo_struct = varargin{3}; handles.embryo_struct = embryo_struct;

% Initialize category selecter
cat_names = fieldnames(categories);
set(handles.category,'String', cat_names(end:-1:1));
set(handles.category,'Value',1);
handles.current_category = cat_names{1};
% Initialize movie selecter

set(handles.track,'Value',1); set(handles.fit,'Value',0);
set(handles.whichID,'Value',1);

handles = match_category_id_selecter_callback(handles);
handles = movie_pulse_selecter_callback(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes match_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = match_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in category.
function category_Callback(hObject, eventdata, handles)
% hObject    handle to category (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% match = handles.pulses.match;
% cells = handles.cells;
% 
% categories = get(hObject,'String');
% current_category = lower(categories{get(hObject,'Value')});
% % Set ID range
% set(handles.categoryID, ...
%     'String', num2cell(1:numel( match.(current_category) )) );
% set(handles.categoryID,'Value',1);
% categoryID = get(handles.categoryID,'Value');
% 
% graph_match(match.(current_category),cells,tracks,pulses,categoryID);

set(handles.categoryID,'Value',1);

handles = match_category_id_selecter_callback(handles);
handles = movie_pulse_selecter_callback(handles);

guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns category contents as cell array
%        contents{get(hObject,'Value')} returns selected item from category


% --- Executes during object creation, after setting all properties.
function category_CreateFcn(hObject, eventdata, handles)
% hObject    handle to category (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in categoryID.
function categoryID_Callback(hObject, eventdata, handles)

% match = handles.match;
% cells = handles.cells;
% tracks = handles.tracks;
% pulses = handles.pulses;
% 
% categories = get(handles.category,'String');
% current_category = lower(categories{get(handles.category,'Value')});
% % ID
% catIDs = get(hObject, 'String');
% categoryID = catIDs{get(hObject,'Value')};
% categoryID = str2double(categoryID);
% 
% visualize_match(match.(current_category),cells,tracks,pulses,categoryID);
% handles=guidata(handles.output);

handles = match_category_id_selecter_callback(handles);
handles = movie_pulse_selecter_callback(handles);

guidata(hObject,handles);

% hObject    handle to categoryID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns categoryID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from categoryID


% --- Executes during object creation, after setting all properties.
function categoryID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to categoryID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -- Spawn pulse play_movie --;

% --- Executes on button press in play_movie.
function play_movie_Callback(hObject, eventdata, handles)
% hObject    handle to play_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get data from handle
% pulse = handles.pulse;
% tracks = pulse.tracks; fits = pulse.fits;
% cats = pulse.categories;
% cells = handles.cells; embryo_struct = handles.embryo_struct;

% get current selected category
% categories = get( handles.category,'String' );
% current_category = lower( categories{get(handles.category,'Value')} );
% cats = cats.(current_category);
% catID - which one from category
% catID = get( handles.categoryID, 'Value' );
% 
% % track or fit?
% which = get(handles.track_or_fit,'Value');
% if which == 1, which = 'trackID'; else which = 'fitID'; end
% % special case for add/miss
% if strcmpi(current_category,'miss'), which = 'trackID'; end
% if strcmpi(current_category,'add'), which = 'fitID'; end
% 
% whichID = get(handles.whichID,'Value')
% 
% if strcmpi( which, 'track')
%     this_pulse = tracks( cats(catID).(which) (whichID) );
%     h.frame = this_pulse.dev_frames(1);
% else
%     this_pulse = fits( cats(catID).(which) (whichID) );
%     h.frame = this_pulse.margin_frames(1);
% end
% 
% h.vx = handles.embyro_struct.vertex_x; h.vy = handles.embyro_struct.vertex_y;
% h.cellID = this_pulse.stackID;
% h.input = handles.embryo_struct(this_pulse.embryoID).input;
% h.channels = {'Myosin','Membranes'};
% h.axes = handles.movie_panel;

handles = movie_pulse_selecter_callback(handles);
handles = match_viewer_update_movie_callback(handles);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function track_or_fit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track_or_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over play_movie.
function play_movie_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to play_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in whichID.
function whichID_Callback(hObject, eventdata, handles)
% hObject    handle to whichID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = movie_pulse_selecter_callback(handles);
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns whichID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from whichID


% --- Executes during object creation, after setting all properties.
function whichID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whichID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set( hObject,'Value',fix(get(hObject,'Value')) );

handles = movie_pulse_selecter_callback(handles);

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in which.
function which_SelectionChangeFcn(hObject, eventdata, handles)

% hObject    handle to the selected object in which 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'track'
        % Code for when track is selected.
        set(handles.track,'Value',1);
        set(handles.fit,'Value',0);
    case 'fit'
        set(handles.track,'Value',0);
        set(handles.fit,'Value',1);
        % Code for when fit is selected.
    otherwise
        % Code for when there is no match.
end

handles = movie_pulse_selecter_callback(handles);
guidata(hObject,handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end