library(magrittr)
library(dplyr)

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
# taxonomy %>% select(tax_id == 1280)
taxonomy %<>% dplyr::filter(taxonomy$superkingdom != '') %>% select(-kingdom) %>% mutate_all(funs(stringr::str_replace_all(., ' ', '_')))
taxonomy %<>% select(superkingdom, phylum, class, order, family, genus, species) %>% distinct()

taxonomy$superkingdom <- paste0('k__', taxonomy$superkingdom)
taxonomy$phylum <- paste0('p__', taxonomy$phylum)
taxonomy$class <- paste0('c__', taxonomy$class)
taxonomy$order <- paste0('o__', taxonomy$order)
taxonomy$family <- paste0('f__', taxonomy$family)
taxonomy$genus <- paste0('g__', taxonomy$genus)
taxonomy$species <- paste0('s__', taxonomy$species)

taxonomy %<>% mutate_all(funs(stringr::str_replace_all(. , '[kpocfgs]__$', '')))
taxlvl <- 'kpocfgs'

mpa_taxa <- apply(head(taxonomy), 1, function(x) {
  empty_lvls <- which(x == "")
  if (!tail(empty_lvls, 1) - head(empty_lvls, 1) == length(empty_lvls) -
      1) {
    has_species <- x['species'] != ""
    last_taxa_known <- head(empty_lvls, 1) - 1
    x[empty_lvls] <-
      sapply(empty_lvls, function(idx)
        paste0(
          stringr::str_sub(taxlvl, idx, idx),
          '__',
          stringr::str_sub(x[last_taxa_known], 4),
          '_unclassified'
        ))
    if (!has_species)
      x['species'] <- NA
  } else {
    x[empty_lvls] <- NA
  }
  x
}) %>% t %>% as.data.frame %>% tidyr::unite('mpa_tax',
                                            superkingdom,
                                            phylum,
                                            class,
                                            order,
                                            family,
                                            genus,
                                            species,
                                            sep = '|') %>%
  dplyr::mutate(stringr::str_replace(mpa_tax, stringr::fixed('|NA'), ''))
