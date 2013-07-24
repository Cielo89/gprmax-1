clear;

name = 'box1';

x = linspace(0,1.2,120);
y = linspace(0,0.6,60);
z = linspace(0,0.65,65);
[xx yy zz] = meshgrid(x,y,z);
[mesh,ID,header,media] = gprmax3g(strcat(name,'.geo'));
figure;
p1=patch(isosurface(xx,yy,zz,mesh,3));
set(p1,'facecolor','red','edgecolor','none');
axis([0.2 1 0 0.6 0 0.65]);
zlabel('长度 (m)');
ylabel('宽度 (m)');
xlabel('深度 (m)');
grid on;
daspect([1 1 1])
       view(3)
       camlight; lighting phong



[Header, Fields] = gprmax(strcat(name,'.out'));
radargram(:,:) = Fields.ez(:,1,:);
t=1e9*Fields.t;
Y = Header.dy * Header.rx: Header.dy * Header.RxStepY :Header.dy * Header.rx + (Header.dy * Header.RxStepY * (Header.NSteps-1));



figure;
imagesc(Y,t,radargram);
title('Ez');
ylabel('Time (ns)');
xlabel('Scan length (m)');

figure;
[x,y]=meshgrid(Y,t);
surf(x,y,radargram,'EdgeColor','none')
view([1,1,0.5]);
title('Ez' );
ylabel('Time (m)');
xlabel('Scan length (m)');


