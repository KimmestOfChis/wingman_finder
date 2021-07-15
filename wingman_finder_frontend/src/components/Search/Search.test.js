import { fireEvent, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';


import Search from './Search'

describe('Search', () => {
    beforeAll(() => jest.spyOn(window, 'fetch'))
    beforeEach(() => {
        render(<Search />)``
    })

    afterEach(() => {
        jest.resetAllMocks();
    });

    describe('fields fill in', () => {
        test('fields are filled in', () => { 
            const { email, username, password } = userParams
            fireEvent.change(emailField, { target: { value: email } })
            fireEvent.change(usernameField, { target: { value: username } })
            fireEvent.change(passwordField, { target: { value: password } })
            fireEvent.change(confirmPasswordField, { target: { value: password } })

            expect(emailField.value).toBe(email);
            expect(usernameField.value).toBe(username);
            expect(passwordField.value).toBe(password);
            expect(confirmPasswordField.value).toBe(password);
        })
    })

    describe('on submit', () => {
        test('successful submit', async () => {
            const { email, username, password } = userParams
            fireEvent.change(emailField, { target: { value: email } })
            fireEvent.change(usernameField, { target: { value: username } })
            fireEvent.change(passwordField, { target: { value: password } })
            fireEvent.change(confirmPasswordField, { target: { value: password } })

            window.fetch.mockResolvedValueOnce({
                ok: true,
                json: async () => ({success: true}),
              })

              userEvent.click(submitButton)

              expect(window.fetch).toHaveBeenCalledWith(
                '/api/sign_up',
                {
                  method: 'POST',
                  body: JSON.stringify(userParams),
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