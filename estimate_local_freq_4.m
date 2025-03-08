function [s1,s2] = estimate_local_freq_4(theta_1_a,theta_2_a,theta_1_a_t,theta_2_a_t,t_step_ref,J,N)
if (J == 5) slope_limit=10; end;  
  
for jj = 1:J
  for m = 1:3

    S = N/(2^jj);
    s1{jj}{m} = zeros(S,S);
    s2{jj}{m} = zeros(S,S);    
  end; % m = 1:3
end; % jj = 1:J

for jj = 1:J  
  for m = 1:3
    [d_theta_1{jj}{m},d_theta_2{jj}{m}] = wrap_quaternion_phase((theta_1_a{jj}{m}-theta_1_a_t{jj}{m}),(theta_2_a{jj}{m}-theta_2_a_t{jj}{m}),0,0,pi,pi); 
    s1{jj}{m} = d_theta_1{jj}{m}/(t_step_ref);
    s2{jj}{m} = d_theta_2{jj}{m}/(t_step_ref);
      
    s1{jj}{m}(s1{jj}{m}==0) = 1e-6;
    s2{jj}{m}(s2{jj}{m}==0) = 1e-6;
    
  end; % m = 1:3  
end; % jj = 1:J