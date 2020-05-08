function ParForWaitbarProgressMH(h,NbrePts,Msg)
% h: Handle of the Waitbar
% NbrePts: Number of Steps 
% Msg: Waitbar's Message Field

% Get the Fractional Length of the Waitbar 
x = get(h,'UserData');

waitbar(x/NbrePts,h,Msg);

% Progress Indicator as a Percentage
set(h,'Name',sprintf('%.0f%%',x/NbrePts*100))

% Update the Fractional Length of the Waitbar 
set(h,'UserData',x+1)