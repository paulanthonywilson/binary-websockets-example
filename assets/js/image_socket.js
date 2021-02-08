export class ImageSocket {
    constructor(img) {
        console.log("new image socket");
        this.img = img;
        this.ws_url = img.dataset.binaryWsUrl;
        this.scheduleHeartBeat();
    }

    updated() {
        this.ws_url = this.img.dataset.binaryWsUrl;
    }

    connect() {
        console.log("image socket connect");
        this.hasErrored = false;
        this.socket = new WebSocket(this.ws_url);
        let that = this;
        this.socket.onopen = () => { that.onOpen(); }
        this.socket.onclose = () => { that.onClose(); }
        this.socket.onerror = errorEvent => { that.onError(errorEvent); };
        this.socket.onmessage = messageEvent => { that.onMessage(messageEvent); };
        this.attemptReopen = true;
    }

    close() {
        this.attemptReopen = false;
        if (this.socket) this.socket.close();
        this.socket = null;
        clearTimeout(this.heartBeatId);
    }

    onOpen() {
        console.log("image socket ws opened");
    }

    onClose() {
        this.maybeReopen();
        console.log("image socket ws closed", this);
    }

    onError(errorEvent) {
        this.hasErrored = true;
        console.log("image socket error", errorEvent);
    }

    onMessage(messageEvent) {
        if (typeof messageEvent.data != "string") {
            this.binaryMessage(messageEvent.data);
        }
    }

    binaryMessage(content) {
        let oldImageUrl = this.img.src;
        let imageUrl = URL.createObjectURL(content);
        this.img.src = imageUrl;

        if (oldImageUrl != "") {
            URL.revokeObjectURL(oldImageUrl);
        }
    }

    isSocketClosed() {
        return this.socket == null || this.socket.readyState == 3;
    };

    maybeReopen() {
        let after = this.hasErrored ? 2000 : 0;
        setTimeout(() => {
            if (this.isSocketClosed() && this.attemptReopen) this.connect();
        }, after);
    };

    scheduleHeartBeat() {
        let that = this;
        this.heartBeatId = setTimeout(function () { that.sendHeartBeat(); }, 30000);
    }

    sendHeartBeat() {
        if (this.socket) {
            // Send a heartbeat message to the server to let it know
            // we're still alive, avoiding timeout.
            this.socket.send("💙");
        }
        this.scheduleHeartBeat();
    }
}