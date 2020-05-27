sim_values <- function(.){
  attach(.)
  
  v_ij <- num.trials %>% rep(x = 1) %>% 
    plyr::llply(function(l){
      rpois(l,lambda = lambda) %>% 
      runif(df.min, df.max) %>%  
      qt(p = 0.6)
      }
    ) %>% 
    map_df(~.x %>% 
       map(~if(length(.)) . else NA) %>% 
       do.call(what = cbind) %>% 
       as_tibble
    )
    
  calc_CCP <- v_ij %>% exp %>% 
    replace(is.na(.), 0) %>% t %>% as_tibble %>% 
    mutate_if(is.numeric, funs(./sum(.))) 
  
  calc_CCP %>% saveRDS('../variables/CCP.rds')
  
  cals_inclusive_values <- v_ij %>% exp %>% 
    replace(is.na(.), 0) %>% t %>% as_tibble %>% colSums %>% log %>% 
    as.data.frame
  
  cals_inclusive_values %>% saveRDS('../variables/inclusive_value.rds')
}