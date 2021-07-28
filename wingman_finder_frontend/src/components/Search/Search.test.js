import { fireEvent, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';


import Search from './Search'

const sims = ["DCS", "IL2", "Falcon BMS"]

describe('Search', () => {
    beforeAll(() => jest.spyOn(window, 'fetch'))

    afterEach(() => {
        jest.resetAllMocks();
    });


    describe('populating search parameters', () => {
        test('a sim list is populated on load', async () => { 
          window.fetch.mockResolvedValueOnce({ data: sims })

          await act(async() => {
            render(<Search />)
          });

            expect(window.fetch).toHaveBeenCalledWith(
            '/sims',
            {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
              },
            },
          )

          expect(window.fetch).toHaveBeenCalledTimes(1)
          
          expect(screen.getByText("DCS")).toBeInTheDocument()
          expect(screen.getByText("IL2")).toBeInTheDocument()
          expect(screen.getByText("Falcon BMS")).toBeInTheDocument()
        })

        test('getSims is broken', async () => { 
          window.fetch.mockRejectedValueOnce({errors: ['its broke']})

          await act(async() => {
            render(<Search />)
          });
          
          expect(screen.getByText("its broke")).toBeInTheDocument()
        })

        test('modules and maps are populated once a sim is selected', async () => {
          await act(async() => {
            window.fetch.mockResolvedValueOnce({ data: sims })
            render(<Search />)          
          });

          window.fetch.mockResolvedValueOnce({ data: {
            modules: ['module1'],
            maps: ['map1'],
            timezones: ['EST', 'PST']
           } })

          await act(async() => {
            userEvent.click(screen.getByText("DCS"))         
          });

          expect(window.fetch).toHaveBeenCalledTimes(2)

          expect(window.fetch).toHaveBeenCalledWith( 
            '/sims',
            {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
              },
            }
          )

          expect(window.fetch).toHaveBeenCalledWith(
            "/get-search-params?sim=DCS",
            {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
              },
            },
          )
        })

        test('getSearchParams is broken', async () => {
          await act(async() => {
            window.fetch.mockResolvedValueOnce({ data: sims })
            render(<Search />)          
          });

          window.fetch.mockRejectedValueOnce({errors: ['its broke']})

          await act(async() => {
            userEvent.click(screen.getByText("DCS"))         
          });

          expect(screen.getByText("its broke")).toBeInTheDocument()
        })
    })
    describe('search', () => {
      test('it should search with parameters', async () => {
        await act(async() => {
          window.fetch.mockResolvedValueOnce({ data: sims })
          render(<Search />)          
        });
  
        window.fetch.mockResolvedValueOnce({ data: {
          modules: ['module1'],
          maps: ['map1'],
          timezones: ['EST', 'PST']
         } })
  
        await act(async() => {   
          userEvent.click(screen.getByText("DCS")) 
        });

        await act(async() => {   
          userEvent.click(screen.getByText("module1"))  
          userEvent.click(screen.getByText("map1")) 
          userEvent.click(screen.getByText("EST")) 
          userEvent.click(screen.getByText("PST"))
        });

        window.fetch.mockResolvedValueOnce({
          ok: true,
          json: async () => ({success: true}),
        })
        
        userEvent.click(screen.getByText("Search"))

        expect(window.fetch).toHaveBeenCalledTimes(3)

        expect(window.fetch).toHaveBeenCalledWith(
          "/search",
          {
            method: 'POST',
            body: "{\"selectedSim\":\"DCS\",\"selectedModules\":[\"module1\"],\"selectedMaps\":[\"map1\"],\"selectedTimezones\":[\"PST\"]}",
            headers: {
              'Content-Type': 'application/json',
            },
          },
        )
      })

      test('search is broken', async () => {
        await act(async() => {
          window.fetch.mockResolvedValueOnce({ data: sims })
          render(<Search />)          
        });
  
        window.fetch.mockResolvedValueOnce({ data: {
          modules: ['module1'],
          maps: ['map1'],
          timezones: ['EST', 'PST']
         } })
  
        await act(async() => {   
          userEvent.click(screen.getByText("DCS")) 
        });

        await act(async() => {   
          userEvent.click(screen.getByText("module1"))  
          userEvent.click(screen.getByText("map1")) 
          userEvent.click(screen.getByText("EST")) 
          userEvent.click(screen.getByText("PST"))
        });

        window.fetch.mockRejectedValueOnce({errors: ['its broke']})

        await act(async() => {   
          userEvent.click(screen.getByText("Search"))
        })

        expect(screen.getByText("its broke")).toBeInTheDocument()
      })
    })
})