class Index extends React.Component {

  constructor() {
    super()
    this.state={
      resultData: false,
      errors: "",
      speechInput: true,
      browserType: "",
    }
    this.webSpeechResults = this.webSpeechResults.bind(this)
    this.handleTranscriptErrors = this.handleTranscriptErrors.bind(this)
    this.handleInputType = this.handleInputType.bind(this)
    this.handleBrowserType = this.handleBrowserType.bind(this)
    this.browserCheck = this.browserCheck.bind(this)
    this.sendImage = this.sendImage.bind(this)
    this.sendReqeust = this. sendReqeust.bind(this)

  }

  browserCheck(){
    let isChrome = !!window.chrome && !!window.chrome.webstore;
    if(!isChrome){
      this.handleBrowserType("true")
    } else {console.log("user is running chrome")}
  }

  handleBrowserType(notChrome){
    this.setState({
      browserType: notChrome,
    })
  }

  webSpeechResults(data) {
    this.setState({
      resultData: data
    })
  }

  handleTranscriptErrors(error){
    this.setState({
      errors: error
    })
  }

  handleInputType(e) {
    e.preventDefault()
    if (this.state.speechInput === true){
      $(e.target).text("(click here for speech input instead)")
      this.setState({
        speechInput: false
      })
    }else if (this.state.speechInput === false){
      $(e.target).text("(click here for text input instead)")
      this.setState({
        speechInput: true
      })
    }
  }

  sendReqeust(){
    let that = this
    let context = canvas.getContext('2d');
    context.drawImage(video, 0, 0, 640, 480);
    $("#canvas").hide()
    let dataURL = canvas.toDataURL();
    $.ajax({
      url: "/users/"+that.props.current_user.id+"/interim_results",
      method: "POST",
      data: {image: dataURL}
    })
  }

  sendImage(startSending){
    let that = this
      if (startSending.length >=3){
        request = setInterval(function() {
          that.sendReqeust()
        }, 3333);
    } else {
      clearInterval(request)}
  }

  componentWillMount(){
    this.browserCheck()
  }

  render(){
    return(
      <div className="starter-template container-padding">
        <div className="wrapper">
          <div className="welcome">
          {(this.state.browserType.length > 0) && <CheckBrowser />}
            <h1 id="just-play">Just Press Start.</h1>
            <a href="/" onClick={this.handleInputType}><p>(click here for text input instead)</p></a>
          </div>

          {this.state.speechInput && <WebSpeech currentUser={this.props.current_user} results={this.webSpeechResults} errorCheck={this.handleTranscriptErrors} startCamera={this.sendImage}/>}

          {!this.state.speechInput && <TextForm currentUser={this.props.current_user} results={this.webSpeechResults} errorCheck={this.handleTranscriptErrors} />}

          {(this.state.errors.length > 0) && <Errors />}

          {this.state.resultData && <ResultsShow result_data={this.state.resultData} />}
        </div>
        <div className="camera-image">
          <Camera/>
        </div>

      </div>
    )
  }
}
