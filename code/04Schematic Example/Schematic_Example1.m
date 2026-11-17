%diagonal coupling network
%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(a)
inter_data = [];
module_partition=[1 1;2 2];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(b)
inter_data = [];
module_partition=[1 1;2 3];
Result = HomoMI("monolayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(c)
inter_data = [];
module_partition=[1 1;1 1];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(d)
inter_data = [];
module_partition=[1 1;1 2];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(e)
inter_data = [];
module_partition=[1 1;2 3];
Result = HomoMI("multilayer",'mean',module_partition,inter_data);
HMI = Result{2}
