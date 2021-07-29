import { fireEvent, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';

import SearchChip from './SearchChip'

const sims = ["DCS", "IL2", "Falcon BMS"]
const modules = ['module1', 'module2', 'module3']

const outlined = "MuiButtonBase-root MuiChip-root MuiChip-outlined MuiChip-clickable"
const defaultClass = "MuiButtonBase-root MuiChip-root MuiChip-clickable"
describe('SearchChips', () => {
    describe('variants', () => {
        test('no chips are selected on render', () => {
            render(<SearchChip 
                title="I'm looking for someone who plays" 
                check={sims}
                items={sims} 
                type="Sim"
            />)
            
            expect(screen.queryAllByRole('button')[0].className).toBe(outlined)
            expect(screen.queryAllByRole('button')[1].className).toBe(outlined)
            expect(screen.queryAllByRole('button')[2].className).toBe(outlined)
        })

        test('only sim one chip is selected', () => {
            render(<SearchChip 
                title="I'm looking for someone who plays" 
                check={sims}
                items={sims} 
                type="Sim"
                selection="DCS"
            />)
            
            expect(screen.queryAllByRole('button')[0].className).toBe(defaultClass)
            expect(screen.queryAllByRole('button')[1].className).toBe(outlined)
            expect(screen.queryAllByRole('button')[2].className).toBe(outlined)
        })

        test('multiple child chips are selected', () => {
            render(<SearchChip 
                title="I'm looking for someone who plays" 
                items={modules} 
                type="Modules"
                selection={['module1', 'module2']}
            />)
            
            expect(screen.queryAllByRole('button')[0].className).toBe(defaultClass)
            expect(screen.queryAllByRole('button')[1].className).toBe(defaultClass)
            expect(screen.queryAllByRole('button')[2].className).toBe(outlined)
        })
    })
})