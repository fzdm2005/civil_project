function rot = rotate_curve(data, referencePoint, angle)

M=[1    0     referencePoint(1);
   0    1     referencePoint(2);
   0    0     1;];                                  %translate matrix
P0(1,:)=data(:,1);
P0(2,:)=data(:,2);
P0(3,:)=1;
M1=[cos(angle)   sin(angle)     0;
    -sin(angle)   cos(angle)    0;
        0           0         1];                   %rotate matrix
rot = M1*M*P0;
rot = rot';
