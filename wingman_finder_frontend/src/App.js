import './App.css';
import LogIn from './components/LogIn/LogIn'
import Search from './components/Search/Search'
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
              <Route path="/log-in">
                <LogIn />
              </Route> 
              <Route path="/">
                <Search />
              </Route> 
            </Switch>
          </Router>
      </header>
    </div>
  );
}

export default App;
