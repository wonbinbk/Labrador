function [] = setscopemode(mode, gain0, gain1);  %Mode zero for single channel analog, 1 for single digital, 2 for 2ch analog, 3 for 2ch digital
global scope_mode
scope_mode = mode;

if(gain0~=0.5 & gain0~=1 & gain0~=2 & gain0~=4 & gain0~=8 & gain0~=16 & gain0~=32 & gain0~=64)
    error('Valid values of gain are 0.5, 1, 2, 4, 8, 16, 32, 64');
end

if(gain1~=0.5 & gain1~=1 & gain1~=2 & gain1~=4 & gain1~=8 & gain1~=16 & gain1~=32 & gain1~=64)
    error('Valid values of gain are 0.5, 1, 2, 4, 8, 16, 32, 64');
end


global scope_gain_0
scope_gain_0 = gain0;

global scope_gain_1
scope_gain_1 = gain1;


gain_mask_0 = uint16([]);

if (gain0 == 1/2)
    gain_mask_0 = 7*4;
else 
    gain_mask_0 = log2(gain0) * 4;
end

gain_mask_1 = uint16([]);

if (gain1 == 1/2)
    gain_mask_1 = 7*4;
else 
    gain_mask_1 = log2(gain1) * 4;
end

gain_mask = gain_mask_0 + 256*gain_mask_1;


mex_usb_send_control('40', 'a5', dec2hex(mode), dec2hex(gain_mask), '0', '0');

% driverLocation = 'c:\libusbk\examples\open-device\debug\win32';
% command = [driverLocation '\open-device "03eb" "a000" "' command '" "' num2str(onoff) '" "NULL" "NULL" "NULL"']
% system(command);