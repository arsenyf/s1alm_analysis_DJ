function test()



tuning(1,:)=[0:1:5];
tuning(2,:)=[5:-1:0];
tuning(3,:)=[1,2,3,2,1,0];

bins=linspace(0,1,6);

fr_v=[4,1,1]';

%tuning functions
fns_tuning = cell(3,1);
for ii = 1:3
    fns_tuning{ii,1}=@(x)  interp1(bins,tuning(ii,:),x,'linear','extrap');
end

%maximum likelihood function
finalfun =@(x) -fr_v(1)*log(fns_tuning{1,1}(x))+fns_tuning{1,1}(x);
for ii = 2:3
    finalfun =@(x) finalfun(x)-fr_v(ii)*log(fns_tuning{ii,1}(x))+fns_tuning{ii,1}(x);
end
x=[-0.2:0.1:1.2];
y=finalfun(x);

plot(x,y)

%looking for the minimum of a 1D function with a tolerance (how
%small we allow the error to be)
tol=0.1;
xest_a = fminbnd(finalfun,-1,2,optimset('TolX',tol)) ;

            
            
            
            
%            L_a = @(x) -sum(ni_a.*log(fun1(x)) - t(it)*fun1(x)) ;

% 
% %
% % ns_tuning = cell(2,1);
% % for ii = 1:2
% %     fns_tuning{ii,1}= @(x)  interp1(bins,tuning(ii,:),x);
% % end
% %
% 
% 
% fr_v=[1,4,5]';
% 
% finalfun =@(x) fr_v(1)*log(fns_tuning{1,1}(x));
% 
% for ii = 2:3
%     finalfun =@(x) [finalfun+ fr_v(ii)*log(fns_tuning{ii,1}(x)];
% end
% 
% finalfun(2)
% 
% 
% L_a = @(x)      -sum(fr_v.*log(f1(x)) - f1(x)) ;
% 
% 
% 
% 
% 
% % f1 = @(x) fr_v(x)*log(fns_tuning{x}) - fns_tuning{x}
% %
% % f2 =@(k)  -sum(arrayfun(f1,k))
% 
% % f1 = @(i) fns_tuning{i}
% 
% 
% 
% f2 =@(x) arrayfun(f1,[1:1:numel(fr_v)],'UniformOutput',false )
% 
% f2 =@(k)  arrayfun(f1,[1:1:numel(fr_v)],'UniformOutput',false )
% 
% fff=@(K) doublearray(K).*anonymousfunctionarray{K}(x)
% finalfun = @(x) sum(arrayfun, 1:length(doublearray));
% 
% 
% 
% tol=0.1;
% xest_a = fminbnd(f2,0,1,optimset('TolX',tol)) ;
% 
% 
% 
% 
% 
% 
% % f1 = @(x) fns_tuning{x}(fr_v(x))
% % f2 =@(k)  arrayfun(f1,k)
% 
% 
% fr_v=[1,4];
% 
% f1 = @(x)    fr_v(x)*log(fns_tuning{x}) - fns_tuning{x}
% 
% f2 =@(k)  -sum(arrayfun(f1,k))
% 
% 
% xest_a = fminbnd(L_a,0,2*pi,optimset('TolX',tol)) ;
% 
% a=1
% 
% 
% f2(1)
% 
% f2([1;2])
% 
% 
% L_a = @(x)      -sum(fr_v.*log(f1(x)) - f1(x)) ;
% 
% 
% 
% 
% midfun = @(k)   arrayfun(fns_tuning{k},fr_v(k))
% 
% f = @(x)    midfun(x)
% 
% f([1;2])
% 
% finalfun = @(x) sum(     arrayfun(   @(K) fr_v(K).*fns_tuning{K}(x), fr_v  ),1:length(fr_v)   );
% 
% 
% finalfun = @(x) sum(     arrayfun(   @(K) fr_v(K).*fns_tuning{K}(x), fr_v  ),1:length(fr_v)   );
% 
% finalfun(1)
% 
% %  anonymousfunctionarray = cell(2,1);
% %  for ii = 1:2
% %      anonymousfunctionarray{ii,1}=@(x) x*ii;
% %  end
% %
% %
% 
% fr_v=[1;5];
% 
% finalfun = @(x) sum(     arrayfun(   @(K) fr_v(K).*fns_tuning{K}(x), fr_v  )   );
% 
% finalfun(1)
% 
% %     finalfun = @(x) sum(     arrayfun(@(K) doublearray(K).*anonymousfunctionarray{K}(x), 1:length(doublearray))   );
% 
% 
% 
% 
% doublearray = (1:10)';
% finalfun =@(x)doublearray(1,1)*fns_tuning{1,1}(x);
% for ii = 2:10
%     finalfun =@(x)finalfun(x)+doublearray(ii,1)*fns_tuning{ii,1}(x);
% end
% 
% 
% 
% f1= @(x) 2*x
% 
% f2= @(x) log(f1)
% 
% f2(10)
% 
% finalfun = @(x) sum(arrayfun(@(K) doublearray(K).*fns_tuning{K}(x), 1:length(doublearray)));
% 
% 
% finalfun = @(x) sum(arrayfun(@(K) doublearray(K).*fns_tuning{K}(x), 1:length(doublearray)));
% 
% 
