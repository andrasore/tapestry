const std = @import("std");
const constants = @import("./constants.zig");
const generator = @import("./generator.zig");

fn writePpmImage(image: *generator.Image) !void {
    const out_file = try std.fs.cwd().createFile("image.ppm", .{ .read = true });
    defer out_file.close();

    // PPM header is ASCII based
    const header = std.fmt.comptimePrint("P6 {d} {d} 255\n", .{ constants.img_width, constants.img_height });

    _ = try out_file.write(header);

    for (image) |row| {
        for (row) |pixel| {
            _ = try out_file.write(&[_]u8{ pixel.r, pixel.g, pixel.b });
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var alloc = gpa.allocator();
    const image = try generator.generateImg(alloc);
    defer alloc.free(image);
    try writePpmImage(image);
}
