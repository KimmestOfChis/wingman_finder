import Grid from '@material-ui/core/Grid';
import Chip from '@material-ui/core/Chip';

export default function SearchChip({title, items, clickHandler, type, selection}) {
    const selectVariant = (item) => {
        if(selection && ((type === "Sim" && selection === item) || selection.includes(item))){
            return "default"
         } else {
            return "outlined"
        }
    } 
   
        return(
            <>
                <h3>
                    {title}
                </h3>
                <Grid>
                    {items.map(item => { 
                        return(
                            <Chip 
                                key={item}
                                value={item}
                                label={item}
                                onClick={(e) => {clickHandler(e, type)}}
                                variant={selectVariant(item)}
                            />
                        )
                    })}
                </Grid>
            </>
        )
}