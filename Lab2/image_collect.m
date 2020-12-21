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
  n = size(size(array{k}));
  if n(2) < 3
      array{k} = uint8(cat(3, array{k}, array{k}, array{k}));
  end
  %imshow(imageArray);  % Display image.
  %drawnow; % Force display to update immediately.
end