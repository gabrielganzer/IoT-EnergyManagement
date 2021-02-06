function array = image_collect(folder, extension)

if ~isfolder(folder)
  error = sprintf('Error: The following folder does not exist:\n%s', folder);
  uiwait(warndlg(error));
  return;
end
pattern = fullfile(folder, extension);
files = dir(pattern);
for k = 1:length(files)
  baseName = files(k).name;
  fullName = fullfile(folder, baseName);
  array{k} = imread(fullName);
end