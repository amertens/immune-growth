#### Adjust all pvalues with BH procedure ####
rm(list=ls())

source(here::here("0-config.R"))

# load all results
H1_res <- readRDS(here('results/unadjusted/H1_res.RDS'))
H2_res <- readRDS(here('results/unadjusted/H2_res.RDS'))
H3_res <- readRDS(here('results/unadjusted/H3_res.RDS'))
delta_growth_res <- readRDS(here('results/unadjusted/delta_growth_res.RDS'))

H1_adj_res <- readRDS(here('results/adjusted/H1_adj_nofever_res.RDS'))
H2_adj_res <- readRDS(here('results/adjusted/H2_adj_nofever_res.RDS'))
H3_adj_res <- readRDS(here('results/adjusted/H3_adj_nofever_res.RDS'))
delta_growth_adj_res <- readRDS(here('results/adjusted/delta_growth_adj_nofever_res.RDS'))

H1_res$H = 1
H2_res$H = 2
H3_res$H = 3
delta_growth_res$H = 4

H1_adj_res$H = 1
H2_adj_res$H = 2
H3_adj_res$H = 3
delta_growth_adj_res$H = 4

H1_res$time <- ifelse(grepl("t2", H1_res$Y), "t2C", "t3C")
H1_adj_res$time <- ifelse(grepl("t2", H1_adj_res$Y), "t2C", "t3C")

H2_res$time <- "t3S"
H2_adj_res$time <- "t3S"
H3_res$time <- "V"
H3_adj_res$time <- "V"
delta_growth_res$time <- "D"
delta_growth_adj_res$time <- "D"

full_res <- rbind(H1_res, H2_res, H3_res, delta_growth_res)
full_adj_res <- rbind(H1_adj_res, H2_adj_res, H3_adj_res, delta_growth_adj_res)

full_res <- full_res %>% group_by(H, time) %>% 
  mutate(corrected.Pval=p.adjust(Pval, method="BH")) %>%
  ungroup() %>%
  as.data.frame()

full_adj_res <- full_adj_res %>% group_by(H, time) %>% 
  mutate(corrected.Pval=p.adjust(Pval, method="BH")) %>%
  ungroup() %>%
  as.data.frame()

saveRDS(full_res %>% filter(H==1) %>% select(-c(H, time)), here("results/unadjusted/H1_res.RDS"))
saveRDS(full_res %>% filter(H==2) %>% select(-c(H, time)), here("results/unadjusted/H2_res.RDS"))
saveRDS(full_res %>% filter(H==3) %>% select(-c(H, time)), here("results/unadjusted/H3_res.RDS"))
saveRDS(full_res %>% filter(H==4) %>% select(-c(H, time)), here("results/unadjusted/delta_growth_res.RDS"))

saveRDS(full_adj_res %>% filter(H==1) %>% select(-c(H, time)), here("results/adjusted/H1_adj_nofever_res.RDS"))
saveRDS(full_adj_res %>% filter(H==2) %>% select(-c(H, time)), here("results/adjusted/H2_adj_nofever_res.RDS"))
saveRDS(full_adj_res %>% filter(H==3) %>% select(-c(H, time)), here("results/adjusted/H3_adj_nofever_res.RDS"))
saveRDS(full_adj_res %>% filter(H==4) %>% select(-c(H, time)), here("results/adjusted/delta_growth_adj_nofever_res.RDS"))
