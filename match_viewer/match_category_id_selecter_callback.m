function handles = match_category_id_selecter_callback(handles)
% This function handles plotting the correct category/categoryID
% pulse/track onto the GUI axes

% handles=guidata(handles.output);

% Get data
pulse = handles.pulse;
cells = pulse.cells;
% embryo_struct = handles.embryo_struct;
% fits = handles.pulse.fits;
% tracks = handles.pulse.tracks;

% Update category selecter dropdown menu
categories = pulse.categories;
cat_names = fieldnames(categories);
set(handles.category,'String', cat_names(end:-1:1));
handles.current_category = cat_names{1};

% Get the currently selected category
categories = get( handles.category,'String');
if get(handles.category,'Value') > numel(categories)
	set(handles.category,'Value',1);
end
current_cat = lower( categories{get(handles.category,'Value')} );
% Set catID selecter values to number of match objects
set( handles.categoryID, ...
    'String', num2cell( 1:numel(pulse.categories.(current_cat)) ) );
% If current value exeeds number of objects, reset to 1
if get( handles.categoryID,'Value') > numel(pulse.categories.(current_cat))
    set(handles.categoryID,'Value',1);
end
catID = get( handles.categoryID,'Value');

if strcmpi(current_cat,'add')
    set(handles.fit,'Enable','off');
    set(handles.track,'Enable','off');
    set(handles.fit,'Value',1);
    set(handles.track,'Value',0);
elseif strcmpi(current_cat,'miss')
    set(handles.fit,'Enable','off');
    set(handles.track,'Enable','off');
    set(handles.fit,'Value',0);
    set(handles.track,'Value',1);
else
    set(handles.fit,'Enable','on');
    set(handles.track,'Enable','on');
end

handles.catID = catID;
handles.current_category = current_cat;

[trackID, fitID] = pulse.graph(current_cat,catID,handles.axes_panel);

% Update cell/track/fit being displayed
candidate_tracks = pulse.get_trackID(trackID);
if ~isempty(candidate_tracks)
    handles.current_cell = candidate_tracks(1).cellID;
else
    candidate_fits = pulse.get_fitID(fitID);
    handles.current_cell = candidate_fits(1).cellID;
end
handles.current_tracks = trackID;
handles.current_fits = fitID;

end
