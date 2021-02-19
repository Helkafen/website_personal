import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

var app = Elm.Main.init({
  node: document.getElementById('elmroot')
});

app.ports.login.subscribe(function(message) {
  console.log(message[0]);
  var dataset = JSON.parse(message[0]);
  var divid   = message[1];
  Plotly.newPlot( document.getElementById(divid), dataset, { margin: { t: 0 } } );
});


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
