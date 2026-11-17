%temporal network or spatial network (three layers)
%-----------------------------------------------------%
%module partition by multilayer algorithm
%without interlayer links weight
module_partition=[1 1 2 2 2;1 1 2 2 2;1 1 2 2 2]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%without interlayer links weight
module_partition=[1 1 2 2 2;1 1 2 3 2;1 1 2 3 2]
HomoMI("multilayer",module_partition,0)

%module partition by multilayer algorithm
%with interlayer links weight
interlayer_links_weight=[1 1 1 1 1;1 1 1 1 1]
module_partition=[1 1 2 2 2;1 1 2 2 2;1 1 2 2 2]
HomoMI("multilayer",module_partition,interlayer_links_weight)

%-----------------------------------------------------%
%module partition by monolayer algorithm
%without interlayer links weight
module_partition=[1 1 2 2 2;2 2 3 3 3;3 3 4 4 4]
HomoMI("monolayer",module_partition,0)

%module partition by monolayer algorithm
%without interlayer links weight
module_partition=[1 1 2 2 2;2 2 3 4 3;3 3 4 5 4]
HomoMI("monolayer",module_partition,0)

%module partition by monolayer algorithm
%with interlayer links weight
interlayer_links_weight=[1 1 1 1 1;1 1 1 1 1]
module_partition=[1 1 2 2 2;2 2 3 3 3;3 3 4 4 4]
HomoMI("monolayer",module_partition,interlayer_links_weight)


