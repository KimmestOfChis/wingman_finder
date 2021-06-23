import { render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'

import Banner from './Banner'

describe('Banner', () => {
    describe('it renders', () => {
        test('with errors', () => { 
            const message1 = 'this is an error'
            const message2 = 'this is also an error'

            render(<Banner errors={[message1, message2]} />)

            expect(screen.getByText(message1)).toBeInTheDocument()
            expect(screen.getByText(message2)).toBeInTheDocument()
        })
        test('without errors', () => { 
            render(<Banner errors={[]}/>)
            expect(screen.queryByTestId('banner')).not.toBeInTheDocument()
        })
    })
})