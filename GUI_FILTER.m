function varargout = GUI_FILTER(varargin)
% GUI_FILTER M-file for GUI_FILTER.fig
%      GUI_FILTER, by itself, creates a new GUI_FILTER or raises the existing
%      singleton*.
%
%      H = GUI_FILTER returns the handle to a new GUI_FILTER or the handle to
%      the existing singleton*.
%
%      GUI_FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FILTER.M with the given input arguments.
%
%      GUI_FILTER('Property','Value',...) creates a new GUI_FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_FILTER_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_FILTER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help GUI_FILTER

% Last Modified by GUIDE v2.5 03-Jun-2016 16:39:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FILTER_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FILTER_OutputFcn, ...
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


% --- Executes just before GUI_FILTER is made visible.
function GUI_FILTER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FILTER (see VARARGIN)

% Choose default command line output for GUI_FILTER

set(handles.textStatic1,'String','Low Freq (HZ):');
set(handles.textStatic2,'Visible','Off');
set(handles.editF2,'Visible','Off');
handles.SelectedFilter = 1;

set(handles.sliderSNR,'Min',-35);
set(handles.sliderSNR,'Max', 15);
handles.SNR = (get(handles.sliderSNR,'Value'));
set(handles.editSNR, 'String', [num2str(handles.SNR) ' dB SNR'] );

handles.fileLoaded = 0;
handles.fileNoisy = 0;
handles.fileFinal = 0;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_FILTER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_FILTER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.*'},'Load File');
[x,Fs] = audioread([PathName '/' FileName]);
handles.x = x ./ max(abs(x));
handles.Fs = Fs;
axes(handles.axesSignal1);
time = 0:1/Fs:(length(handles.x)-1)/Fs;
plot(time, handles.x);
axis([0 max(time) -1 1]);
axes(handles.axesSpec1);
specgram(handles.x, 1024, handles.Fs);
title('Signal Spectrogram');
handles.fileLoaded = 1;

axes(handles.axesSpecNoise); cla;
axes(handles.axesSpec2); cla;
axes(handles.axesSpecFinal); cla;

handles.fileNoisy = 0;
handles.fileFinal = 0;

guidata(hObject, handles);

% --- Executes on button press in buttonPlay.
function buttonPlay_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.fileLoaded==1)
    sound(handles.x, handles.Fs);
end



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
S = get(hObject,'Value');

switch (S)
    case (1)
        set(handles.textStatic1,'String','Low Freq (Hz):');
        set(handles.textStatic2,'Visible','Off');
        set(handles.editF2,'Visible','Off');
        handles.SelectedFilter = 1;
    case (2)
        set(handles.textStatic1,'String','High Freq (Hz):');
        set(handles.textStatic2,'Visible','Off');
        set(handles.editF2,'Visible','Off');
        handles.SelectedFilter = 2;        
    case (3)
        set(handles.textStatic1,'String','Low Freq (Hz):');
        set(handles.textStatic2,'Visible','On');
        set(handles.editF2,'Visible','On');
        set(handles.textStatic2,'String','High Freq (Hz):');       
        handles.SelectedFilter = 3;        
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editF1_Callback(hObject, eventdata, handles)
% hObject    handle to editF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF1 as text
%        str2double(get(hObject,'String')) returns contents of editF1 as a double


% --- Executes during object creation, after setting all properties.
function editF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editF2_Callback(hObject, eventdata, handles)
% hObject    handle to editF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF2 as text
%        str2double(get(hObject,'String')) returns contents of editF2 as a double


