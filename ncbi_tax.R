ncbi_taxonomy_dump_url <- 'ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz'
download.file(ncbi_taxonomy_dump_url, '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump.tar.gz')
untar('/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump.tar.gz', exdir = '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump_190410')
names_buf <- read.delim('/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump_190410/names.dmp', header = FALSE, sep = '\t')
nodes_buf <- read.delim('/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump_190410/nodes.dmp', header = FALSE, sep = '\t')

