%diagonal coupling network
%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(a)
module_partition=[1 1;2 2]
HomoMI("monolayer",module_partition,0)

%module partition by monolayer algorithm
%without interlayer links weight
%Figure 1(b)
module_partition=[1 1;2 3]
HomoMI("monolayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(c)
module_partition=[1 1;1 1]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(d)
module_partition=[1 1;1 2]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
%Figure 1(e)
module_partition=[1 1;2 3]
HomoMI("multilayer",module_partition,0)
