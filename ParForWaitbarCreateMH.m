function [hWaitbar,hWaitbarMsgQueue]= ParForWaitbarCreateMH(Msg,NbrePts)

% Create the Waitbar
hWaitbar = waitbar(0,Msg, 'windowstyle', 'modal');

% Initialize the Fractional Length of the Waitbar 
set(hWaitbar,'UserData',0)

% Calling the constructor  for a DataQueue to enable sending data from
% workers back to the client in a parallel pool
hWaitbarMsgQueue = parallel.pool.DataQueue;

% Define a function to call when new data is received
hWaitbarMsgQueue.afterEach(@(x)ParForWaitbarProgressMH(hWaitbar,NbrePts,Msg));