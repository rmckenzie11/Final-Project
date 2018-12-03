

f <- file.path("https://s3.amazonaws.com/nyc-tlc/trip+data", c("yellow_tripdata_2018-01.csv",
                                                               "yellow_tripdata_2018-02.csv", 
                                                               "yellow_tripdata_2018-03.csv", 
                                                               "yellow_tripdata_2018-04.csv",
                                                               "yellow_tripdata_2018-05.csv",
                                                               "yellow_tripdata_2018-06.csv",
                                                               "yellow_tripdata_2017-07.csv",
                                                               "yellow_tripdata_2017-08.csv",
                                                               "yellow_tripdata_2017-09.csv",
                                                               "yellow_tripdata_2017-10.csv",
                                                               "yellow_tripdata_2017-11.csv",
                                                               "yellow_tripdata_2017-12.csv"))

d <- file.path("C:\\Users\\Robert\\Desktop\\Gov 1005\\test\\data", c("yellow_tripdata_2018-01.csv",
                                                               "yellow_tripdata_2018-02.csv", 
                                                               "yellow_tripdata_2018-03.csv", 
                                                               "yellow_tripdata_2018-04.csv",
                                                               "yellow_tripdata_2018-05.csv",
                                                               "yellow_tripdata_2018-06.csv",
                                                               "yellow_tripdata_2017-07.csv",
                                                               "yellow_tripdata_2017-08.csv",
                                                               "yellow_tripdata_2017-09.csv",
                                                               "yellow_tripdata_2017-10.csv",
                                                               "yellow_tripdata_2017-11.csv",
                                                               "yellow_tripdata_2017-12.csv"))



f2 <- file.path("https://canvas.harvard.edu/courses/45146/files", c(""))


cab_data18 %>%
  filter(! V9 == c("138", "132", "1")) %>%
  filter(! V8 == c("138", "132", "1")) %>%
  summarise(mean(V5))


download.file()

d <- file.path()

for(i in 1:length(f)){
  download.file(f[i], d[i], mode = "wb")
}

library(data.table)

x <- fread("data/yellow_tripdata_2017-07.csv")








