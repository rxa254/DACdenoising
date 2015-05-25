f=zeros(1,100);
x1=zeros(1,100);
x=zeros(1,100);
Q=zeros(1,100);
e=zeros(1,100);
for i=1:1:10000
     
        f(1,i)=i*0.01;
            
end
for i=1:1:10000
    x=f(1,i);
    Q(1,i)=1*(floor(x)+0.5);
    x1=Q(1,i);
    e(1,i)=x-x1;
end
l=0:0.01:99.99;
%p=length(l)
%q=length(f)
%plot(x,Q)   
plot(l,f,'r');hold on;plot(l,Q,'b');hold off
grid on
Y=rms(e)
