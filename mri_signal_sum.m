function [s, M] = mri_signal_sum(Mstart, M0z, gamma, coords, T1, T2, fs, events, nrecordings, px, progress)
n_inputpx = size(coords, 2);
Mstart = Mstart./repmat(M0z, 3, 1); %Normalize for numerical accuracy
M0zn = M0z./max(M0z);
M = Mstart;
T2_relaxation = 1./(T2*fs);
T1_relaxation =  1./(T1*fs);
ind = 1;
eventstart = 1;
B1 =[];
Grad =zeros(3,0);
i = 1;

while true
    [next, running, eventstart] = updateEvents(events, ind, eventstart);
    if next < 0
        %next = n;
        break;
    end
    B1(i) = 0;
    Grad(:, i) = 0; 
    GradOffset(i) = 0; 
    for j = running
        if events(j).type == EventType.B1
            B1(i) = events(j).amplitude;           
        elseif events(j).type == EventType.Gradient
            Grad(events(j).axis, i) = events(j).amplitude;
            GradOffset(i) = GradOffset(i) + events(j).offset;
        else %Recording
            isrecording(i) = true;
        end
    end
    
    nsamples(i) = next - ind;
    ind = next;
    i = i + 1;
end

%updateWaitbar = waitbarParfor(n_inputpx/100, "Calculation in progress...");
result = zeros(nrecordings, px, 'like', 1i);
parfor k = 1:n_inputpx
    n = length(B1);
    pixelimage = zeros(nrecordings, px, 'like', 1i);
    recordingno = 1;
    for i = 1:n
        B = [real(B1(i));imag(B1(i));Grad(:,i)'*coords(:,k) + GradOffset(i)];
        bnorm = norm(B);
        if ~isrecording(i)
            if bnorm ~= 0
                omega = -2*pi*gamma * bnorm;
                R = rotmat(nsamples(i)*omega/fs, B);
                M(:, k) = R*M(:,k);
            end
            M(:, k) = relax(M(:, k), T1(k), T2(k), M0zn(k), nsamples(i)/fs);
        else
            om = 0;
            if bnorm ~= 0
                om = -2*pi*gamma * bnorm;
                Rot = rotmat(om/fs, B);                
            end

            m = M(:, k);

            sr = zeros(px, 1, 'like', 1i);
            for j = 1:px
                if om ~= 0
                    m = Rot* m;
                end
                m(1) = m(1) - m(1) * T2_relaxation(k);
                m(2) = m(2) - m(2) * T2_relaxation(k);
                m(3) = m(3) - (m(3) - M0zn(k)) * T1_relaxation(k);
                sr(j) = m(1) + 1i*m(2);
            end
            M(:, k) = m;
            pixelimage(recordingno, :) = sr;
            recordingno = recordingno + 1;
        end      
    end
    result = result + pixelimage;
     if mod(k, 1000) == 1
        progress.send(0);
     end
end
s = result;

end

function [nextind, running, first] = updateEvents(events, ind, first)
running =[];
nextind = 1e+10;
k = first;
events(k).update(ind);
someNotDone = false;
while events(k).started
    if ~events(k).done
        evnext = events(k).endTime;
        running(end + 1) = k;
        if evnext < nextind
            nextind = evnext;
        end
        someNotDone = true;
    elseif ~someNotDone
        first = k + 1;
    end
    k = k + 1;
    if k > length(events)
        if nextind == 1e+10
            nextind = -1;
        end
        return;
    end
    events(k).update(ind);
end
if events(k).startTime < nextind
    nextind = events(k).startTime;
end
if nextind == 1e+10
    nextind = -1;
end
end



function v = relax(v, T1, T2, M0zn, t)
expT2 = exp(-t/T2);
v(1) = v(1) * expT2;
v(2) = v(2) * expT2;
v(3) = M0zn - ((M0zn - v(3)) * exp(-t/T1));
end