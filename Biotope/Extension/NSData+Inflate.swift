//
// https://github.com/1024jp/NSData-GZIP/blob/master/Sources/NSData%2BGZIP.swift
//

import Foundation

private let STREAM_SIZE: Int32 = Int32(sizeof(z_stream))
extension NSData {
    func inflatedData() -> NSData? {
        var stream = z_stream(
            next_in: UnsafeMutablePointer<Bytef>(self.bytes),
            avail_in: uint(self.length),
            total_in: 0,
            next_out: nil,
            avail_out: 0,
            total_out: 0,
            msg: nil,
            state: nil,
            zalloc: nil,
            zfree: nil,
            opaque: nil,
            data_type: 0,
            adler: 0,
            reserved: 0
        )

        if inflateInit2_(&stream, 47, ZLIB_VERSION, STREAM_SIZE) != Z_OK {
            return nil
        }

        var data = NSMutableData(length: self.length * 2)!
        var status: Int32
        repeat {
            if Int(stream.total_out) >= data.length {
                data.length += self.length / 2;
            }

            stream.next_out = UnsafeMutablePointer<Bytef>(data.mutableBytes).advancedBy(Int(stream.total_out))
            stream.avail_out = uInt(data.length) - uInt(stream.total_out)

            status = inflate(&stream, Z_SYNC_FLUSH)
        } while status == Z_OK

        if inflateEnd(&stream) == Z_OK {
            if status == Z_STREAM_END {
                data.length = Int(stream.total_out)
                return data
            }
        }
        return nil
    }
}
