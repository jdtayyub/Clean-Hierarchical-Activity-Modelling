function x = isNonterminal(symbol)
if symbol(1) == sprintf('\''')
  x = false;
else
  x = true;
end
end