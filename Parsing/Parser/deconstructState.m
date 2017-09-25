function [lhs, rhs, dotPos, IDs, useFlags, tempRel, se, prob, backPointers] = deconstructState(state)
lhs = state{1};
rhs = state{2};
dotPos = state{3}; % Dot position means before that element in rhs
IDs = state{4};
useFlags = state(5);
tempRel = state{6};
se = state{7};
prob = state{8};
backPointers = state{9};
end
