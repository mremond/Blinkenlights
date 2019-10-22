import NIO

private final class PrintHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    
    var buffer: ByteBuffer?
    
    func channelActive(context: ChannelHandlerContext) {
        buffer = context.channel.allocator.buffer(capacity: 2000)
        print("Client is connected to server")
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var byteBuffer = self.unwrapInboundIn(data)
        buffer?.writeBuffer(&byteBuffer)

    }
    
    func channelReadComplete(context: ChannelHandlerContext) {
        if let length = buffer?.readableBytes {
            if let str = buffer?.readString(length: length) {
                print(str)
            }
        }
        buffer?.clear()
    }
    
    func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("Channel error: \(error)")
    }
    
    func channelInactive(context: ChannelHandlerContext) {
        print("Client is disconnected ")
    }
}

let evGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
defer {
    try! evGroup.syncShutdownGracefully()
}

let bootstrap = ClientBootstrap(group: evGroup)
    .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .channelInitializer { channel in
        channel.pipeline.addHandler(PrintHandler())
        }

// Once the Bootstrap client is setup, we can connect
do {
    _ = try bootstrap.connect(host: "towel.blinkenlights.nl", port: 23).wait()
} catch let err {
    print("Connection error: \(err)")
}

// Wait for return before disconnecting
_ = readLine()
