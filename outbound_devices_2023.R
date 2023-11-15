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
ob_devices_2023 <- read_csv("outbound_devices - oubound_devices_2023.csv")
View(ob_devices_2023)


# device count needs to be numeric, and the date column needs to be a date.
as.numeric(ob_devices_2023$`Device Count`)
ob_devices_2023$Date <- mdy(ob_devices_2023$Date)

class(ob_devices_2023$`Device Count`)
class(ob_devices_2023$Date)

# sort by oldest to newest. 
ob_devices_2023 %>% 
  arrange(mdy(ob_devices_2023$Date))
ob_devices_2023

#lets figure some things out now.
sum(ob_devices_2023$`Device Count`)
#716 so far devices, neat.

#lets look at how much time this data covers. roughly. 
range(ob_devices_2023$Date)
#"2023-01-03" "2023-09-29" also neat.

## aggregate outbound device numbers, 1 month at a time. bar graph have 1 bar
# for each month.
# x = month.y = devices sent out that month. 

ob_devices_2023_new <- ob_devices_2023
ob_devices_2023_new$year_month <- floor_date(ob_devices_2023_new$Date,
                                             "month")
head(ob_devices_2023_new)   

# sum up the amount of devices per month.
ob_device_by_month <- aggregate(ob_devices_2023_new$`Device Count`,
                                by=list(ob_devices_2023_new$year_month), FUN=sum)
ob_device_by_month <- as.data.frame(ob_device_by_month)
ob_device_by_month

# visualizations to display number of outbound devices per month
### 1
ggplot() +
  geom_bar(data=ob_devices_2023_new,aes(x=ob_devices_2023_new$year_month,y=ob_devices_2023_new$`Device Count`), stat="identity") +
  xlab("Month") + 
  ylab("No. of Devices") + 
  ggtitle("Outbound Devices: Jan - Sept 2023", subtitle ="Total: 716 units")

#### 2 - better.
ggplot() +
  geom_bar(data=ob_device_by_month,
           aes(x=`Group.1`,y=x),
           stat="identity",
           color="#08354e",
           fill="#0e5881",
           size= 1,) +
  xlab("Months") + 
  ylab("No. of Devices") + 
  ggtitle("Outbound Devices: Jan - Sept 2023", subtitle ="Total: 716 units")
