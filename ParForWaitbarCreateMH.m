function [hWaitbar,hWaitbarMsgQueue]= ParForWaitbarCreateMH(Msg,NbrePts)

% Create the Waitbar
hWaitbar = waitbar(0,Msg, 'windowstyle', 'modal');

% Initialize the Fractional Length of the Waitbar 
set(hWaitbar,'UserData',0)

info = ver('parallel');%Empty if parallel computing toolbox is not installed

if ~isempty(info)
    % Calling the constructor  for a DataQueue to enable sending data from
    % workers back to the client in a parallel pool
    hWaitbarMsgQueue = parallel.pool.DataQueue;

    % Define a function to call when new data is received
    hWaitbarMsgQueue.afterEach(@(x)ParForWaitbarProgressMH(hWaitbar,NbrePts,Msg));
else
    hWaitbarMsgQueue = NoParallelUpdater(hWaitbar, NbrePts, Msg);
end