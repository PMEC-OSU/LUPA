clear; clc; close all


fdir = dir(['Agent','*','.mat']);

for i = 1:length(fdir)
    dname = fdir(i).name(1:end-4);

    if ~exist(dname,'dir')
        mkdir(dname)
        load(fdir(i).name)
        agent = saved_agent;
        generatePolicyBlock(agent);
        bdclose('untitled')
        copyfile('blockAgentData.mat',dname);
        delete('blockAgentData.mat');
    else
        disp([dname,' exists!'])
    end


end