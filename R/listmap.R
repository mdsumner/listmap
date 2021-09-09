template <- '<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/%s/MapServer/tile/${z}/${y}/${x}</ServerUrl>
  </Service>
  <DataWindow>
    <UpperLeftX>-20037508.34</UpperLeftX>
    <UpperLeftY>20037508.34</UpperLeftY>
    <LowerRightX>20037508.34</LowerRightX>
    <LowerRightY>-20037508.34</LowerRightY>
    <TileLevel>18</TileLevel>
    <TileCountX>1</TileCountX>
    <TileCountY>1</TileCountY>
    <YOrigin>top</YOrigin>
  </DataWindow>
  <Projection>EPSG:900913</Projection>
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <BandsCount>3</BandsCount>
  <Cache/>
</GDAL_WMS>'
layers <- c("AerialPhoto2020",
            "AerialPhoto2021",
            "ESgisMapBookPUBLIC",
            "HillshadeGrey",
            "Hillshade",
            "Orthophoto",
            "SimpleBasemap",
            "Tasmap100K",
            "Tasmap250K",
            "Tasmap25K",
            "Tasmap500K",
            "TasmapRaster",
            "TopographicGrayScale",
            "Topographic")
#' Title
#'
#' @param x a raster to define the extent/dimension/projection (later something elses too)
#' @param layer name or number (3:14 works)
#' @param band
#' @param resample
#'
#' @return
#' @export
#'
#' @examples
#' listmap()
listmap <- function(x, layer = "Topographic", band = 1:3, resample = "bilinear") {
  if (is.numeric(layer)) layer <- layers[layer]
  if (missing(x)) {
    ex <- c(15948203, 16639980, -5520011, -4759057)
    x1 <- raster::raster(raster::extent(ex), nrows = 1024, ncols = 1024, crs = "EPSG:3857")
    x1[] <- NA_integer_


  } else {
    x1 <- x
  }
  x <- raster::brick(list(x1, x1, x1))
  src <- sprintf(template, layer)
  v <- vapour::vapour_warp_raster(src,
                             projection = raster::projection(x), dimension = dim(x)[2:1], extent = ex, band = band, band_output_type = "Int32", resample = resample)
  raster::setValues(x, do.call(cbind, v))
}
