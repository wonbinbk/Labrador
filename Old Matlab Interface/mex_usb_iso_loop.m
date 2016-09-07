%mex USB_ISO_LOOP.c -Iincludes -llibusbK -Lbin\lib\amd64 
%clear all

global usb_handle
global scope_gain_0
global scope_gain_1
global scope_window_time
global scope_window_max
global scope_window_min
global scope_mode
global gui_scope_running

global gui_hori_cursor_a_pos
global gui_hori_cursor_b_pos
global gui_vert_cursor_a_pos
global gui_vert_cursor_b_pos
global gui_cursor_mode
global saved_waveform_ch1
global saved_waveform_ch2

global refreshrate
global refreshrate_temp
global waveform_exists

global trigger

global sem_avail

trigger = struct('l', 0, 'h', 0, 'state', 0, 'begin', 1, 'enabled', 0);

dotheplot

if ~length(usb_handle)
    warning('USB Handle not initialised.  Initialising!')
    mex_usb_init('03eb', 'a000')
end

[stm_handle] = USB_ISO_INIT(usb_handle)

refreshrate = 4;
refreshrate_temp = refreshrate;

if(isempty(max_n))
    max_n = 10
end
saved_waveform_ch1 = int8([]);

if isempty(scope_mode)
    error('You didn''t set the scope mode!');
end

if isempty(scope_window_time)
    error('You didn''t set the window time (x) value!');
end

if (scope_window_time < 1/375000)
    error('Scope window size is too small!');
end

if(scope_mode==0)
    if isempty(scope_gain_0) || isempty(scope_gain_1)
        error('You didn''t set the gain!');
    end

    if isempty(scope_window_min)
        error('You didn''t set the minimum window voltage value!');
    end

    if isempty(scope_window_max)
        error('You didn''t set the maximum window voltage value!');
    end
end

dropped_packets = 0;
if(isempty(waveform_exists))
    waveform_exists = 0;
end

global extra_goes;
extra_goes = 0;

sem_avail = 0;
timer_30ms = timer ('TimerFcn', 'timer30ms_callback', 'Period', 30e-3, 'ExecutionMode', 'fixedRate');
start(timer_30ms);

for n=1:max_n              
    %[transfer_contents_0] = USB_ISO_LOOP(usb_handle, isoCtx_0, ovlkHandle_0, ovlPool, isoBuffer, uint8(0));
    
    while(sem_avail==0)
        pause(0);
        %timer_30ms;
    end
    sem_avail = sem_avail - 1;
    [transfer_contents_0, libk_error] = USB_ISO_LOOP(usb_handle, stm_handle);
    keep_in_sync
    if scope_mode == 7
        transfer_contents_0 = double(transfer_contents_0);
    end
    displaypacket(transfer_contents_0)
    updatescopeaxes
    
    %[transfer_contents_1] = USB_ISO_LOOP(usb_handle, isoCtx_1, ovlkHandle_1, ovlPool, isoBuffer, uint8(1));   
    
    while(sem_avail==0)
        pause(0.001);
    end
    sem_avail = sem_avail - 1;
    [transfer_contents_1, libk_error] = USB_ISO_LOOP(usb_handle, stm_handle);    
    keep_in_sync
    if scope_mode == 7
        transfer_contents_0 = double(transfer_contents_0);
    end
    displaypacket(transfer_contents_1)
    updatescopeaxes
end

crash_recover