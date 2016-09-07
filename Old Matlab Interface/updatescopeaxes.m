global scope_window_time
global scope_window_max
global scope_window_min
global scope_mode
global gui_axes
global text_box_1
global gui_hori_cursor_a_pos
global gui_hori_cursor_b_pos
global gui_vert_cursor_a_pos
global gui_vert_cursor_b_pos
global gui_cursor_mode
global saved_waveform_ch1
global saved_waveform_ch2
global gui_scope_running

global refreshrate_temp
global refreshrate

global waveform_exists
global gui_delay

global fastmode

refreshrate_temp = refreshrate_temp - 1;

tic
delay_sec = get(gui_delay, 'Max') - get(gui_delay, 'Value');
switch(scope_mode)
    case 0
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
            %if(gui_scope_running)
                [taxis, cool_waveform, update_enable] = conv_ana(saved_waveform_ch1, 375000*scope_window_time, 0);
            %end
            plotcursors
            if(cool_waveform)
                waveform_exists = 1;
            end
            if (waveform_exists & update_enable)
				if (fastmode==1)
					disp('Fastmode Enabled')
				else
					disp('Fastmode disabled')
					%set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %.2fV\n ------------------------\n   Vmax = %.2f\n ------------------------\n  Vmean = %.2f\n ------------------------\n   Vrms = %.2f\n ------------------------\n   ', min(cool_waveform), max(cool_waveform), mean(cool_waveform), rms(cool_waveform)));
                    set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %s\n ------------------------\n   Vmax = %s\n ------------------------\n  Vmean = %s\n ------------------------\n   Vrms = %s\n ------------------------\n   ', sisprintf(min(cool_waveform),'V',2), sisprintf(max(cool_waveform),'V',2), sisprintf(mean(cool_waveform),'V',2), sisprintf(rms(cool_waveform),'V', 2))); 
					%title(titlestring);
					xlabel(gui_axes, 'Time (s)')
					ylabel(gui_axes, 'Voltage (V)')
				end
                drawnow
            end
        end
    case 1
        if ~(refreshrate == 4)
            error('Refreshrate assumed to be 4 for Mode 1')
        end
        switch(refreshrate_temp)
            case 3
                %if(gui_scope_running)
                    [taxis, cool_waveform, update_enable] = conv_ana(saved_waveform_ch1, 375000*scope_window_time, 0);
                    [taxis_ch2, temp_waveform_ch2] = conv_dig(saved_waveform_ch2, 375000*scope_window_time);
                    temp_waveform_ch2 = (scope_window_max - (0.05*(scope_window_max - scope_window_min))  - scope_window_min) * temp_waveform_ch2 + scope_window_min + (0.025*(scope_window_max - scope_window_min));
               % end
            case 2
                stairs(gui_axes, taxis_ch2, temp_waveform_ch2, 'c');
                hold(gui_axes, 'on')
                plotcursors
                hold(gui_axes, 'off')
                if(update_enable)
                    set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %.2fV\n ------------------------\n   Vmax = %.2f\n ------------------------\n  Vmean = %.2f\n ------------------------\n   Vrms = %.2f\n ------------------------\n   ', min(cool_waveform), max(cool_waveform), mean(cool_waveform), rms(cool_waveform)));
                    xlabel(gui_axes, 'Time (s)')
                    ylabel(gui_axes, 'Voltage (V)')
                    drawnow
                end
            case 0
                refreshrate_temp = refreshrate;
        end
    case 2
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
           % if(gui_scope_running)
                [taxis_ch1, cool_waveform_ch1, update_enable] = conv_ana(saved_waveform_ch1, 375000*scope_window_time, 0);
                [taxis_ch2, cool_waveform_ch2] = conv_ana(saved_waveform_ch2, 375000*scope_window_time, 1);
            %end
            plotcursors
                        if(cool_waveform)                 waveform_exists = 1;             end
            if (waveform_exists & update_enable)
                set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %.2fV\n ------------------------\n   Vmax = %.2f\n ------------------------\n  Vmean = %.2f\n ------------------------\n   Vrms = %.2f\n ------------------------\n   ', min(cool_waveform_ch1), max(cool_waveform_ch1), mean(cool_waveform_ch1), rms(cool_waveform_ch1)));
                %title(titlestring);
                xlabel(gui_axes, 'Time (s)')
                ylabel(gui_axes, 'Voltage (V)')
                drawnow
            end
        end
    case 3
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
            %if(gui_scope_running)
                [taxis, temp_waveform] = conv_dig(saved_waveform_ch1, 375000*scope_window_time);
           % end
            stairs(gui_axes, taxis, temp_waveform, 'y');
            set(gui_axes, 'Ylim', [-0.1, 1.1], 'Xlim', [-scope_window_time-delay_sec, 0-delay_sec], 'Color', [0 0 0], 'Box', 'on', 'XColor', [1 1 1], 'Ycolor', [1 1 1]);
            set(text_box_1, 'String', 'Scope in dig mode');
            xlabel(gui_axes, 'Time (s)')
            ylabel(gui_axes, 'Logic Value')
            drawnow
        end
    case 4
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
          %  if(gui_scope_running)
                [taxis_ch1, temp_waveform_ch1] = conv_dig(saved_waveform_ch1, 375000*scope_window_time);
                [taxis_ch2, temp_waveform_ch2] = conv_dig(saved_waveform_ch2, 375000*scope_window_time);
            %end
            waveform_exists = 1
        elseif (refreshrate_temp == 3) && (waveform_exists)
            stairs(gui_axes, taxis_ch2, temp_waveform_ch2, 'c');
            hold(gui_axes, 'on') 
            stairs(gui_axes, taxis_ch1, temp_waveform_ch1, 'y');
            hold(gui_axes, 'off')
            set(gui_axes, 'Ylim', [-0.1, 1.1], 'Xlim', [-scope_window_time-delay_sec, 0-delay_sec], 'Color', [0 0 0], 'Box', 'on', 'XColor', [1 1 1], 'Ycolor', [1 1 1]);
            set(text_box_1, 'String', 'Scope in dig mode');
            xlabel(gui_axes, 'Time (s)')
            ylabel(gui_axes, 'Logic Value')
            drawnow
        end
    case 5
        set(text_box_1, 'String', 'Scope disabled');
        xlabel(gui_axes, '')
        ylabel(gui_axes, '')
        drawnow
        pause(0.001)
    case 6
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
            %if(gui_scope_running)
                [taxis, cool_waveform, update_enable] = conv_ana(saved_waveform_ch1, 750000*scope_window_time, 0);
            %end
            plotcursors
                        if(cool_waveform)                 waveform_exists = 1;             end
            if (waveform_exists & update_enable)
                set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %.2fV\n ------------------------\n   Vmax = %.2f\n ------------------------\n  Vmean = %.2f\n ------------------------\n   Vrms = %.2f\n ------------------------\n   ', min(cool_waveform), max(cool_waveform), mean(cool_waveform), rms(cool_waveform)));
                %title(titlestring);
                xlabel(gui_axes, 'Time (s)')
                ylabel(gui_axes, 'Voltage (V)')
                drawnow
            end
        end
    case 7
        if (refreshrate_temp == 0)
            refreshrate_temp = refreshrate;
            %if(gui_scope_running)
                [taxis, cool_waveform, update_enable] = conv_ana(saved_waveform_ch1, (375000/(3*fastmode + 1))*scope_window_time, 0);
            %end
            plotcursors
                        if(cool_waveform)                 waveform_exists = 1;             end
            if (waveform_exists & update_enable)
                set(text_box_1, 'String', sprintf(' ------------------------\n   Vmin = %.2fV\n ------------------------\n   Vmax = %.2f\n ------------------------\n  Vmean = %.2f\n ------------------------\n   Vrms = %.2f\n ------------------------\n   ', min(cool_waveform), max(cool_waveform), mean(cool_waveform), rms(cool_waveform)));
                %title(titlestring);
                xlabel(gui_axes, 'Time (s)')
                ylabel(gui_axes, 'Voltage (V)')
                drawnow
            end
        end
    otherwise
        error('scope_mode invalid!')
end
toc