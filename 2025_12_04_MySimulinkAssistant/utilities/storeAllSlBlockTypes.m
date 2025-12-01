h = load_system('simulink')
find_system(h)
blk = find_system(h)
bTypes = get_param(blk(2:end),'BlockType')
bTypes = unique(bTypes)
blkTypesStr = string(strjoin(bTypes, ', '));

save allBlockTypes bTypes blkTypesStr