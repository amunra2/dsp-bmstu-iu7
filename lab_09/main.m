function main()
    I=double(imread('bimage4.bmp')) / 255;
    
    figure;
    imshow(I); 
    title('Source image');
    
    PSF=fspecial('motion', 54, 66);
    J1=deconvblind(I, PSF);
    
    figure;
    imshow(J1);
    title('Recovered image');
end
