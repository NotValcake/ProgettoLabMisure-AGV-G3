%% IMPORT DATA

PATH = "../Tests/20231201/02_preprocessing";

% Translation along x axis 
DATASET_ARUCO = readtable(PATH+"/POSE_DATA___ARUCO_2023_12_01_11_14_05.csv");
DATASET_ODOMETRY = readtable(PATH+"/POSE_DATA__2023_12_01_11_14_05.csv");
%% DATA PREPARATION

[~,framesindex] = unique(DATASET_ARUCO.frame);
filtered_aruco = DATASET_ARUCO(framesindex,:);

idx = ismember(DATASET_ODOMETRY.frame,DATASET_ARUCO.frame);
filtered_odom = DATASET_ODOMETRY(idx,:);

% Since odometry measures are in m and aruco measures are in mm, and odometry
% sets the starting point as origin, we need to apply the starting offset and 
% multiply by 1000
filtered_odom_z = filtered_odom.z.*1000+filtered_aruco.z(1);

%% REGRESSION

% Example code for uncertainty calculation
% opt = fitoptions('Method', 'LinearLeastSquares');
% [aruco_model, gof_ar, out_ar] = fit(DATASET_ARUCO.x,DATASET_ARUCO.z,'Poly1',opt);
% [odom_model, gof_odom, out_odom] = fit(DATASET_ODOMETRY.x,DATASET_ODOMETRY.z,'Poly1',opt);
% 
% sigma = [sqrt(gof_ar.sse/(height(filtered_aruco)-out_ar.numparam))
%          sqrt(gof_odom.sse/(height(filtered_odom)-out_odom.numparam))*1000];

%% CLT FUSION

sigma_ar = readmatrix("../Tests/20231201/04_results/Uaruco.csv");
sigma_odom = readmatrix("../Tests/20231201/04_results/Uodometry.csv");
sigma = [sigma_ar(1,1), sigma_odom(1,1)];
[zf, sigmazf] = clt([filtered_aruco.z,filtered_odom_z], sigma);

%% PLOT RESULTS

plot(zf,'*r',DisplayName="FusedData")
hold on
axis equal
plot(filtered_aruco.z,'ob',DisplayName="ArucoData")
plot(filtered_odom_z,'+k',DisplayName="OdometryData")
title("CLT Fusion")
legend
