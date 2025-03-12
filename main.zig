const std = @import("std");

fn DoublyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = T;

        first: ?*Node = null,
        last: ?*Node = null,

        fn init(node: *Node) Self {
            return .{
                .first = node,
                .last = node,
            };
        }

        pub fn insertafter(list: *Self, node: *Node, new_node: *Node) void {
            new_node.prev = node;
            if (node.next) |next_node| {
                new_node.next = next_node;
                next_node.prev = new_node;
            } else {
                // Last element
                new_node.next = null;
                list.last = new_node;
            }
            node.next = new_node;
        }

        pub fn insertbefore(list: *Self, node: *Node, new_node: *Node) void {
            new_node.next = node;
            if (node.prev) |prev_node| {
                new_node.prev = prev_node;
                prev_node.next = new_node;
            } else {
                // first element
                new_node.prev = null;
                list.first = new_node;
            }
            node.prev = new_node;
        }

        pub fn append(list: *Self, new_node: *Node) void {
            if (list.last) |last| {
                list.insertafter(last, new_node);
            } else {
                list.prepend(new_node);
            }
        }

        pub fn prepend(list: *Self, new_node: *Node) void {
            if (list.first) |first| {
                list.insertbefore(first, new_node);
            } else {
                list.first = new_node;
                list.last = new_node;
                new_node.next = null;
                new_node.prev = null;
            }
        }

        pub fn traverse(list: *Self) void {
            var it = list.first;
            var index: u32 = 1;
            while (it) |node| : (it = node.next) {
                //std.debug.assert(node.data == index);
                std.debug.print("data: .{d}\n", .{node.data});
                index += 1;
            }
        }

        pub fn remove(list: *Self, node: *Node) void {
            if (node.prev) |prev_node| {
                prev_node.next = node.next;
            } else {
                // First element
                list.first = node.next;
            }

            if (node.next) |next_node| {
                next_node.prev = node.prev;
            } else {
                // last element
                list.last = node.prev;
            }
        }
    };
}

pub fn main() !void {
    const Node = struct {
        data: u32,
        prev: ?*@This() = null,
        next: ?*@This() = null,

        fn init(value: u32) @This() {
            return .{ .data = value };
        }
    };

    const L = DoublyLinkedList(Node);
    var list: L = .{};
    var node1: Node = .init(1);
    var node2: Node = .init(2);
    var node3: Node = .init(3);
    var node4: Node = .init(4);
    var node5: Node = .init(5);

    list.prepend(&node1);
    list.append(&node4);
    list.append(&node5);
    list.insertafter(&node1, &node2);
    list.insertbefore(&node4, &node3);
    list.remove(&node1);
    std.debug.print("removed data: {d}\n", .{node1.data});

    // Traverse forwards.
    list.traverse();
}
