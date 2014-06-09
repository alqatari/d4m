function TD = delete(T)
%delete: Deletes a table from a database; prompts user before proceeding.
%Database table user function.
%  Usage:
%    delete(T)
%    TD = delete(T)
%  Inputs:
%    T = database table or table pair object
% Outputs:
%    TD = empty database table or table pair object

   DB = struct(T.DB);

   TD = T;
   r = input(['Delete ' T.name ' from ' DB.host ' ' DB.type '? (y/n) [n]: '],'s');
   if strcmp(r,'y')
     
     if strcmp(DB.type, 'Accumulo')
       DBdelete(DB.instanceName,DB.host,T.name,DB.user,DB.pass, DB.type);
     elseif strcmp(DB.type,'scidb')
       [tableName tableSchema] = SplitSciDBstr(T.name);
       urlport = DB.host;
       [sessionID,success]=urlread([urlport 'new_session']);
       sessionID = deblank(sessionID);
       [queryID,success]=urlread([urlport 'execute_query?id=' sessionID ...
         '&query=remove(' tableName ')&release=1']);
     end
     TD.name = '';
   end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D4M: Dynamic Distributed Dimensional Data Model
% Architect: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% Software Engineer: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% MIT Lincoln Laboratory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) <2010> Massachusetts Institute of Technology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
