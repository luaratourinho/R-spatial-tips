# R-spatial-tips

Here, I am providing a set of short R scripts with some basic commands for spatial data.

For example, reading spatial objects such as points, polygons and rasters, projecting them, writing them, and others.

### List of scripts and explanations

* Reprojecting.R

In this routine, you can find how to read polygons and rasters, project them, and write them.
There are also some examples of projection commands (e.g. Albers Equal Area, WGS84...).


* Minimum_convex_polygon.R

In this routine, you can find out how to create a minimum convex polygon (a.k.a. mpc), add a buffer to it, and save your results.
I also provide an example of mpc utility, in an ecological niche context, suggested by Barve et al. 2011 (doi:10.1016/j.ecolmodel.2011.02.011).


* Hexagons.R

In this routines, you can find out how to create a hexagonal grid using your polygon. I show 2 options to build it.