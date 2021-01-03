import LLRtmp
import Logboard
import ReplayKit
import VideoToolbox

let logger = Logboard.with("com.llrtmp.Exsample.iOS.Screencast")

@available(iOS 10.0, *)
open class SampleHandler: RPBroadcastSampleHandler {
    private lazy var rtmpConnection: RTMPConnection = {
        let conneciton = RTMPConnection()
        conneciton.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusEvent), observer: self)
        conneciton.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        return conneciton
    }()

    private lazy var rtmpStream: RTMPStream = {
        RTMPStream(connection: rtmpConnection)
    }()

    deinit {
        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusEvent), observer: self)
    }

    override open func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        /*
        let logger = Logboard.with(LLRtmpIdentifier)
        let socket = SocketAppender()
        socket.connect("192.168.11.15", port: 22222)
        logger.level = .debug
        logger.appender = socket
        */
        logger.level = .debug
        Logboard.with(LLRtmpIdentifier).level = .trace
        rtmpConnection.connect(Preference.defaultInstance.uri!, arguments: nil)
    }

    override open func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            if let description = CMSampleBufferGetFormatDescription(sampleBuffer) {
                let dimensions = CMVideoFormatDescriptionGetDimensions(description)
                rtmpStream.videoSettings = [
                    .width: dimensions.width,
                    .height: dimensions.height ,
                    .profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel
                ]
            }
            rtmpStream.appendSampleBuffer(sampleBuffer, withType: .video)
        case .audioApp:
            break
        case .audioMic:
            rtmpStream.appendSampleBuffer(sampleBuffer, withType: .audio)
        @unknown default:
            break
        }
    }

    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        logger.info(notification)
        rtmpConnection.connect(Preference.defaultInstance.uri!)
    }

    @objc
    private func rtmpStatusEvent(_ status: Notification) {
        let e = Event.from(status)
        logger.info(e)
        guard
            let data: ASObject = e.data as? ASObject,
            let code: String = data["code"] as? String else {
            return
        }
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            rtmpStream.publish(Preference.defaultInstance.streamName!)
        default:
            break
        }
    }
}
