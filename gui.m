function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 21-Jun-2014 21:06:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
set(handles.iloscBitow,'enable','off');
set(handles.snrValue,'enable','off');
set(handles.pushbutton3,'enable','off');
set(handles.edit2,'enable','off');
set(handles.tekstowa,'enable','off');
set(handles.pseudolosowa,'enable','off');
handles.MessageLength = 100;            % domylślna liczba bitów
handles.SignalToNoiseRatio = 15;        % domyślna wartość SNR
handles.text = 'Przykładowa wiadomość tekstowa';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

howManyBits = 10000;       %liczba bitów do symulacji BER
[bitErrorRate, SNRdB,theoryBer ]=QAMBER(handles.ConstelationType,howManyBits);
% rysowanie wykresów
axes(handles.axes5);
semilogy(SNRdB,bitErrorRate,'X',SNRdB,theoryBer);
grid;
set(handles.text17,'String',howManyBits);
set(handles.text18,'String',bitErrorRate);
% Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function iloscBitow_Callback(hObject, eventdata, handles)
% hObject    handle to iloscBitow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

MessageLength = round(get(hObject,'Value'));
set(handles.bitValue,'String',MessageLength);
handles.MessageLength = MessageLength;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated,bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
set(handles.text26,'String', bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
hold off

% --- Executes during object creation, after setting all properties.
function iloscBitow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iloscBitow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    
end

% --- Executes on slider movement.
function snrValue_Callback(hObject, eventdata, handles)
% hObject    handle to snrValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SignalToNoiseRatio = round(get(hObject,'Value'));
set(handles.snrVal,'String',SignalToNoiseRatio);
handles.SignalToNoiseRatio = SignalToNoiseRatio;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
if(handles.bool == 0)
    
    [signal,I,Q,mod,mappedSymbols,signalDemodulated,bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
    set(handles.text26,'String', bitErrorRate);
    cla;
    axes(handles.axes1)
    plot(I,'r')
    grid;
    axes(handles.axes2)
    plot(Q)
    grid;
    axes(handles.axes7)
    plot(real(signal),'r')
    grid;
    axes(handles.axes8)
    plot(imag(signal))
    grid;
    axes(handles.axes3)
    hold on
    plot(mod,'or');
    plot(mappedSymbols,'xb');
    plot(signalDemodulated,'.');
    hold off
else
    S = handles.text;
    if isempty(S)
        set(handles.text25,'String','WPROWADŹ TEKST POLE NIE MOŻE BYĆ PUSTE!');
    else
        [signal,I,Q,mod,mappedSymbols,signalDemodulated,text,bitErrorRate] = QAMASCII(handles.ConstelationType,handles.text,handles.SignalToNoiseRatio);
        set(handles.text25,'String',text);
        set(handles.text26,'String',bitErrorRate);
        cla;
        axes(handles.axes1)
        plot(I,'r')
        grid;
        axes(handles.axes2)
        plot(Q)
        grid;
        axes(handles.axes7)
        plot(real(signal),'r')
        grid;
        axes(handles.axes8)
        plot(imag(signal))
        grid;
        axes(handles.axes3)
        hold on
        plot(mod,'or');
        plot(mappedSymbols,'xb');
        plot(signalDemodulated,'.');
        hold off
    end
end


% --- Executes during object creation, after setting all properties.
function snrValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snrValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%------------------------FUNKCJE OBSŁUGUJĄCE WYBÓR KONSTELACJI-------------------------------------

% --- Executes on button press in qam1024.
function qam1024_Callback(hObject, eventdata, handles)
% hObject    handle to qam1024 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam1024
if(get(hObject,'Value')== 1)
    set(handles.qam4,'Value',0);
    set(handles.qam16,'Value',0);
    set(handles.qam64,'Value',0);
    set(handles.qam256,'Value',0);
    
    ConstelationType=1024;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.tekstowa,'enable','on');
    set(handles.pseudolosowa,'enable','on');
    
    
    
end;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
axis([-35 35 -35 35])
hold off

% --- Executes on button press in qam1024.
function qam256_Callback(hObject, eventdata, handles)
% hObject    handle to qam256 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam256
if(get(hObject,'Value')== 1)
    set(handles.qam4,'Value',0);
    set(handles.qam16,'Value',0);
    set(handles.qam64,'Value',0);
    set(handles.qam1024,'Value',0);
    set(handles.tekstowa,'enable','on');
    set(handles.pseudolosowa,'enable','on');
    ConstelationType=256;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    
    
    
    
end;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated,bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
set(handles.text26,'String', bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
axis([-17 17 -17 17])
hold off

% --- Executes on button press in qam64.
function qam64_Callback(hObject, eventdata, handles)
% hObject    handle to qam64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam64
if(get(hObject,'Value')== 1)
    set(handles.qam4,'Value',0);
    set(handles.qam16,'Value',0);
    set(handles.qam1024,'Value',0);
    set(handles.qam256,'Value',0);
    set(handles.tekstowa,'enable','on');
    set(handles.pseudolosowa,'enable','on');
    ConstelationType = 64;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    
    
    
end;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated,bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
set(handles.text26,'String', bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
axis([-8 8 -8 8])
hold off

% --- Executes on button press in qam16.
function qam16_Callback(hObject, eventdata, handles)
% hObject    handle to qam16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam16
if(get(hObject,'Value')== 1)
    set(handles.qam4,'Value',0);
    set(handles.qam1024,'Value',0);
    set(handles.qam64,'Value',0);
    set(handles.qam256,'Value',0);
    set(handles.tekstowa,'enable','on');
    set(handles.pseudolosowa,'enable','on');
    ConstelationType=16;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    
    
    
    
end;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated,bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
set(handles.text26,'String', bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
axis([-4 4 -4 4])
hold off

% --- Executes on button press in qam4.
function qam4_Callback(hObject, eventdata, handles)
% hObject    handle to qam4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qam4
if(get(hObject,'Value')== 1)
    set(handles.qam1024,'Value',0);
    set(handles.qam16,'Value',0);
    set(handles.qam64,'Value',0);
    set(handles.qam256,'Value',0);
    ConstelationType=4;
    handles.ConstelationType = ConstelationType;
    handles.output = hObject;
    set(handles.tekstowa,'enable','on');
    set(handles.pseudolosowa,'enable','on');
    
    
    
end;
% Update handles structure
guidata(hObject, handles);
% rysowanie wykresów
[signal,I,Q,mod,mappedSymbols,signalDemodulated, bitErrorRate] = QAM(handles.ConstelationType,handles.MessageLength,handles.SignalToNoiseRatio);
set(handles.text26,'String', bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(signal,'xb');
plot(signalDemodulated,'.');
axis([-1.5 1.5 -1.5 1.5])
hold off

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noweOkno.
function noweOkno_Callback(hObject, eventdata, handles)
% hObject    handle to noweOkno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui2;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
text = get(hObject,'String');
handles.text = text;
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pseudolosowa.
function pseudolosowa_Callback(hObject, eventdata, handles)
% hObject    handle to pseudolosowa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pseudolosowa
set(handles.tekstowa,'Value',0);
set(handles.qam16,'Value',0);
set(handles.snrValue,'enable','on');
set(handles.iloscBitow,'enable','on');
set(handles.edit2,'enable','off');
set(handles.pushbutton3,'enable','off');
handles.bool = 0;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in tekstowa.
function tekstowa_Callback(hObject, eventdata, handles)
% hObject    handle to tekstowa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tekstowa
set(handles.pseudolosowa,'Value',0);
set(handles.snrValue,'enable','on');
set(handles.edit2,'enable','on');
set(handles.iloscBitow,'enable','off');
set(handles.pushbutton3,'enable','on');
handles.bool = 1;
% Update handles structure
guidata(hObject, handles);
[signal,I,Q,mod,mappedSymbols,signalDemodulated,wiadomosc,bitErrorRate] = QAMASCII(handles.ConstelationType,handles.text,handles.SignalToNoiseRatio);
set(handles.text25,'String',wiadomosc);
set(handles.text26,'String',bitErrorRate);
cla;
axes(handles.axes1)
plot(I,'r')
grid;
axes(handles.axes2)
plot(Q)
grid;
axes(handles.axes7)
plot(real(signal),'r')
grid;
axes(handles.axes8)
plot(imag(signal))
grid;
axes(handles.axes3)
hold on
plot(mod,'or');
plot(mappedSymbols,'xb');
plot(signalDemodulated,'.');
hold off



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.text;
if isempty(S)
    set(handles.text25,'String','WPROWADŹ TEKST POLE NIE MOŻE BYĆ PUSTE!');
else
    [signal,I,Q,mod,mappedSymbols,signalDemodulated,wiadomosc,bitErrorRate] = QAMASCII(handles.ConstelationType,handles.text,handles.SignalToNoiseRatio);
    set(handles.text25,'String',wiadomosc);
    set(handles.text26,'String',bitErrorRate);
    cla;
    axes(handles.axes1)
    plot(I,'r')
    grid;
    axes(handles.axes2)
    plot(Q)
    grid;
    axes(handles.axes7)
    plot(real(signal),'r')
    grid;
    axes(handles.axes8)
    plot(imag(signal))
    grid;
    axes(handles.axes3)
    hold on
    plot(mod,'or');
    plot(mappedSymbols,'xb');
    plot(signalDemodulated,'.');
    hold off
end
