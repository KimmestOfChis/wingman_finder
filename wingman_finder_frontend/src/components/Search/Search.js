import { React, useState, useEffect } from 'react';
import Banner from '../Banner/Banner'
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import Grid from '@material-ui/core/Grid';
import Chip from '@material-ui/core/Chip';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';
import  { Redirect } from 'react-router-dom'

const useStyles = makeStyles((theme) => ({
  paper: {
    marginTop: theme.spacing(8),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main,
  },
  form: {
    width: '100%', // Fix IE 11 issue.
    marginTop: theme.spacing(3),
  },
  submit: {
    margin: theme.spacing(3, 0, 2),
  },
}));


export default function Search() {
  const classes = useStyles();
  const initialState = {
    errors: [],
    searchParams: {
        sims: [],
        modules: [],
        maps: [],
        timezones: []
    },
    selectedSim: null,
    selectedModules: [],
    selectedMaps: [],
    selectedTimezones: []
  }

  const [state, setState] = useState(initialState)

  const getSims = () => {
    fetch('/sims', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    })
    .then((response) => {
      setState((prevState) => ({
        ...prevState,
        searchParams: {
          ...prevState.searchParams,
          sims: response['data']
        }
      }))
    })
    .catch((error_response) => {
      setState({ errors: error_response.errors})
    })
  }

  useEffect(() => {
    getSims();
  }, []);

  const search = (e) => {

  }

  const updateSelections = (param, textContent) => {
    let updatedArray
    if(state[param].includes(textContent)) {
      updatedArray = state[param].filter(x => x !== textContent)
    } else {
      updatedArray = state[param].concat(textContent)
    } 
    return updatedArray
  }
  
  const handleClick = (e, param) => {
    const updateKey = `selected${param}`
    const updateValue = param === "Sim" ? e.currentTarget.textContent : updateSelections(updateKey, e.currentTarget.textContent)
  
    setState((prevState) => ({
      ...prevState,
      [updateKey]: updateValue
    }))
  }

  return (
    <Container component="main" >
      <CssBaseline />
      <div className={classes.paper}>
        <Typography component="h1" variant="h5">
          Find Your Wingman
        </Typography>
        <form className={classes.form} noValidate>
        <h3>
            I'm looking for someone who plays
        </h3>
        <Grid>
            {state.searchParams.sims.map(sim => { 
                return(
                  <Chip 
                    key={sim}
                    value={sim}
                    label={sim}
                    onClick={(e) => { handleClick(e, "Sim")}}
                    variant={state.selectedSim === sim ? "default" : "outlined"}
                  />
                )
            })}
        </Grid>
        {state.selectedSim && <>
          <h3>With the following modules</h3>
          <Grid>
              {state.searchParams.modules.map(module => { 
                  return(
                    <Chip 
                      key={module}
                      value={module}
                      label={module}
                      name="Module"
                      onClick={(e) => { handleClick(e, "Modules") }}
                      variant={state.selectedModules.includes(module) ? "default" : "outlined"}
                    />
                  )
              })}
          </Grid>
        </>}
        {state.selectedSim && <>
          <h3>and the following maps</h3>
          <Grid>
            {state.searchParams.maps.map(map => { 
                return(
                  <Chip 
                    key={map}
                    value={map}
                    label={map}
                    onClick={(e) => { handleClick(e, "Maps") }}
                    variant={state.selectedMaps.includes(map) ? "default" : "outlined"}
                  />
                )
            })}
        </Grid>
        </>}
        {state.selectedSim && <>
          <h3>in the following timezones</h3>
          <Grid>
              {state.searchParams.timezones.map(timezone => { 
                  return(
                    <Chip 
                      key={timezone}
                      value={timezone}
                      label={timezone}
                      onClick={(e) => { handleClick(e, "Timezones") }}
                      variant={state.selectedTimezones.includes(timezone) ? "default" : "outlined"}
                    />
                  )
              })}
          </Grid>
        </>}
        <Banner errors={state.errors} />
          <Button
            data-testid="search-button"
            type="button"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            onClick={() => { search() }}
          >
            Search
          </Button>
        </form>
      </div>
    </Container>
  );
}