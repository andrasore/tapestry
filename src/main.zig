const std = @import("std");
const expect = @import("std").testing.expect;

const Pixel = struct {
    r: u8,
    g: u8,
    b: u8
};

const img_height = 1080;
const img_width = 1920;
const tile_size = 40;
const img_rows = img_height / tile_size;
const img_columns = img_width / tile_size;
const pixel_count = img_height * img_width;

comptime {
    if (img_rows % 1 != 0) {
        @compileError("'img_height / tile_size' should be a whole number!");
    }
    if (img_columns % 1 != 0) {
        @compileError("'img_width / tile_size' should be a whole number!");
    }
}

const Image = [img_height][img_width]Pixel;

var img_static = std.mem.zeroes(Image);

fn fillSquare(offset_x: usize, offset_y: usize) void {
    var x: usize = 0;
    while (x < tile_size) : (x += 1) {
        var y: usize = 0;
        while (y < tile_size) : (y += 1) {
            img_static[x + offset_x][y + offset_y] = Pixel{ .r = 100, .g = 30, .b = 150 };
        }
    }
}

fn createImage() Image {
    var row: usize = 0;
    while (row < img_rows) : (row += 1) {
        var column: usize = 0;
        while (column < img_columns) : (column += 1) {
            const offset_x = row * tile_size;
            const offset_y = column * tile_size;
            fillSquare(offset_x, offset_y);
        }
    }
    return img_static;
}

fn writePpmImage(image: Image) !void {
    const out_file = try std.fs.cwd().createFile("image.ppm", .{ .read = true });
    defer out_file.close();

    // PPM header is ASCII based
    const header = std.fmt.comptimePrint("P6 {d} {d} 255\n", .{ img_width, img_height });

    _ = try out_file.write(header);

    for (image) |row| {
        for (row) |pixel| {
            _ = try out_file.write(&[_]u8{ pixel.r, pixel.g, pixel.b });
        }
    }
}

pub fn main() !void {
    const image = createImage();
    try writePpmImage(image);
}
