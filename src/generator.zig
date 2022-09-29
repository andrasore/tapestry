const std = @import("std");
const constants = @import("./constants.zig");
const Allocator = std.mem.Allocator;
const Random = std.rand.Random;

const Pixel = struct {
    r: u8,
    g: u8,
    b: u8
};

var pixel_presets = [4]Pixel{
    Pixel{ .r = 100, .g = 30, .b = 150 },
    Pixel{ .r = 150, .g = 130, .b = 50 },
    Pixel{ .r = 100, .g = 180, .b = 50 },
    Pixel{ .r = 0, .g = 100, .b = 150 },
};

fn fillSquare(img: *Image, offset_x: usize, offset_y: usize, rand: Random) void {
    const choice = rand.intRangeLessThan(usize, 0, pixel_presets.len);
    var x: usize = 0;
    while (x < constants.tile_size) : (x += 1) {
        var y: usize = 0;
        while (y < constants.tile_size) : (y += 1) {
            img[x + offset_x][y + offset_y] = pixel_presets[choice];
        }
    }
}

pub const Image = [constants.img_height][constants.img_width]Pixel;

pub fn generateImg(alloc: Allocator) !*Image {
    var img = try alloc.create(Image);

    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    var rand = prng.random();

    var row: usize = 0;
    while (row < constants.img_rows) : (row += 1) {
        var column: usize = 0;
        while (column < constants.img_columns) : (column += 1) {
            const offset_x = row * constants.tile_size;
            const offset_y = column * constants.tile_size;
            fillSquare(img, offset_x, offset_y, rand);
        }
    }

    return img;
}
