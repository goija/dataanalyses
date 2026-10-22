# Installeer eventueel benodigde pakketten (indien nog niet aanwezig):
# install.packages(c("ggplot2", "deldir", "sf"))

library(ggplot2)
library(deldir)
library(sf)

# 1. Coördinaten en Gegevens (22 oktober 2026, 19:00 CEST)
# Poolanker P (Laren) RD-coördinaten
anchor_x <- 143582
anchor_y <- 473563

# Maan projectie op basis van azimut (122°) en elevatie (17.7°) ten opzichte van anker P
moon_distance_scaling <- 400 # Schaal factor voor visualisatie in meters
moon_x <- anchor_x + moon_distance_scaling * cos(122 * pi / 180)
moon_y <- anchor_y + moon_distance_scaling * sin(122 * pi / 180)

# 2. Genereer omliggende rasterpunten voor de Voronoi-cellen
set.seed(2026)
n_points <- 18
points_x <- rnorm(n_points, mean = anchor_x, sd = 600)
points_y <- rnorm(n_points, mean = anchor_y, sd = 600)

# Samenvoegen in een datadrager
df_points <- data.frame(
  x = c(anchor_x, moon_x, points_x),
  y = c(anchor_y, moon_y, points_y),
  type = c("Poolanker P", "Maan (projectie)", rep("Geodetisch punt", n_points))
)

# 3. Bereken de Voronoi-tessellatie
voronoi_tiles <- deldir(df_points$x, df_points$y)
voronoi_segments <- voronoi_tiles$dirsgs

# 4. Visualisatie met ggplot2
p <- ggplot() +
  # Teken de Voronoi-randen (voornoiraster)
  geom_segment(data = voronoi_segments,
               aes(x = x1, y = y1, xend = x2, yend = y2),
               color = "#3b5998", linewidth = 0.8, alpha = 0.8) +
  # Teken de referentiepunten
  geom_point(data = df_points, aes(x = x, y = y, color = type, shape = type), size = 3.5) +
  scale_color_manual(values = c(
    "Poolanker P" = "#d9534f", 
    "Maan (projectie)" = "#f0ad4e", 
    "Geodetisch punt" = "#5bc0de"
  )) +
  scale_shape_manual(values = c(
    "Poolanker P" = 17, 
    "Maan (projectie)" = 8, 
    "Geodetisch punt" = 16
  )) +
  labs(
    title = "Geodetisch Voornoiraster & Maanstand",
    subtitle = "Observatiemoment: 22 oktober 2026, 19:00 CEST | Laren (Poolanker P)",
    x = "RD X-coördinaat (m)",
    y = "RD Y-coördinaat (m)",
    color = "Legenda",
    shape = "Legenda"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    panel.grid.major = element_line(color = "grey90", linetype = "dashed"),
    legend.position = "bottom"
  ) +
  coord_fixed()

# Toon de plot
print(p)