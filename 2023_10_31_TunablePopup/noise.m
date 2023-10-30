classdef  noise < Simulink.Mask.EnumerationBase
   enumeration
      Random   (1,  'Random')
      Pulse    (2, 'Pulse')
      Sequence (3,'Sequence')
   end
 end