function [  ] = gen_project( projName )
%GEN_PROJECT creates a new project folder
%
%   gen_project generates a new project folder, with a standard folder
%   template of: 
%           projName
%                   |
%                    ---> Sandbox
%                   |
%                    ---> Final
%
%   INPUTS:
%
%   projName                      INCLUDE VAR DESCRIPTION
%
%
%   AUTHOR:       Shant Malkasian
%   DATE CREATED: 14-Oct-2015
%

if exist(projName,'dir')
    error('Project already exists. No directory was created.');
end

currentDir = pwd;
newDir = [currentDir '/' projName];
childrenDir = {'Sandbox','Final'};

mkdir(newDir);
for i=childrenDir
    mkdir([newDir '/' i{1}]);
end

addpath(genpath(newDir));
cd(newDir);
svn commit

end
