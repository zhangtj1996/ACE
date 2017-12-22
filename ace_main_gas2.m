function [psi,phi]=ace_main_gas(x,dim,canv)

% Example data ---------------------------------------------
% Demonstration of how ACE finds logarithmic transformations
% Results in blue; green is exp(phi)

ll=length(x(:,1)); % number of data points
%dim=3;  % number of terms on right hand side
wl=5;   % width of smoothing kernel
oi=100; % maximum number of outer loop iterations
ii=10;  % maximum number of inner loop iterations
ocrit=10*eps; % numerical zeroes for convergence test
icrit=1e-4;
shol=1; % 1-> show outer loop convergence, 0-> do not
shil=0; % same for inner loop
% 
% x1=4*rand(ll,1); x2=3*rand(ll,1);
% y=x1.*x2;
%x=[y x1 x2]';
x=x';
% call ace.m  ---------------------------------------------

[psi,phi]=ace(x,ll,dim,wl,oi,ii,ocrit,icrit,shol,shil);

% results -------------------------------------------------

disp(['Estimate of Maximal Correlation = ' num2str(psi)]);

figure(1)
for d=1:dim+1;
    subplot(canv,canv,d);
    plot(x(d,:),phi(d,:),'.');
    hold on;
    plot(x(d,:),exp(phi(d,:)),'g.');
    hold off;
    axis tight;
end;

figure(2);
if dim==1; sum0=phi(2,:); else sum0=sum(phi(2:dim+1,:)); end;
plot(phi(1,:),sum0,'.');
xlabel('\Phi_0'); ylabel('\Sigma \Phi_i'); title('Regression');
%figure(3)
%scatter3(x1,x2,y)

% subroutines --------------------------------------------------

function [psi,phi]=ace(x,ll,dim,wl,oi,ii,ocrit,icrit,shol,shil)

%%%type of variable
% catevar=[]
% for i=1:dim+1
%     if length(unique(x(:,i)))<20
%         catevar=[catevar,[i]];
%     end
% end
%%%
ind=zeros(dim+1,ll);
ranks=zeros(dim+1,ll);
for d=1:dim+1; [~,ind(d,:)]=sort(x(d,:)); end; %ind stores the index of variable from small to big
for d=1:dim+1; ranks(d,ind(d,:))=1:ll; end;   
phi=(ranks-(ll-1)/2.)/ sqrt(ll*(ll-1)/12.);
ieps=1.; oeps=1.; oi1=1; ocrit1=1;
while oi1<=oi && ocrit1>ocrit
    %phi(2:end,:)=zeros(size(phi(2:end,:)));
    ii1=1; icrit1=1;
    while ii1<=ii && icrit1>icrit
        for d=2:dim+1; sum0=0;
            for dd=2:dim+1; if dd ~=d; sum0=sum0+phi(dd,:); end; end; 
            phi(d,:)=cef(phi(1,:)-sum0,ind(d,:),ranks(d,:),wl,ll); %generate phi
        end;
        icrit1=ieps;
        if dim==1; sum0=phi(2,:); else sum0=sum(phi(2:dim+1,:)); end;
        ieps=sum((sum0-phi(1,:)).^2)/ll;
        icrit1=abs(icrit1-ieps);
        if shil; disp(num2str([ii1 ieps icrit1])); end;
        ii1=ii1+1;
    end;
    phi(1,:)=cef(sum0,ind(1,:),ranks(1,:),wl,ll);
    phi(1,:)=(phi(1,:)-mean(phi(1,:)))/std(phi(1,:));
    ocrit1=oeps; oeps=sum((sum0-phi(1,:)).^2)/ll; ocrit1=abs(ocrit1-oeps);
    if shol; disp(num2str([oi1 oeps ocrit1])); end;
    oi1=oi1+1;
end;
psi=corrcoef(phi(1,:),sum0); psi=psi(1,2);

function r=cef(y,ind,ranks,wl,ll) %smoother
cey=win(y(ind),wl,ll);
r=cey(ranks);

function r=win(y,wl,ll)
% wl=0,1,2...
r=conv(y,ones(2*wl+1,1));
r=r(wl+1:ll+wl)/(2*wl+1);
r(1:wl)=r(wl+1); r(ll-wl+1:ll)=r(ll-wl);

