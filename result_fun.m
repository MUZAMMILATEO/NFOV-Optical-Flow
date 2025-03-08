function [data_array, new_u, new_v,Err_f] = result_fun(image_num,case_var,methodvar,curlvar,alpha_ord,lambdaVar,frame1,frame2)

% initialize parameters for register_images.m (see comment in register_images.m)
J=4; % scale needs to be chosen depends on features present in image
mag_th=5; % smaller threshold -> more coefficients set to zero
r_th=0.4;% larger threshold -> more coefficients set to zero
js=3; % scale needs to be chosen depends on features present in image
%js=1; % scale needs to be chosen depends on features present in image   
interp_option='bilinear';%'bilinear';%'nearest';

%k=6
data_array = zeros(1,15);                     %%%%%%%%%%%%%%%%%%%%%%%% To store the parameters of interest %%%%%%%%%%%%%%%%%%%%%%%%  
k=6;                                          %%%%%%%%%%%%%%%%%%%%%%%% 1=MAG_DEV 2=ANG-DEV 3=MEAN_MAG 4=FULL_MAG 5=aVG_ANG_ERROR 6=STD_AAE 7=AVG_ERR 8=DETAILCOEFFICIENT 9=LAMBDA 10=CURLAMBDA%%%%%%%%%%%%%%%%%%%%%%%%
text_0='start';                               %%%%%%%%%%%%%%%%%%%%%%%% 11=AEE 12=AME 13=NAME 14=ENG 15=RMS %%%%%%%%%%%%%%%%%%%%%%%%
%disp(['k=',num2str(k)]);
disp(text_0);
    filePath = ['data' filesep]; % or the folder that you save the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   *********************************   %%%%%%%%%%%%%%%%%%%%%%%%
    % seqName=middle-veal;     %%%%%%%%%%%%   Check for the synthetic image
