function [taskInfo, numtask, isDeploymentDiagram]=slrealtime_task_info()
   taskInfo(1).samplePeriod = 0.001;
   taskInfo(1).sampleOffset = 0.0;
   taskInfo(1).taskPrio = 9;
   taskInfo(1).taskName = 'BaseRate';
   taskInfo(1).entryPoints = {};
   numtask = 1;
   for i = 1:numtask
      if ( 0 == isnumeric(taskInfo(i).samplePeriod) )
         taskInfo(i).samplePeriod = evalin('base', taskInfo(i).samplePeriod);
      end
      if ( isempty(taskInfo(i).taskName) )
         taskInfo(i).taskName = ['AutoGen' i ];
      end
   end
   isDeploymentDiagram = 0;
end 
