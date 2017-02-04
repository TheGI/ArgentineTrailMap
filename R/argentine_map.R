# L. humile activity map

# Note
# 1. More winter ants
# 2. Camponotus activity drop between summer and autumn survey
# 3.
# include libraries
library(GGally)
library(ggplot2)
library(reshape)

# set the working directory
setwd('~/Google Drive/Research/Linepithema_Winter_Survey/data/mapdata/')

# get coordinate information for survey locations
coord.data <-
  read.csv('argentine_map_coordinates.csv', stringsAsFactors = FALSE)

# read raw survey data
map.data <-
  read.csv('argentine_map_data.csv', stringsAsFactors = FALSE)

# flip x and y coordinates and divide by 10

# map.data[,c('xcoord','ycoord')] <- map.data[,c('xcoord','ycoord')]/10
# map.data[map.data$site == 1, c('xcoord','ycoord')] <-
#   -map.data[map.data$site == 1, c('xcoord','ycoord')]

# rename the columns
colnames(map.data) <- c('date','time','trail','name',
                        'argen1','argen2','winter1','winter2')

# assign site numbers
map.data[grep("#", map.data$name), 'site'] <- 2
map.data[is.na(map.data$site), 'site'] <- 1
coord.data[grep("#", coord.data$name), 'site'] <- 2
coord.data[is.na(coord.data$site), 'site'] <- 1
coord.data[,c('xcoord','ycoord')] <- coord.data[,c('xcoord','ycoord')]/10
coord.data[coord.data$site == 1, c('xcoord','ycoord')] <-
  -coord.data[coord.data$site == 1, c('xcoord','ycoord')]

# separate activity and trail data
trail.data <- map.data[map.data$trail == 1,]

# separate trail start and end locations
temp <- unlist(strsplit(trail.data$name, '_'))
trail.data$name <- NULL
trail.data[,c('name','Nto')] <-
  c(temp[seq(1,length(temp),2)],temp[seq(2,length(temp),2)])
trail.data <- merge(trail.data,coord.data, by = "name")
colnames(trail.data)[11:12] <- c('Xfrom','Yfrom')
colnames(trail.data)[1] <- 'Nfrom'
colnames(trail.data)[10] <- 'name'
trail.data <- merge(trail.data,coord.data, by = "name")
colnames(trail.data)[1] <- 'Nto'
colnames(trail.data)[14:15] <- c('Xto', 'Yto')

trail.data[trail.data$argen1 == 5 | trail.data$argen1 == 6,'argwin'] <- 1
trail.data[trail.data$winter1 == 5 | trail.data$winter1 == 6,'argwin'] <- 0

# create activity data set
map.data <- merge(map.data, coord.data, by = c("name",'site'))

# plotting activities
dates <- sort(unique(map.data$date[map.data$site == 2]))
output <- list()
for (i in 1:length(dates)) {
map.data.sub <- subset(map.data, date == dates[i] &
                         site == 2 &
                         argen1 != 9 &
                         argen1 != 35 &
                         argen1 != 42 & 
                         !(argen1 == 0 &
                         argen2 == 0 &
                         winter1 == 0 &
                         winter2 == 0))
output[[i]] <- ggplot() +
  geom_text(
    data = coord.data[coord.data$site == 2,],
    aes(x = xcoord, y = ycoord, label = name),
    size = 3, vjust = 2
  ) +
  geom_point(
    data = map.data.sub,
    aes(x = xcoord, y = ycoord,
    size = argen1+argen2,
    colour = "red")
  ) +
  geom_point(
    data = map.data.sub,
    aes(x = xcoord, y = ycoord,
        size = winter1+winter2,
        colour = "blue")
  ) +
  scale_size(range = c(2,5)) +
  scale_color_manual(values = c('blue','red'),
                     labels = c("P. imparis","L. humile")) + 
  guides(
    colour = guide_legend(title = "Ant Species"),
    size = guide_legend(title = "Activity Level")
  ) +
  labs(title = paste("Ant Activity, Site #2", dates[i]),
       x = "x distance (m)",
       y = "y distance (m)") +
  theme_light()
}
multiplot(plotlist = output, cols = 3)