% --- Executes during object creation, after setting all properties.
function editF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pushNoise.
function pushNoise_Callback(hObject, eventdata, handles)
% hObject    handle to pushNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.fileLoaded==1)

    Noise = 2*rand(size(handles.x)) - 1;
    N = 300;
    DONE = 0;

    switch (handles.SelectedFilter)
        case (1)
            % Lowpass:
            Fpass  = str2num(get(handles.editF1,'String'));
            if (length(Fpass)>0)
                if (Fpass<handles.Fs/2-30)
                    Fstop  = Fpass + 30;        
                    handles.Fpass = Fpass;
                    handles.Fstop = Fstop;
                    Hd = generateLowPassFilter(Fpass, Fstop, handles.Fs, N);
                    DONE = 1;
                else
                    msgbox('Frequency value is not in the correct range','Wrong Frequency Value','error');
                end
            else
                msgbox('Missing Frequency values! Please fill in the missing values and try again.','Missing Frequency values','error');
            end
        case (2)      
            % Highpass:
            Fpass = str2num(get(handles.editF1,'String'));            
            if (length(Fpass)>0)
                if (Fpass<handles.Fs/2-30)                
                    Fstop  = Fpass - 30;        
                    handles.Fpass = Fpass;
                    handles.Fstop = Fstop;            
                    Hd = generateHighPassFilter(Fpass, Fstop, handles.Fs, N);
                    DONE = 1;
                else
                    msgbox('Frequency value is not in the correct range','Wrong Frequency Value','error');
                end
            else
                msgbox('Missing Frequency values! Please fill in the missing values and try again.','Missing Frequency values','error');
            end
        case (3)
            % Bandpass:
            Fpass1 = str2num(get(handles.editF1,'String'));            
            Fpass2 = str2num(get(handles.editF2,'String'));
            if ((length(Fpass1)>0) & (length(Fpass2)>0))            
                Fstop1 = Fpass1 - 30;                            
                Fstop2 = Fpass2 + 30; 
                handles.Fpass1 = Fpass1;
                handles.Fstop1 = Fstop1;
                handles.Fpass2 = Fpass2;
                handles.Fstop2 = Fstop2;            
                Hd = generateBandPassFilter(Fpass1, Fstop1, Fpass2, Fstop2, handles.Fs, N);
                DONE = 1;
            else
                msgbox('Missing Frequency values! Please fill in the missing values and try again.','Missing Frequency values','error');
            end
    end
    
    if (DONE==1)
        handles.fileNoisy = 1;
        handles.Hd = Hd;
        Noise = filter(Hd, 1, Noise);
        M = mean(handles.x);
        S = std(handles.x);
        SN = std(Noise);
        Noise = sqrt((1 / 10 ^ (handles.SNR/10))) * (Noise - M) * (S/SN);

        axes(handles.axesSpecNoise);
        specgram(Noise, 1024, handles.Fs);
        title('Noise Spectrogram');

        handles.x2 = handles.x + Noise;

        axes(handles.axesSpec2);
        specgram(handles.x2, 1024, handles.Fs);
        title('Noisy Signal Spectrogram');
    end
               
    
end
guidata(hObject, handles);



% --- Executes on button press in buttonPlay2.
function buttonPlay2_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (handles.fileNoisy==1)
    sound(handles.x2, handles.Fs);
end


% --- Executes on slider movement.
function sliderSNR_Callback(hObject, eventdata, handles)
% hObject    handle to sliderSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.SNR = (get(hObject,'Value'));
set(handles.editSNR, 'String', [sprintf('%.1f',handles.SNR) ' dB SNR'] );
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editSNR_Callback(hObject, eventdata, handles)
% hObject    handle to editSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSNR as text
%        str2double(get(hObject,'String')) returns contents of editSNR as a double


% --- Executes during object creation, after setting all properties.
function editSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in buttonDenoise.
function buttonDenoise_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDenoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    N = 300;

    switch (handles.SelectedFilter)
        case (1)
            % Lowpass --> Highpass:
            Fpass  = handles.Fstop;
            Fstop  = Fpass - 30;
            Hd_inv = generateHighPassFilter(Fpass, Fstop, handles.Fs, N);
        case (2)      
            % Highpass --> Lowpass:
            Fpass = handles.Fstop;
            Fstop = Fpass + 30;
            Hd_inv = generateLowPassFilter(Fpass, Fstop, handles.Fs, N);
        case (3)
            % Bandpass:
            Fpass1 = handles.Fstop1;
            Fstop1 = Fpass1 + 30;                
            Fpass2 = handles.Fstop2;
            Fstop2 = Fpass2 - 30;
            Hd_inv = generateBandStopFilter(Fpass1, Fstop1, Fpass2, Fstop2, handles.Fs, N);
    end

axes(handles.axesFilter);
%Hd_inv = inverseFilter(handles.Hd, handles.Fs,1,0);
[F,w] = freqz(Hd_inv, 1 , 1000, handles.Fs);

semilogy(w,abs(F));

handles.Hd_inv = Hd_inv;
xFinal = filter(handles.Hd_inv, 1, handles.x2);

handles.xFinal = xFinal / max(abs(xFinal));

axes(handles.axesSpecFinal);
specgram(handles.xFinal, 1024, handles.Fs);
handles.fileFinal = 1;

guidata(hObject, handles);


% --- Executes on button press in pushPlayFinal.
function pushPlayFinal_Callback(hObject, eventdata, handles)
% hObject    handle to pushPlayFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.fileFinal==1)
    sound(handles.xFinal, handles.Fs);
end



% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function credits_Callback(hObject, eventdata, handles)
% hObject    handle to credits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help;
