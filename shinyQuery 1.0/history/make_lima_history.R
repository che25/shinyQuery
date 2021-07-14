# library(foreach)
# library(ChemmineR)

lm_sdf = read.SDFset("~/Downloads/structures_2021-02-12.sdf")

lm_sdf %>% saveRDS("~/Downloads/structures_2021-02-12.RDS")

lm_datablock_names = foreach(i=seq_along(lm_sdf), .combine = c) %do% {
  x = lm_sdf[[i]]@datablock
  names(x)
} %>% unique()


blank = rep(NA, length(lm_datablock_names)) %>%
  setNames(lm_datablock_names)

lm_datablock_matrix = foreach(i=seq_along(lm_sdf), .combine = rbind) %do% {
  x = lm_sdf[[i]]@datablock
  nm = intersect(names(x), lm_datablock_names)
  blank[nm] = x[nm]
  unname(blank)
}


lipid_maps =  lm_datablock_matrix %>%
  as_tibble(.name_repair = ~lm_datablock_names) 

extract_inchi_layer_integer = function(x, l) {
  
  y = extract_inchi_layer(x,l)
  
  suppressWarnings(as.integer(y)) %>% 
    {ifelse(is.na(.), 0, .)}
}

extract_inchi_layer = function(x, l) {
  strsplit(x, "/") %>% 
    lapply(function(z) grep(paste0("^",l), z, value=T)) %>% 
    sapply(function(z) if(length(z) == 0) "" else z) %>% 
    gsub(paste0(l,"|;"), "", .)
}

lip2 = lipid_maps %>% 
  filter(!is.na(INCHI)) %>% 
  mutate_all(trimws, whitespace = "[ \t\r\n;]") %>% 
  ## to select `best` match need to know charge and protonation state
  mutate(
    ## INCHI_formula is in most cases the neutral species 
    ## Non-neutral, i.e. charged only when this does not depend on protonation state, e.g choline
    INCHI_formula = sapply(strsplit(INCHI, "/"), function(z) z[2]),
    ## protonation
    INCHI_P = extract_inchi_layer_integer(INCHI, "p"),
    ## charge
    INCHI_Q = extract_inchi_layer_integer(INCHI, "q")
  ) %>% 
  select(-INCHI) %>% 
  ## INCHI-key minus protonation state
  mutate(INCHI_KEY = substr(INCHI_KEY,1,25)) %>% 
  ## formula must not contain symbols such as `.` or `+`
  filter(!grepl("[\\.\\+]", INCHI_formula)) %>% 
  mutate(
    ## different separator
    SYNONYMS = sub("; ", "__", SYNONYMS),
    FORMULA = INCHI_formula,
    EXACT_MASS = as.numeric(EXACT_MASS)
    )

inchi_key = lip2 %>% 
  arrange(INCHI_KEY, INCHI_P^2, INCHI_Q^2) %>%  
  group_by(INCHI_KEY) %>% 
  summarise(LM_ID = first(LM_ID), .groups = "drop")

saveRDS(
  list(
    lima=lip2 %>% select(-INCHI_formula),
    inchi_key = inchi_key
  ),
  file = "~/Downloads/lima_2021-02-12.RDS"
)
