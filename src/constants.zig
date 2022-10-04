
pub const img_height = 1080;
pub const img_width = 1920;
pub const tile_height = 15;
pub const tile_width = 30;
pub const img_rows = img_height / tile_height;
pub const img_columns = img_width / tile_width;
pub const pixel_count = img_height * img_width;

comptime {
    if (tile_height % 2 != 1) {
        @compileError("tile_height should be an odd number!");
    }
    if (img_rows % 1 != 0) {
        @compileError("'img_height / tile_height' should be a whole number!");
    }
    if (img_columns % 1 != 0) {
        @compileError("'img_width / tile_width' should be a whole number!");
    }
}
