function P = spin_echo_post_process(P)
    P = ifft2(P);
    P = abs(fftshift(P));             
    P = flipud(P);
end