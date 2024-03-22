#' ---
#' title: "Kiedy następna komisja śledcza?"
#' author: ""
#' date: '`r paste("Ostatnia aktualizacja",format(Sys.time(), "%Y-%m-%d %H:%M"))`'
#' 
#' ---
#'


#+ echo=F

library(rvest)
library(rmarkdown)
library(htmltools)
library(purrr)



komisje_df <-
            data.frame(
              stringsAsFactors = FALSE,
                       komisja = c("Komisja kopertowa", "Komisja wizowa","Komisja ds. pegazusa"),
               komisja_akronim = c("skgk", "skpc", "skpg"),
                  komisja_link = c("https://www.sejm.gov.pl/Sejm10.nsf/agent.xsp?symbol=KOMISJASL&NrKadencji=10&KodKom=SKGK",
                                   "https://www.sejm.gov.pl/Sejm10.nsf/agent.xsp?symbol=KOMISJASL&NrKadencji=10&KodKom=SKPC",
                                   "https://www.sejm.gov.pl/Sejm10.nsf/agent.xsp?symbol=KOMISJASL&NrKadencji=10&KodKom=SKPG"),
              posiedzenia_link = c("https://www.sejm.gov.pl/Sejm10.nsf/PlanPosKom.xsp?view=2&komisja=SKGK",
                                   "https://www.sejm.gov.pl/Sejm10.nsf/PlanPosKom.xsp?view=2&komisja=SKPC",
                                   "https://www.sejm.gov.pl/Sejm10.nsf/PlanPosKom.xsp?view=2&komisja=SKPG")
            )

div(
  pmap(list(komisje_df$komisja, komisje_df$komisja_link, komisje_df$posiedzenia_link), 
       function(x, y, z) div(h1(a(href=y, x, target="_blank")),
                             h3(read_html(z) %>% html_elements(".subcat") %>% html_element("strong") %>%  html_text() %>% ifelse(length(.)==0, "Brak wyznaczonych posiedzeń", .)  ),
                             div(map(z, ~read_html(.x) %>% html_elements(".subcat") %>% html_elements(".tresc") %>% 
                                       html_elements("li") %>%  html_text() %>% map(p))
                             )
       )
  )
)

#+ echo=F, include=F
# render("R/scraping.R", output_file = "../index.html")
