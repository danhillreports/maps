require(ggplot2)
require(maps)
library(grid)

tx = map("state", "texas", plot=FALSE, fill=TRUE, colour=I("#fcc10f"))
tx_counties = map("county", "texas", plot=FALSE, fill=TRUE, colour=I("#fcc10f"))

counties = fortify(tx_counties)
county_names = counties$subregion

p = ggplot()
tx_plot = p + geom_polygon(data=tx, aes(x=long, y=lat, group=group), fill=I("gray70"))

plot_theme = theme(line = element_blank(),
    text = element_blank(),
    line = element_blank(),
    title = element_blank(),
    panel.background = element_rect(fill="transparent", colour=NA),
    plot.background = element_rect(fill="transparent", colour=NA))

for (i in 1:length(county_names)) {
    county_name = county_names[i]
    county = subset(counties, subregion == county_name)
    filename = paste("png/", county_name, ".png", sep="")
    png(filename, bg="transparent", width=640, height=640)

    county_plot = tx_plot + geom_polygon(data=county, aes(x=long, y=lat, group=group), fill=I("#fcc10f")) + plot_theme

    gt <- ggplot_gtable(ggplot_build(county_plot))
    ge <- subset(gt$layout, name == "panel")

    grid.draw(gt[ge$t:ge$b, ge$l:ge$r])
    dev.off()
}
