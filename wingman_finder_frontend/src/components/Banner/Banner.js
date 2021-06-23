import { Alert } from '@material-ui/lab';
import { React } from 'react';

export default function Banner({errors}) {
    if(errors.length > 0) {
        return(
            <div data-testid="banner">
             {errors.map((error, index) => {
                 return(
                    <Alert key={index} severity="error">
                        {error}
                    </Alert>
                 )
                })}
              <br />
            </div>
        )
    } else {
     return(
         <></>
     )
    }
}