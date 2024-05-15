var ws; // Websocket connection

window.addEventListener("load", () => {
  connectWebSocket();
  addButtonEventListeners();
}); 

// Adds event listeners to the buttons so that the appropriate websocket messages are sent
function addButtonEventListeners() {
  function bindLeftOrRight(button) {
    // Down event, send button id
    function down(e) {
      ws.send(e.target.id);
    }

    // Up event, stop the servo and refresh page state
    function up(e) {
      ws.send("stop-button");
      ws.send("refresh-button");
    }

    // Key press event, send the button id based on the key pressed
    function keys(e) {
      // Buttons on keyboard, as mapped to the ids of HTML buttons
      let keyDict = {
        "ArrowLeft": "left-button",
        "ArrowRight": "right-button"
      }

      // Check if the key pressed is one of left or right, and send the appropriate value
      if(e.key in keyDict) {
        ws.send(keyDict[e.key])
      }
    }

    // Mouse clicks
    button.addEventListener("mousedown", down);
    button.addEventListener("mouseup", up);

    // Touch
    button.addEventListener("touchstart", (e) => {
      e.preventDefault();
      down(e);
    });
    button.addEventListener("touchend", up);

    // Left and right arrow keys
    window.addEventListener("keydown", keys);
    window.addEventListener("keyup", up);
  }

  let buttons = document.getElementsByTagName("button");

  for(button of buttons) {
    switch(button.id) {
      case "left-button":
        bindLeftOrRight(button);
        break;
      case "right-button":
        bindLeftOrRight(button);
        break;
      case "refresh-button":
        button.addEventListener("click", (e) => {
          ws.send(e.target.id);
        });
        break;
      case "time-button":
        button.addEventListener("click", (e) => {
          ws.send(e.target.id);
        });
        break;
      default:
        button.addEventListener("click", (e) => {
          ws.send(e.target.id);
          ws.send("refresh-button");
        });
    }
  } 
}

function connectWebSocket(e) {
  // Binds the left or right button on the page to send it's id via websocket connection, binds mouse, touch and key events
  let hostname = `ws://${window.location.hostname}/ws`;
  ws = new WebSocket(hostname);

  // When the connection is opened, refresh the page state
  ws.addEventListener("open", (e) => {
    console.log(`Websocket connection to ${hostname} established.`);
    ws.send("refresh-button"); // Refresh the state of the door opener
  });

  // Close connection on error
  ws.addEventListener("error", (e) => {
    console.log(`Connection to ${hostname} encountered an error, closing socket...`);
    ws.close();
  });

  // Attempt to reconnect if the connection is dropped
  ws.addEventListener("close", (e) => {
    let timeout = 10000;
    console.log(`Connection to ${hostname} dropped, attempting to reconnect in ${timeout / 1000} seconds...`);
    setTimeout(function() {
      connectWebSocket();
    }, timeout);
  });

  // Updates the state on the page from a JSON object recieved and deserialised
  // Keys are commensurate with id attributes
  ws.addEventListener("message", (e) => {
    let state = JSON.parse(e.data);
    for(const [k, v] of Object.entries(state)) {
      document.getElementById(k).innerHTML = v;
    }

    // Show or hide the time taken to actuate the door and door timing errors dependent on whether these values are provided
    if(state["time-state"]) {
      document.getElementById("time-info").style.display = "block";
    } else {
      document.getElementById("time-info").style.display = "none";
    }

    if(state["time-error"]) {
      document.getElementById("time-error").style.display = "block";
    } else {
      document.getElementById("time-error").style.display = "none";
    }
  });
}
