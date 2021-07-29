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
    selectedParams: {
      selectedSim: null,
      selectedModules: [],
      selectedMaps: [],
      selectedTimezones: []
    }
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
      handleErrors(error_response.errors)
    })
  }

  const getSearchParams = (sim) => {
    fetch(`/get-search-params?sim=${sim}`, {
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
          modules: response['data']['modules'],
          maps: response['data']['maps'], 
          timezones: response['data']['timezones']
        }
      }))
    })
    .catch((error_response) => {
      handleErrors(error_response.errors)
    })
  }

  useEffect(() => {
    getSims();
  }, []);

  const search = () => {
    fetch('/search',{
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(state.selectedParams),
    })
    .then((response) => {
      // we'll have to do something here
    })
    .catch((error_response) => {
      handleErrors(error_response.errors)
    })
  }

  const handleErrors = (errors) => {
    setState((prevState) => ({
      ...prevState,
      errors: errors
    }))
  }

  const updateSelections = (param, textContent) => {
    let updatedArray
    if(state.selectedParams[param].includes(textContent)) {
      updatedArray = state.selectedParams[param].filter(x => x !== textContent)
    } else {
      updatedArray = state.selectedParams[param].concat(textContent)
    } 
    return updatedArray
  }

  const updateSimAndPopulateParams = (textContent) => {
    getSearchParams(textContent)
    return textContent
  }
  
  const handleClick = (e, param) => {
    const updateKey = `selected${param}`
    const updateValue = param === "Sim" ? updateSimAndPopulateParams(e.currentTarget.textContent) : updateSelections(updateKey, e.currentTarget.textContent)
    setState((prevState) => ({
      ...prevState,
      selectedParams: {
        ...prevState.selectedParams,
        [updateKey]: updateValue
      }
    }))
  }

  return (
    <Container component="main" >
      <CssBaseline />
      <Banner errors={state.errors} />
      <div className={classes.paper}>
        <Typography component="h1" variant="h5">
          Find Your Wingman
        </Typography>
        <form className={classes.form} noValidate>
        <h3>
            I'm looking for someone who plays
        </h3>
        <Grid>
            {state.searchParams.sims && state.searchParams.sims.map(sim => { 
                return(
                  <Chip 
                    key={sim}
                    value={sim}
                    label={sim}
                    onClick={(e) => { handleClick(e, "Sim")}}
                    variant={state.selectedParams.selectedSim === sim ? "default" : "outlined"}
                  />
                )
            })}
        </Grid>
        {state.selectedParams.selectedSim && <>
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
                      variant={state.selectedParams.selectedModules.includes(module) ? "default" : "outlined"}
                    />
                  )
              })}
          </Grid>
        </>}
        {state.selectedParams.selectedSim && <>
          <h3>and the following maps</h3>
          <Grid>
            {state.searchParams.maps.map(map => { 
                return(
                  <Chip 
                    key={map}
                    value={map}
                    label={map}
                    onClick={(e) => { handleClick(e, "Maps") }}
                    variant={state.selectedParams.selectedMaps.includes(map) ? "default" : "outlined"}
                  />
                )
            })}
        </Grid>
        </>}
        {state.selectedParams.selectedSim && <>
          <h3>in the following timezones</h3>
          <Grid>
              {state.searchParams.timezones.map(timezone => { 
                  return(
                    <Chip 
                      key={timezone}
                      value={timezone}
                      label={timezone}
                      onClick={(e) => { handleClick(e, "Timezones") }}
                      variant={state.selectedParams.selectedTimezones.includes(timezone) ? "default" : "outlined"}
                    />
                  )
              })}
          </Grid>
        </>}
          <Button
            data-testid="search-button"
            type="button"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            onClick={search}
          >
            Search
          </Button>
        </form>
      </div>
    </Container>
  );
}