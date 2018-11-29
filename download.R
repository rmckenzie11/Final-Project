

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


f2 <- file.path("https://s3.amazonaws.com/nyc-tlc/trip+data", c("fhv_tripdata_2018-01.csv",
                                                               "fhv_tripdata_2018-02.csv", 
                                                               "fhv_tripdata_2018-03.csv", 
                                                               "fhv_tripdata_2018-04.csv",
                                                               "fhv_tripdata_2018-05.csv",
                                                               "fhv_tripdata_2018-06.csv"))


d2 <- file.path("C:\\Users\\Robert\\Desktop\\Gov 1005\\test\\data", c("fhv_tripdata_2018-01.csv","fhv_tripdata_2018-02.csv","fhv_tripdata_2018-03.csv","fhv_tripdata_2018-04.csv","fhv_tripdata_2018-05.csv","fhv_tripdata_2018-06.csv"))

for(i in 1:length(f)){
  download.file(f[i], d[i], mode = "wb")
}

for(i in 1:length(f2)){
  download.file(f2[i], d2[i], mode = "wb")
}

library(data.table)

x <- fread("data/yellow_tripdata_2017-07.csv")








