function s = nnz(T)
%nnz: Returns number of non-zeros in an associative array or database table.
%Associative array or database user function.
%  Usage:
%    n = nnz(A)
%  Inputs:
%    A = associative array or database table
%  Outputs:
%    n = number of non-zero (or non-empty) entries in an associative array or database table; same as the number of triples

% Use edu.mit.ll.d4m.db.cloud.D4mDbTableOperations

DB = struct(T.DB);
tabname = T.name;
%disp(T);
if strcmp(DB.type,'BigTableLike') || strcmp(DB.type,'Accumulo')
    ops = DBaddJavaOps('edu.mit.ll.d4m.db.cloud.D4mDbTableOperations',DB.instanceName,DB.host,DB.user,DB.pass);
    %ops.init(DB.instanceName,DB.host,DB.user,DB.pass, DB.type);
    ops.setCloudType(DB.type);
    
    % Need to create a wrapper function that hides Matlab/Octave differences.
    
    %     if exist('OCTAVE_VERSION','builtin')
    %       tablenameList = java_new('java.util.ArrayList');
    %     else
    tablenameList = javaObject('java.util.ArrayList');
    %     end
    tablenameList.add(tabname);
    s = ops.getNumberOfEntries(tablenameList);
    %  end
    
    %  if exist('OCTAVE_VERSION','builtin')
    %    s = s.toString();
    %    s = str2num(s);
elseif strcmp(DB.type,'scidb')
    
    [tableName tableSchema] = SplitSciDBstr(T.name);
    urlport = DB.host;
    [sessionID,success]=urlread([urlport 'new_session']);
    sessionID = deblank(sessionID);
    idx=strfind(T.name, '<');
    tableName=T.name(1:(idx(1)-1));
    
    queryStr = ['count(' tableName ')'];
    queryStr = strrep(queryStr,' ','%20');
    
    urlreadStr = [urlport 'execute_query?id=' sessionID '&query=' queryStr '&save=dcsv'];
    [queryID,success]=urlread(urlreadStr);
    
    urlreadStr = [urlport 'read_lines?id=' sessionID '&n=1000'];
    [queryID,success]=urlread(urlreadStr);
    
    idx=strfind(queryID, '}');
    s=str2num(queryID(idx(2)+2:(end)));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D4M: Dynamic Distributed Dimensional Data Model
% Architect: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% Software Engineer: Dr. Jeremy Kepner (kepner@ll.mit.edu)
%  Dr. Vijay Gadepally (vijayg@ll.mit.edu)
% MIT Lincoln Laboratory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) <2010> Massachusetts Institute of Technology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

