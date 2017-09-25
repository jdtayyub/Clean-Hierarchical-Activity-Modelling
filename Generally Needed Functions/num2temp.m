function [ str ] = num2temp( num )
%NUM2TEMP Summary of this function goes here
%   Detailed explanation goes here
str = '';
switch num
  case 2
    str = 'm'; %'meets'
  case 11
    str = 'mi';%'metby' inverse
  case 13
    str = 'e';%'equal'
  case 1
    str = 'b';%'before'
  case 12
    str = 'a';%'after'
  case 3
    str = 'o';%'overlaps'
  case 10
    str = 'oi';%'overlapped_by'
  case 5
    str = 'd';%'during'
  case 8
    str = 'c';%'contains'
  case 4
    str = 's';%'starts'
  case 9
    str = 'si';%'started_by'
  case 6
    str = 'f';%'finishes'
  case 7
    str = 'fi';%'finished_by'
end

end

