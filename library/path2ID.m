function id = path2ID(path)
    [Fold, ~, ~] = fileparts(path);
    [Fold, ~, ~] = fileparts(Fold);
    [~, ID_Str, ~] = fileparts(Fold);
    id = char(convertCharsToStrings(ID_Str(isstrprop(ID_Str,'digit'))));
end
    