% sequence   %%%%%%%%%%%%%%%%%%%   Push %%%%%
% switch seqName
%%%%%%%%%%%%%%%% for PNG data format %%%%%%%%%%%%%%%%
if case_var == 0
         filePrefex = [filePath 'eval-data\'];
         
         flowFolder = {'Army',  'Mequon', 'Schefflera', 'Wooden',  'Grove', 'Urban', ...                                        %1
                       'Yosemite',  'Teddy', 'Basketball',  'Evergreen',  'Backyard',  'Dumptruck', ...                         %7
                       'Child', 'Tortoise', 'Fish', 'SwimBaby', 'Tsukuba', 'Walking', ...                                       %13
                       'Beanbags', 'DogDance', 'MiniCooper', 'FileMade', 'Thermal_Men', 'Hom', ...                              %19
                       'Army_001', 'Army_002', 'Army_003', 'Army_004', 'Army_005', 'Army_006', ...                              %25
                       'Army_007', 'Army_008', 'Army_009', 'Mequon_001', 'Mequon_002', 'Mequon_003', ...                        %31
                       'Mequon_004', 'Mequon_005', 'Mequon_006', 'Mequon_007', 'Mequon_008', 'Mequon_009', ...                  %37
                       'Wooden_001', 'Wooden_002', 'Wooden_003', 'Wooden_004', 'Wooden_005', 'Wooden_006', ...                  %43
                       'Wooden_007', 'Wooden_008', 'Wooden_009', 'Teddy_001', 'Teddy_002', 'Teddy_003', ...                     %49
                       'Teddy_004', 'Teddy_005', 'Teddy_006', 'Teddy_007', 'Teddy_008', 'Teddy_009', ...                        %55
                       'DogDance_001', 'DogDance_002', 'DogDance_003', 'DogDance_004', 'DogDance_005', 'DogDance_006', ...      %61
                       'DogDance_007', 'DogDance_008', 'DogDance_009', 'Walking_001', 'Walking_002', 'Walking_003', ...         %67
                       'Walking_004', 'Walking_005', 'Walking_006', 'Walking_007', 'Walking_008', 'Walking_009', ...            %73
                       'Fish_001', 'Fish_002', 'Fish_003', 'Fish_004', 'Fish_005', 'Fish_006', ...                              %79
                       'Fish_007', 'Fish_008', 'Fish_009', 'Tortoise_001', 'Tortoise_002', 'Tortoise_003', ...                  %85
                       'Tortoise_004', 'Tortoise_005', 'Tortoise_006', 'Tortoise_007', 'Tortoise_008', 'Tortoise_009', ...      %91
                       'Hom_001', 'Hom_002', 'Hom_003', 'Hom_004', 'Hom_005', 'Hom_006', ...                                    %97
                       'Hom_007', 'Hom_008', 'Hom_009', 'Mans_001', 'Mans_002', 'Mans_003', ...                                 %103
                       'Mans_004', 'Mans_005', 'Mans_006', 'Mans_007', 'Mans_008', 'Mans_009', ...                              %109
                       'RubikCube_001',  'RubikCube_002', 'RubikCube_003', 'RubikCube_004', 'RubikCube_005', 'RubikCube_006', ...%115
                       'RubikCube_007', 'RubikCube_008', 'RubikCube_009', 'Heart_001', 'Heart_002', 'Heart_003', ...            %121
                       'Heart_004', 'Heart_005', 'Heart_006', 'Heart_007', 'Heart_008', 'Heart_009'};                           %127
                   
         imfilename1 = 'frame10.png';
         imfilename2 = 'frame11.png';
         iSeq=image_num;
         im1=imread([filePrefex flowFolder{iSeq} filesep imfilename1]);
         im2=imread([filePrefex flowFolder{iSeq} filesep imfilename2]);
         if size(im1,3)>1
         im1=rgb2gray(im1);
         im2=rgb2gray(im2);
         end
         A1=double(im1);
         B1=double(im2);
         no_ground_data = 1;
%%%%%%%%%%%%%%%% for PNG data format %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% for JPG data format %%%%%%%%%%%%%%%%
elseif case_var == 1
         %filePrefex = [filePath 'eval-data\'];
         
         flowFolder = {'Data1','SkateBoarding', 'HorseRiding', 'RoadWalk', 'SqFrames', 'RndmFile', 'Thermal_Face', 'Thermal_Walk'};          
         iSeq=image_num;
         FileNit = strcat('C:\Users\acer\Desktop\DATA_Smoke(Raw)\Smoke\',flowFolder{iSeq});
         framePath1 = [FileNit filesep frame1];
         framePath2 = [FileNit filesep frame2];
         framePath1 = strcat(framePath1,'.jpg');
         framePath2 = strcat(framePath2,'.jpg');
         
         im1 = imread(framePath1);
         im2 = imread(framePath2);
                
         if size(im1,3)>1
         im1=rgb2gray(im1);
         im2=rgb2gray(im2);
         end
         A1=double(im1);
         B1=double(im2);
         no_ground_data = 1;
%%%%%%%%%%%%%%%% for JPG data format %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% for JPEG data format %%%%%%%%%%%%%%%%
elseif case_var == 2
         filePrefex = [filePath 'eval-data\DATA(N)\Image\Fire'];
         
         flowFolder = {'Lung_JPEG'};          
            
             imfilename1 = 'frame10.jpeg';
             imfilename2 = 'frame11.jpeg';
         iSeq=image_num;
         im1=imread([filePrefex flowFolder{iSeq} filesep imfilename1]);
         im2=imread([filePrefex flowFolder{iSeq} filesep imfilename2]);
         if size(im1,3)>1
         im1=double(rgb2gray(im1));
         im2=double(rgb2gray(im2));
         end
         A1=im1;
         B1=im2;
         no_ground_data = 1;
%%%%%%%%%%%%%%%% for JPEG data format %%%%%%%%%%%%%%%%
 
%%%%%%%%%%%%%%%% for TIF data format %%%%%%%%%%%%%%%%
elseif case_var == 3
         filePrefex = [filePath 'eval-data\'];
         
         flowFolder = {'Fluid_04','Yosemite_Clouds', 'RubikCube'};          
         
         imfilename1 = 'frame10.tif';
         imfilename2 = 'frame11.tif';
         iSeq=image_num;
         im1=imread([filePrefex flowFolder{iSeq} filesep imfilename1]);
         im2=imread([filePrefex flowFolder{iSeq} filesep imfilename2]);
         if size(im1,3)>1
         im1=double(rgb2gray(im1));
         im2=double(rgb2gray(im2));
         end
         A1=double(im1);
         B1=double(im2);
         no_ground_data = 1;
%%%%%%%%%%%%%%%% for TIF data format %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% for TIFF data format %%%%%%%%%%%%%%%%
elseif case_var == 4
         filePrefex = [filePath 'eval-data\'];
         
         flowFolder = {'Heart'};
         
         imfilename1 = 'frame10.tiff';
         imfilename2 = 'frame11.tiff';
         iSeq=image_num;
         im1=imread([filePrefex flowFolder{iSeq} filesep imfilename1]);
         im2=imread([filePrefex flowFolder{iSeq} filesep imfilename2]);
         if size(im1,3)>1
         im1=rgb2gray(im1);
         im2=rgb2gray(im2);
         end
         A1=double(im1);
         B1=double(im2);
         no_ground_data = 1;
%%%%%%%%%%%%%%%% for TIFF data format %%%%%%%%%%%%%%%%



%%%%%%%%%%%%%  resize the images 
       
%       A1=imresize(im1,[384 384]);     %%%%%%%%%%%%%%%%%%% To Resize the image of divisible by 8 Just for check the code for this, not  ...... 
%       B1=imresize(im2,[384 384]);
%         % GT not available
%         D1_c = nan(size(A1));     
%         D2_c = D1_c; 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filePrefex = [filePath 'other-data/'];  Check for the synthetic image
% sequence   %%%%%%%%%%%%%%%%%%% Pushp  %%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%  uncomment the lines form 55 to 384 to run the code
%         for other datasets of Middlebury image sequences....
% % case 'middle-other'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif case_var == 5
    imgFilePath     = [filePath 'other-data' filesep];        
        flowFilePath    = [filePath 'other-gt-flow' filesep];        

        subPath = {'Venus', 'Dimetrodon',   'Hydrangea',    'RubberWhale',...                       %1
                    'Grove2', 'Grove3', 'Urban2', 'Urban3', ...                                     %5
                    '015_YoesmiteSun' '016_GroveSun', 'Crates1', 'Sponza2',...                      %9
                    'Robot', 'GrassSky0', 'Rods', 'DropTxT',...                                     %13
                    'RollBall', 'TextMovement', 'BlowTxT', 'RollBall1' ...                          %17
                    'Sponza1', 'RodFall', 'BrickBox1', 'StreetTxT', ...                             %21
                    'TxTMovement1', 'Yosemite_001', 'Yosemite_002', 'Yosemite_003', ...             %25
                    'Yosemite_004', 'Yosemite_005', 'Yosemite_006', 'Yosemite_007', ...             %29
                    'Yosemite_008', 'Yosemite_009', 'Yosemite_01', 'Venus_001', ...                 %33
                    'Venus_ 002', 'Venus_003', 'Venus_004', 'Venus_005', ...                         %37
                    'Venus_006', 'Venus_007', 'Venus_008', 'Venus_009' ...                          %41
                    'Grove3_001', 'Grove3_002', 'Grove3_003', 'Grove3_004', ...                     %45
                    'Grove3_005', 'Grove3_006', 'Grove3_007', 'Grove3_008', ...                     %49
                    'Grove3_009', 'Hydrangea001', 'Hydrangea002', 'Hydrangea003', ...               %53
                    'Hydrangea004', 'Hydrangea005', 'Hydrangea006', 'Hydrangea007', ...             %57
                    'Hydrangea008', 'Hydrangea009', 'Grove_Sun_001', 'Grove_Sun_002', ...           %61
                    'Grove_Sun_003', 'Grove_Sun_004', 'Grove_Sun_005', 'Grove_Sun_006', ...         %65
                    'Grove_Sun_007', 'Grove_Sun_008', 'Grove_Sun_009', 'Grove_Sun_009', ...         %69
                    'Dimetrodon_001', 'Dimetrodon_002', 'Dimetrodon_003', 'Dimetrodon_004', ...     %73
                    'Dimetrodon_005', 'Dimetrodon_006', 'Dimetrodon_007', 'Dimetrodon_008', ...     %77
                    'Dimetrodon_009', 'Urban3_001', 'Urban3_002', 'Urban3_003', ...                 %81
                    'Urban3_004', 'Urban3_005', 'Urban3_006', 'Urban3_007', ...                     %85
                    'Urban3_008', 'Urban3_009' ,'RollBall_001', 'RollBall_002', ...                 %89
                    'RollBall_003', 'RollBall_004', 'RollBall_005', 'RollBall_006', ...             %93
                    'RollBall_007', 'RollBall_008', 'RollBall_009', 'BlowTxT_001', ...              %97
                    'BlowTxT_002', 'BlowTxT_003', 'BlowTxT_004', 'BlowTxT_005', ...                 %101
                    'BlowTxT_006', 'BlowTxT_007', 'BlowTxT_008', 'BlowTxT_009', ...                 %105
                    'DropTxT_001', 'DropTxT_002', 'DropTxT_003', 'DropTxT_004', ...                 %109
                    'DropTxT_005', 'DropTxT_006', 'DropTxT_007', 'DropTxT_008', ...                 %113
                    'DropTxT_009', 'Yosemite_01', 'Yosemite_02', 'Yosemite_03', ...                 %117
                    'Yosemite_04', 'Yosemite_05', 'Yosemite_06', 'Yosemite_07', ...                 %121
                    'Yosemite_08', 'Yosemite_09', 'Grove2_001', 'Grove2_002', ...                   %125 
                    'Grove2_003', 'Grove2_004', 'Grove2_005', 'Grove2_006', ...                     %129
                    'Grove2_007', 'Grove2_008', 'Grove2_009', 'Urban2_001', ...                     %133 
                    'Urban2_002', 'Urban2_003', 'Urban2_004', 'Urban2_005', ...                     %137
                    'Urban2_006', 'Urban2_007', 'Urban2_008', 'Urban2_009', ...                     %141   
                    'Ambush', 'Bamboo', 'Bamboo1', 'Market2', ...                                   %145 
                    'Mountain_1', 'Temple_3', 'Cave_2', ' n_1',...                                  %149
                    'Alley_1','Venus_PN'};                                                                                    
                    
        iSeq=image_num;
        img1Filename = [imgFilePath subPath{iSeq} filesep 'frame10.png']; %%%%%%%%% For iSeq 1 to 12 and 19, 21 set frame10.png and frame11.png %%%%%%%%%
        img2Filename = [imgFilePath subPath{iSeq} filesep 'frame11.png']; %%%%%%%%% For iSeq 13,14,15,16,18 leave it as it is and for 17,20 and 22 set frame10.jpg and frame11.jpg%%%%%%%%     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        A1=imread(img1Filename);
        B1=imread(img2Filename);
        if size(A1,3)>1
           A1=rgb2gray(A1);
           B1=rgb2gray(B1);
        end
        A1=double(A1);
        B1=double(B1);
        no_ground_data=0; 
           
end
        %%%%%%%%%%%%%%%% Evaluation of DETAIL COEFFICIENT %%%%%%%%%%%%%%%%
%         lmbdanew=correlationest(A1,B1);
%         [new_im1 new_im2] = reshape_for_crosscorr(A1,B1,21);
%         [new_cell_1 new_cell_2] = create_cell_of_grids(new_im1,new_im2,21);
%         [corr_mat] = cell_cross_corr(new_cell_1,new_cell_2,9,21);
%         [new_mat] = expand_array(corr_mat,21);
%         [norm_det] = create_norm_detail(new_im1,21);
%         lambda_mat = new_mat.*norm_det;
%         lambda_mat = imresize(lambda_mat,[384 384]);
%         lambda_mat = mat2gray(lambda_mat);
%         lambda_mat = 3840*lambda_mat;
%         
%         data_array(8)=lmbdanew;                             %%%%%%%%%%%%%%% -1 shows that corresponding data_array value has no meaning %%%%%%%%%%%%%%%
        %data_array(9)=600*abs(-0.87384 + 4.0672*lmbdanew);%-354.7 + 2401.0*lmbdanew;%-330.8+2325.2*lmbdanew;%10*exp(10*lmbdanew); 
        lmbdanew=lambdaVar;
        lambda_mat=lambdaVar;
        ImageData1 = A1;
        ImageData2 = B1;
  %  % % Just for squaring the image size %%%%%% Not involved any input or variable %%%%%%%
        [N1,M1]=size(A1); % original image size
        S=2^ceil(log2(max(N1,M1))); % specify image size
    %   put both the above 2 lines only for other image like yosemite image    
      [sizeX,sizeY] = size(A1);
      if image_num>144
          number = 1;
          A1=imresize(A1,[round(sizeX/number),round(sizeY/number)]);
          B1=imresize(B1,[round(sizeX/number),round(sizeY/number)]);
      else
          A1=imresize(A1,[384 384]);     %%%%%%%%%%%%%%%%%%% To Resize the image of divisible by 8 Just for check the code for this, not  ......
          B1=imresize(B1,[384 384]);    
      end
        if no_ground_data == 0
            
            % Read in ground truth flow fields
            flowFilename = [flowFilePath subPath{iSeq} filesep 'flow10.flo'];
            flow1 = readFlowFile(flowFilename,iSeq);
            D1_c = flow1(:,:,1);
            D2_c = flow1(:,:,2);
            D1_c_copy = D1_c;
            D2_c_copy = D2_c;
            %%%%% resize coreect 
            if image_num>144
                [M_c, N_c] = size(D1_c);
                if M_c>N_c
                    ratioC = round(M_c/N_c);
                    D1_c=imresize(D1_c,[48*ratioC 48]);
                    
                    D2_c=imresize(D2_c,[48*ratioC 48]);
                else
                    ratioC = round(N_c/M_c);
                    D1_c=imresize(D1_c,[48 48*ratioC]);
                    D2_c=imresize(D2_c,[48 48*ratioC]);
                end
            else
                
                D1_c=imresize(D1_c,[48 48]);     %%%%%%%%%%%%%%%%%%% To Resize the image of divisible by 8 Just for check the code for this not  ......
                D2_c=imresize(D2_c,[48 48]);     
            end
            
            % Set unknown values to nan
            UNKNOWN_FLOW_THRESH = 1e9; 
            D1_c (D1_c>UNKNOWN_FLOW_THRESH) = NaN;
            D2_c (D2_c>UNKNOWN_FLOW_THRESH) = NaN;
            D1_c_copy (D1_c_copy>UNKNOWN_FLOW_THRESH) = NaN;
            D2_c_copy (D2_c_copy>UNKNOWN_FLOW_THRESH) = NaN;
        else
            
            % GT not available
            D1_c = nan(size(A1));
            D2_c = D1_c; 
        end;
% %  figure('Name','im1')
% imshow(uint8(A1))
% figure('Name','im2'), axis off;
% imshow(uint8(B1))
% figure('Name','D1_c'), axis off;
% imshow(D1_c)
% figure('Name','D2_c'), axis off;
% imshow(D2_c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555555555555555555555555
    seq_n1=k;
    seq_n2=k+1;
    A_o=A1;     
    B_o=B1;   
    A=A1;
    B=B1;
   [N1,M1]=size(A1);          
%% for addition of noise from lines 141 to 142
    A=A1;   % for no noise
    B=B1;   % for no noise

% %   
      if image_num>144
          A=imresize(A,[round(sizeX/number),round(sizeY/number)]);
          B=imresize(B,[round(sizeX/number),round(sizeY/number)]);
      else
          A=imresize(A,[384 384]);     %%%%%%%%%%%%%%%%%%% To Resize the image of divisible by 8 ......
          B=imresize(B,[384 384]);     %%%%%%%%%%%%%%%%%%% To Resize the image of divisible by 8 ...... 
      end
       [N,M]=size(A); % new image size after adjustment
%     
    figure(4); subplot(121); image(A); axis image; colormap(gray(384)); axis off;
    title('Reference Image A');
    subplot(122); image(B); axis image; colormap(gray(384)); axis off;
    title('Target Image B');
    
    tic;
   [D1_est,D2_est, color_u, color_v, del_val, partfx, partfy, new_u, new_v, orig_u, orig_v]=register_lateo(A,B,lmbdanew,methodvar,curlvar,lambda_mat,alpha_ord,lambdaVar);
   data_array(10)=del_val;
    % convert to orientation suitable for plotting over image
    %D1_plot(:,:,k) = (D1_est);                     %%%%%%%%%%%%%%%%%%% Uncommentting this part increases the time complexity due to memory %%%%%%%%%%%%%%%%%%%% 
    %D2_plot(:,:,k) = (D2_est);                     %%%%%%%%%%%%%%%%%%% allocation for an array of size k in third dimension and also in overwriting the first assignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %     % read and compare correct flows
% % %     if (~isempty(correct_flow_s))
% %         [D1_c,D2_c]=read_correct_flows(correct_flow_s);  %%%%%  For other
% %         code given by other auther  ::::  %%%%%%%%%%%%%%
%         
        %D1_c=D1_c*(seq_n2-seq_n1);                   %%%%%%%%%%%%%%%%%%%% Uncomment this part if the frames used are not consecutive ones %%%%%%%%%%%%%%%%%%%%
        %D2_c=D2_c*(seq_n2-seq_n1);                   %%%%%%%%%%%%%%%%%%%% and the ground flow is needed to be stretched the number of times the difference between the two frames %%%%%%%%%%%%%%%%%%%%
%         
% %         
%         %% convert to orientation suitable for plotting over image
        %          D1_c = fliplr(D1_c);
        %          D2_c = fliplr(D2_c);
        if case_var == 5
            D1_c = rot90(fliplr(D1_c));
            D2_c = rot90(fliplr(D2_c));
            D1_c_copy = rot90(fliplr(D1_c_copy));
            D2_c_copy = rot90(fliplr(D2_c_copy));
            [color_m, color_n] = size(color_u);
            D1_c_copy = imresize(D1_c_copy,[color_m color_n]);
            D2_c_copy = imresize(D2_c_copy,[color_m color_n]);
            D1_c_r0 = D1_c;
            D2_c_r0 = D2_c;
            [orig_m orig_n] = size(D1_c_r0);
            D1_est_r0 = imresize(orig_u,[orig_m orig_n]);
            D2_est_r0 = imresize(orig_v,[orig_m orig_n]);
        end
        [D1_err,D2_err,D1_c_r,D2_c_r,D1_est_r,D2_est_r, AEE, AME, NAME, ENG, RMS]=calculate_error_flows(ImageData1,ImageData2,flipud(D1_est),flipud(-D2_est),D1_c,D2_c,N,M,N1,M1,js,partfx,partfy);
        
        data_array(11) = AEE;
        data_array(12) = AME;
        data_array(13) = NAME;
        data_array(14) = ENG;
        data_array(15) = RMS;
        % calculate and display angular errors
        if case_var == 5
            [phif,stf,phic,stc,Ef,Ecfin,Err_f]=eval_flow(D1_est_r,D2_est_r,D1_c_r,D2_c_r);
            fprintf ('Angular error (full): %.4f deg (%.4f deg)\n', phif, stf) 
            avg_ang_err=phif;
            data_array(5)=avg_ang_err;
            std_ang_err=stf;
            avg_err1=mean((D1_est_r(:)-D1_c_r(:)).^2);
            avg_err2=mean((D2_est_r(:)-D2_c_r(:)).^2);
            avg_err1 = mean(abs(D1_est_r(:)-D1_c_r(:)));
            avg_err2 = mean(abs(D2_est_r(:)-D2_c_r(:)));
        
            fprintf('Average l_2 error (d_1,d_2): (%.4f, %.4f)\n', avg_err1, avg_err2) % not so good estimates cos algorithm only based on two images
        else
            data_array(5)=NaN;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [x,y]=size(D1_est_r);
        [Y,X]=meshgrid(1:y,1:x);
        figure(27);
        quiver(Y,X,(D1_c_r),(D2_c_r),'b');
        axis image;
        hold on;
        quiver(Y,X,D1_est_r,D2_est_r,'r'); hold off;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [M_s, N_s] = size(D1_est_r);
        if M_s<N_s
            ratio = round(N_s/M_s);
            D1_est0 = imresize(D1_est_r,[20 20*ratio]);
            D2_est0 = imresize(D2_est_r,[20 20*ratio]);
            D1_c = imresize(D1_c_r,[20 20*ratio]);
            D2_c = imresize(D2_c_r,[20 20*ratio]);
        else
            ratio = round(M_s/N_s);
            D1_est0 = imresize(D1_est_r,[20*ratio 20]);
            D2_est0 = imresize(D2_est_r,[20*ratio 20]);
            D1_c = imresize(D1_c_r,[20*ratio 20]);
            D2_c = imresize(D2_c_r,[20*ratio 20]);
        end
        [x,y]=size(D1_est0);
        [Y,X]=meshgrid(1:y,1:x);
        figure(30);
        quiver(Y,X,(D1_c),(D2_c),'b');
        axis image;
        hold on;
        quiver(Y,X,D1_est0,D2_est0,'r'); hold off;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        [x,y]=size(D1_est_r);
        [Y,X]=meshgrid(1:y,1:x);
        figure(5);
        quiver(Y,X,(D1_c_r),(D2_c_r),'b');
        axis image;
        hold on; quiver(Y,X,D1_c_r,D2_c_r,'b'); hold off;
        title('Correct Disparity Flow (Ground Truth)');
        %%%%%%%%%%%%%%%%%% Uncomment close all section if Ground TRuth Flow is provided %%%%%%%%%%%%%%%%%%%
        [mean(mean(D1_est_r)) mean(mean(D1_c_r))];
        D1_err(D1_est_r==0)=0;
        D2_err(D2_est_r==0)=0;
        % % plot error flows
        figure(6); image(A_o); colormap(gray(384)); axis image; axis off;
        title('Disparity Estimation Error');
        hold on;
        [N2,M2]=size(D1_err);
        [Y,X]=meshgrid([0:M2-1]*2^js+1,[0:N2-1]*2^js+1);
        quiver(Y,X,(D1_err),(-D2_err),'b'); axis image; axis off;;           %%%%%%%%%%%% quiver(X,Y,(D1_err),(-D2_err),'b'); axis image; axis off; %%%%%%%%%%%%
        hold off;
        %%%%%%%%%%%%%%%%%%%%Uncomment plot error flows section if Ground Truth Flow is provided%%%%%%%%%%%%%%%%%%%%%%%%%
        [N_err,M_err] = size(D1_err);
        [N_e,M_e] = size(D1_est);
        % Calculate average error and percentage error (what is a good indicator/metric?)
        avg_err = sqrt(sum(sum(D1_err.^2+D2_err.^2)))/N_err/M_err;
        data_array(7)=avg_err;
        per_err = avg_err/mean(mean(sqrt(D1_c.^2+D2_c.^2)));
        D1_c_r=imresize(D1_c_r,[N_e M_e]);
        D2_c_r=imresize(D2_c_r,[N_e M_e]);
        if case_var == 5
            data_array(6)=stf;
        else
            data_array(6)=NaN;
            Err_f = NaN;
        end
flow(:,:,1) = color_u;
flow(:,:,2) = color_v;
imflow = flowToColor(flow);
figure(200); imshow(imflow(:,:,1),[])
figure(201); imshow(imflow(:,:,2),[])
figure(202); imshow(imflow(:,:,3),[])
%%%%%%%%Write Image%%%%%%%%

%%%%%%%%Write Image%%%%%%%%
figure(11);imshow(imflow);
[f1,f2]=size(flow(:,:,1));
%flow(:,:,1) = flipud(imresize(D1_c,[f1 f2]));    %%%%%%% Comment this line for real image sequences
%flow(:,:,2) = flipud(imresize(D2_c,[f1 f2]));   %%%%%%% Comment this line for real image sequences
%imflow = flowToColor(flow);                     %%%%%%% Uncomment this line if Ground Truth Flow is provided
%figure(12);imshow(imflow);                      %%%%%%% Uncomment this line if Ground Truth Flow is provided
D1_real= D1_est;
D2_Img=D2_est*sqrt(-1);
Cmplx=D1_real+D2_Img;
theta_Cmplx=angle(Cmplx);
angular_std_Cmplx=std(theta_Cmplx(:));
data_array(2)=angular_std_Cmplx;
full_mag=sum(sqrt((D1_est(:)).^2+(D2_est(:)).^2));
data_array(4)=full_mag;
mean_final=mean(sqrt((D1_est(:)).^2+(D2_est(:)).^2));
data_array(3)=mean_final;
std_square=sqrt(D1_est.^2+D2_est.^2);
std_final=std(std_square(:));
data_array(1)=std_final;
psnr1=psnr(D1_est,D1_c_r);    %%%%%%%%%%%% Comment all these psnr lines for real image sequences
psnr2=psnr(D2_est,D2_c_r);    
psnr_final=(psnr1+psnr2)/2;   %%%%%%%%%%%% Comment all these psnr lines for real image sequences 
toc;