# plotting trails
trail.data.sub <- subset(trail.data, site == 1 &
                           (((argen1 == 5 |
                                argen1 == 6) & (argen2 == 7 | argen2 == 8)
                           ) |
                             ((winter1 == 5 |
                                 winter1 == 6) & (winter2 == 7 | winter2 == 8)
                             )))
ggplot() +
  geom_point(
    data = coord.data[coord.data$site == 1,],
    aes(x = xcoord, y = ycoord),
    shape = 1, size = 4
  ) +
  geom_text(
    data = coord.data[coord.data$site == 1,],
    aes(x = xcoord, y = ycoord, label = name),
    size = 3, vjust = 2
  ) +
  geom_curve(
    data = trail.data.sub,
    aes(
      x = Xfrom, y = Yfrom,
      xend = Xto, yend = Yto,
      colour = factor(date),
      linetype = factor(argen1 + winter1,c("6","5","10")),
      size = factor(argen2 + winter2),
      alpha = factor(argwin * 0.5 + 0.5, c("1","0.5"))
    ),
    arrow = arrow(length = unit(0.3, "cm"))
  ) +
  scale_linetype_manual(
    values = c(1, 2, 2),
    labels = c("Full Trail", "Partial Trail"),
    limits = c("5", "6")
  ) +
  scale_size_manual(
    values = c(1,1.5,1),
    labels = c("Weak Trail", "Strong Trail"),
    limits = c("7","8")
  ) +
  scale_alpha_manual(values = c(0.3, 1),
                     labels = c("P. imparis", "L. humile")) +
  guides(
    colour = guide_legend(title = "Survey Dates"),
    linetype = guide_legend(title = "Trail Types"),
    size = guide_legend(title = "Trail Strength"),
    alpha = guide_legend(title = "Ant Species")
  ) +
  labs(title = "Ant trail network in survey site #1",
       x = "x distance (m)",
       y = "y distance (m)") +
  theme_light()

trail.data.sub <- subset(trail.data, site == 2 &
                           (((argen1 == 5 |
                                argen1 == 6) & (argen2 == 7 | argen2 == 8)
                           ) |
                             ((winter1 == 5 |
                                 winter1 == 6) & (winter2 == 7 | winter2 == 8)
                             )))
ggplot() +
  geom_point(
    data = coord.data[coord.data$site == 2,],
    aes(x = xcoord, y = ycoord),
    shape = 1, size = 4
  ) +
  geom_text(
    data = coord.data[coord.data$site == 2,],
    aes(x = xcoord, y = ycoord, label = name),
    size = 3, vjust = 2
  ) +
  geom_curve(
    data = trail.data.sub,
    aes(
      x = Xfrom, y = Yfrom,
      xend = Xto, yend = Yto,
      colour = factor(date),
      linetype = factor(argen1 + winter1,c("6","5","10")),
      size = factor(argen2 + winter2),
      alpha = factor(argwin * 0.5 + 0.5, c("1","0.5"))
    ),
    arrow = arrow(length = unit(0.3, "cm"))
  ) +
  scale_linetype_manual(
    values = c(1, 2, 2),
    labels = c("Full Trail", "Partial Trail"),
    limits = c("5", "6")
  ) +
  scale_size_manual(
    values = c(1,1.5,1),
    labels = c("Weak Trail", "Strong Trail"),
    limits = c("7","8")
  ) +
  scale_alpha_manual(values = c(0.3, 1),
                     labels = c("P. imparis", "L. humile")) +
  guides(
    colour = guide_legend(title = "Survey Dates"),
    linetype = guide_legend(title = "Trail Types"),
    size = guide_legend(title = "Trail Strength"),
    alpha = guide_legend(title = "Ant Species")
  ) +
  labs(title = "Ant trail network in survey site #2",
       x = "x distance (m)",
       y = "y distance (m)") +
  theme_light()