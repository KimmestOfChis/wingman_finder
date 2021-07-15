import { React, useState } from 'react';
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


export default function SignUp() {
  const classes = useStyles();
  const initialState = {
    errors: [],
    searchParams: {
        sims: ["DCS", "IL2"],
        modules: [],
        maps: [],
        timezones: []
    }
  }

  const [state, setState] = useState(initialState)

  const handleInput = (e) => {
    setState((prevState) => ({
      ...prevState,
      userParams: {
        ...prevState.userParams,
        [e.target.name]: e.target.value
      }
    }))
  }

  const search = (e) => {

  }

  const handleClick = () => {

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
                <Chip 
                label={sim}
                onClick={handleClick}
                variant="outlined"
                />
            })}
        </Grid>
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