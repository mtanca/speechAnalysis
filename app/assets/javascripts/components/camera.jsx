class Camera extends React.Component{

  constructor(){
    super()
    this.state={
      data: "",
    }
    // this.handleClick = this.handleClick.bind(this)
  }

  componentDidMount(){
    $("#video").hide()
    // video element to capture for canvas
    var video = document.getElementById('video');
    if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
        video.src = window.URL.createObjectURL(stream);
        video.play();
      });
    }
  }

  render(){
    return(
      <div>
        <video id="video" width="640" height="480" autoPlay></video>
        <canvas id="canvas" width="640" height="480"></canvas>
      </div>
    )
  }
}
