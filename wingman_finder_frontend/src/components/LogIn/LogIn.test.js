import { fireEvent, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';


import LogIn from './LogIn'

let usernameField
let passwordField
let submitButton
const loginParams = {
    username: 'example!',
    password: 'some password'
}

describe('SignUp', () => {
    beforeAll(() => jest.spyOn(window, 'fetch'))
    beforeEach(() => {
        render(<LogIn />)

        usernameField = screen.getByLabelText('Username *')
        passwordField = screen.getByLabelText('Password *')
        submitButton = screen.getByTestId('log-in-button')
    })

    afterEach(() => {
        jest.resetAllMocks();
    });

    describe('fields fill in', () => {
        test('fields are filled in', () => { 
            const { username, password } = loginParams
            fireEvent.change(usernameField, { target: { value: username } })
            fireEvent.change(passwordField, { target: { value: password } })

            expect(usernameField.value).toBe(username);
            expect(passwordField.value).toBe(password);
        })
    })

    describe('on submit', () => {
        test('successful submit', async () => {
            const { username, password } = loginParams
            fireEvent.change(usernameField, { target: { value: username } })
            fireEvent.change(passwordField, { target: { value: password } })

            window.fetch.mockResolvedValueOnce({
                ok: true,
                json: async () => ({success: true}),
              })

              userEvent.click(submitButton)

              expect(window.fetch).toHaveBeenCalledWith(
                '/api/log_in',
                {
                  method: 'POST',
                  body: JSON.stringify(loginParams),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                },
              )
        })

        test('error response', async () => {
              const message1 = 'its broke'
              const message2 = 'really broke'
              const message3 = 'you should feel bad'
              window.fetch.mockRejectedValueOnce({errors: [message1, message2, message3]})
              
              await act(async() => {
                userEvent.click(submitButton)
              });

              expect(screen.getByText(message1)).toBeInTheDocument()
              expect(screen.getByText(message2)).toBeInTheDocument()
              expect(screen.getByText(message3)).toBeInTheDocument()
        })
    })
})
