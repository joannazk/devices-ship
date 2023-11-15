## install and load some stuff
install.packages("tidyverse")
install.packages("dplyr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("readr")
install.packages("slider")

library("tidyverse")
library("dplyr")
library("lubridate")
library("ggplot2")
library("readr")
library("slider")

# import data
ob_devices_2022 <- read_csv("outbound_devices - outbound_devices_2022.csv")
View(ob_devices_2022)

# device count needs to be numeric, and the date column needs to be a date.
as.numeric(ob_devices_2022$`Device Count`)
ob_devices_2022$Date <- mdy(ob_devices_2022$Date)

class(ob_devices_2022$`Device Count`)
class(ob_devices_2022$Date)

# sort by oldest to newest. 
ob_devices_2022 %>% 
  arrange(mdy(ob_devices_2022$Date))
ob_devices_2022

#lets figure some things out now.
sum(ob_devices_2022$`Device Count`)
#649 devices, neat.

#lets look at how much time this data covers. roughly. 
range(ob_devices_2022$Date)
#"2022-06-02" "2022-12-30" also neat.

## aggregate outbound device numbers, 1 month at a time. bar graph have 1 bar
# for each month.
# x = month.y = devices sent out that month. 

ob_devices_2022_new <- ob_devices_2022
ob_devices_2022_new$year_month <- floor_date(ob_devices_2022_new$Date,
                                   "month")
head(ob_devices_2022_new)   

# sum up the amount of devices per month.
ob_device_by_month <- aggregate(ob_devices_2022_new$`Device Count`,
                      by=list(ob_devices_2022_new$year_month), FUN=sum)
ob_device_by_month <- as.data.frame(ob_device_by_month)

ob_device_by_month

# visualizations to display number of outbound devices per month
### 1
ggplot() +
  geom_bar(data=ob_devices_2022_new,aes(x=ob_devices_2022_new$year_month,y=ob_devices_2022_new$`Device Count`), stat="identity") +
  xlab("Month") + 
  ylab("No. of Devices") + 
  ggtitle("Outbound Devices: June - December 2022", subtitle ="Total: 649 units")

#### 2 - better.
ggplot() +
  geom_bar(data=ob_device_by_month,
           aes(x=`Group.1`,y=x),
           stat="identity",
           color="#08354e",
           fill="#0e5881",
           size=1,) +
  xlab("Months") + 
  ylab("No. of Devices") + 
  ggtitle("Outbound Devices: June - December 2022", subtitle ="Total: 649 units")
