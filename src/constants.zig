
pub const img_height = 1080;
pub const img_width = 1920;
pub const tile_size = 40;
pub const img_rows = img_height / tile_size;
pub const img_columns = img_width / tile_size;
pub const pixel_count = img_height * img_width;

comptime {
    if (img_rows % 1 != 0) {
        @compileError("'img_height / tile_size' should be a whole number!");
    }
    if (img_columns % 1 != 0) {
        @compileError("'img_width / tile_size' should be a whole number!");
    }
}
