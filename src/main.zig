const std = @import("std");
const Allocator = std.mem.Allocator;

fn readSize(allocator: Allocator) struct { x: u32, y: u32 } {
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    _ = args_iter.next(); // bin name
    const x = args_iter.next() orelse "";
    const y = args_iter.next() orelse "";

    return .{
        .x = std.fmt.parseInt(u32, x, 10) catch 1920,
        .y = std.fmt.parseInt(u32, y, 10) catch 1080
    };
}

const Pixel = struct {
    r: u8,
    g: u8,
    b: u8
};

fn createImage(allocator: Allocator, x: u32, y: u32) !std.ArrayList(Pixel) {
    var image = std.ArrayList(Pixel).init(allocator);
    try image.ensureTotalCapacity(x * y);
    try image.appendNTimes(Pixel{ .r = 127, .g =60, .b = 120}, x * y);
    return image;
}

fn writePpmImage(allocator: Allocator, x: u32, y: u32, image: std.ArrayList(Pixel)) !void {
    const out_file = try std.fs.cwd().createFile("image.ppm", .{ .read = true });
    defer out_file.close();

    // PPM header is ASCII based
    const header = try std.fmt.allocPrint(allocator, "P6 {d} {d} 255\n", .{ x, y });

    _ = try out_file.write(header);

    for (image.items) |pixel| {
        _ = try out_file.write(&[_]u8{ pixel.r, pixel.g, pixel.b });
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    const size = readSize(allocator);
    const image = try createImage(allocator, size.x, size.y);
    defer image.deinit();

    try writePpmImage(allocator, size.x, size.y, image);
}
