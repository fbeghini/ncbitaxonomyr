ncbi_taxonomy_dump_url <-
  'https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz'

download.file(
  ncbi_taxonomy_dump_url,
  '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump.tar.gz'
)

untar(
  '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump.tar.gz',
  exdir = '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump_190410'
)

taxonomy_buf <-
  scan(
    '/shares/CIBIO-Storage/CM/scratch/users/francesco.beghini/taxdump_190410/rankedlineage.dmp',
    sep = "\t",
    what = "raw",
    quote = NULL
  )

taxonomy <-
  matrix(taxonomy_buf, ncol = 20, byrow = TRUE)[, c(TRUE, FALSE)]

taxonomy <- as.data.frame(taxonomy)

colnames(taxonomy) <-
  c(
    "tax_id",
    "tax_name",
    "species",
    "genus",
    "family",
    "order",
    "class",
    "phylum",
    "kingdom",
    "superkingdom"
  )
taxonomy %>% select(tax_id == 1280)
