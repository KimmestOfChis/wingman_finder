import { React, useState } from 'react';
import Avatar from '@material-ui/core/Avatar';
import Banner from '../Banner/Banner'
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import TextField from '@material-ui/core/TextField';
import Link from '@material-ui/core/Link';
import Grid from '@material-ui/core/Grid';
import LockOutlinedIcon from '@material-ui/icons/LockOutlined';
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
    userParams: {
      username: "",
      password: "",
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

  const submitUser = () => {
    fetch('/api/log_in',{
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(state.userParams),
    })
    .then((response) => {
      return <Redirect to='/'  />
    })
    .catch((error_response) => {
      setState({ errors: error_response.errors})
    })
  }

  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlinedIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          Log In
        </Typography>
        <form className={classes.form} noValidate>
        <Banner errors={state.errors} />
          <Grid container spacing={2}>
            <Grid item xs={12}>
              <TextField
                variant="outlined"
                required
                fullWidth
                id="username"
                label="Username"
                name="username"
                onChange={handleInput}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                variant="outlined"
                required
                fullWidth
                name="password"
                label="Password"
                type="password"
                id="password"
                autoComplete="current-password"
                onChange={handleInput}
              />
            </Grid>
          </Grid>
          <Button
            data-testid="log-in-button"
            type="button"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            onClick={() => { submitUser() }}
          >
            Log In
          </Button>
          <Grid container justify="flex-end">
            <Grid item>
              <Link href="/sign-up" variant="body2">
                Don't have an account? Sign up here!
              </Link>
            </Grid>
          </Grid>
        </form>
      </div>
    </Container>
  );
}
