clear; clc; close all;

%1-No Condition
%---------------------------
dx=0.01;
x=0:dx:10;                   %x range 

p_x1=normpdf(x,3,1);         %probability of x1
p_x2=normpdf(x,5,0.5);       %probability of x2

plot(x,p_x1,'b',x,p_x2,'g');
xlabel('x');
ylabel('pdf');
hold on

%2-Condition that x2=x1 
%-----------------------

p_condition=trapz(p_x1.*p_x2)*dx;                %p(x2=x1)
p_x1_x2_condition=p_x2.*p_x1/p_condition;        %p(x=x2,x=x1|x2=x1)=p(x=x2,x=x1)/p(x2=x1) [Bayes Theorem]

E_x=trapz(x.*p_x1_x2_condition)*dx;              %E(x=x2,x=x1|x2=x1) [Conditional Expectation]

Var_x=trapz((x-E_x).^2.*p_x1_x2_condition)*dx;   %Variance of x      

plot(x,p_x1_x2_condition,'r');
legend('Estimate Uncertainty using Sensor 1','Estimate Uncertainty using Sensor 2','Estimate Uncertainty using both Sensors');
hold off
title(strcat('Expected x=',num2str(E_x),' with Variance=',num2str(Var_x)));