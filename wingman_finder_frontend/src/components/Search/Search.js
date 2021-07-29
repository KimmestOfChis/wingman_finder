import { React, useState, useEffect } from 'react';
import Banner from '../Banner/Banner'
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import Container from '@material-ui/core/Container';
import { makeStyles } from '@material-ui/core/styles';
import SearchChip from '../SearchChip/SearchChip';
import Typography from '@material-ui/core/Typography';

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
          {state.searchParams.sims &&
            <SearchChip 
            title="I'm looking for someone who plays" 
            items={state.searchParams.sims} 
            clickHandler={handleClick} 
            type="Sim"
            selection={state.selectedParams.selectedSim}
          />
        }
          {state.selectedParams.selectedSim && 
            <SearchChip 
              title="With the following modules" 
              items={state.searchParams.modules} 
              clickHandler={handleClick} 
              type="Modules"
              selection={state.selectedParams.selectedModules}
            />
          }
          {state.selectedParams.selectedSim && 
            <SearchChip 
              title="and the following maps" 
              items={state.searchParams.maps} 
              clickHandler={handleClick} 
              type="Maps"
              selection={state.selectedParams.selectedMaps}
            />
          }
          {state.selectedParams.selectedSim && 
            <SearchChip 
              title="in the following timezones" 
              items={state.searchParams.timezones} 
              clickHandler={handleClick} 
              type="Timezones"
              selection={state.selectedParams.selectedTimezones}
            />  
          }
          <Button
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