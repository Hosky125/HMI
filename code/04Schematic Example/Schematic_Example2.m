%temporal network or spatial network (three layers)
%-----------------------------------------------------%
%module partition by multilayer algorithm
%without interlayer links weight
inter_data = [];
module_partition=[1 1 2 2 2;1 1 2 2 2;1 1 2 2 2];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
inter_data = [];
module_partition=[1 1 2 2 2;1 1 2 3 2;1 1 2 3 2];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%with interlayer links weight
inter_data=[1 1 1 1 1;1 1 1 1 1];
module_partition=[1 1 2 2 2;1 1 2 2 2;1 1 2 2 2];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
inter_data = [];
module_partition=[1 1 2 2 2;2 2 3 3 3;3 3 4 4 4];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by monolayer algorithm
%without interlayer links weight
inter_data = [];
module_partition=[1 1 2 2 2;2 2 3 4 3;3 3 4 5 4];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by monolayer algorithm
%with interlayer links weight
inter_data=[1 1 1 1 1;1 1 1 1 1];
module_partition=[1 1 2 2 2;2 2 3 3 3;3 3 4 4 4];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}
