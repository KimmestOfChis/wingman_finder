import './App.css';
import SignUp from './components/SignUp/SignUp'
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";

function App() {
  return (
    <div className="App">
      <header className="App-header">
          <Router>
            <Switch>
              <Route path="/sign-up">
                <SignUp />
              </Route>
            </Switch>
          </Router>
      </header>
    </div>
  );
}

export default App;
