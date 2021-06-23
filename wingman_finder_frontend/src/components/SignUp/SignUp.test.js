import { fireEvent, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/extend-expect'
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';


import SignUp from './SignUp'

let emailField
let usernameField
let passwordField
let confirmPasswordField
let submitButton
const userParams = {
    email: 'example@email.com',
    username: 'example!',
    password: 'some password',
    passwordConfirm: 'some password'
}

describe('SignUp', () => {
    beforeAll(() => jest.spyOn(window, 'fetch'))
    beforeEach(() => {
        render(<SignUp />)

        emailField = screen.getByLabelText('Email Address *')
        usernameField = screen.getByLabelText('Username *')
        passwordField = screen.getByLabelText('Password *')
        confirmPasswordField = screen.getByLabelText('Confirm Password *')
        submitButton = screen.getByTestId('sign-up-button')
    })

    afterEach(() => {
        jest.resetAllMocks();
    });

    describe('fields fill in', () => {
        test('the sign up button is disabled unless all required fields are filled', () => { 
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