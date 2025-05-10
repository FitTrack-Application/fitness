import { useState } from "react";
import styled from "styled-components";
import { login } from "../services/authService";
import { ErrorMessage } from "../components/common/Message";

const LoginContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f5f5;
`;

const LoginForm = styled.form`
  background-color: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
`;

const LoginTitle = styled.h1`
  text-align: center;
  margin-bottom: 24px;
  color: var(--primary-color);
`;

const FormGroup = styled.div`
  margin-bottom: 20px;
`;

const LoginLabel = styled.label`
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
`;

const LoginInput = styled.input`
  width: 100%;
  padding: 10px;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  font-size: 16px;

  &:focus {
    outline: none;
    border-color: var(--primary-color);
  }
`;

const LoginSubmitButton = styled.button`
  width: 100%;
  padding: 12px;
  background-color: var(--primary-color);
  color: white;
  border-radius: 4px;
  font-size: 16px;
  font-weight: 500;
  transition: background-color 0.3s;

  &:hover {
    background-color: #303f9f;
  }

  &:disabled {
    background-color: #bdbdbd;
    cursor: not-allowed;
  }
`;

const LoginPage = ({ onLogin }) => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!username || !password) {
      setError("Please enter both username and password");
      return;
    }

    setIsLoading(true);
    setError("");

    try {
      const response = await login(username, password);
      onLogin(response.token);
    } catch (err) {
      setError(err.message || "Login failed. Please check your credentials.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <LoginContainer>
      <LoginForm onSubmit={handleSubmit}>
        <LoginTitle>Admin Login</LoginTitle>

        <FormGroup>
          <LoginLabel htmlFor="username">Username</LoginLabel>
          <LoginInput
            id="username"
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            disabled={isLoading}
          />
        </FormGroup>

        <FormGroup>
          <LoginLabel htmlFor="password">Password</LoginLabel>
          <LoginInput
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            disabled={isLoading}
          />
        </FormGroup>

        <LoginSubmitButton type="submit" disabled={isLoading}>
          {isLoading ? "Logging in..." : "Login"}
        </LoginSubmitButton>

        {error && <ErrorMessage>{error}</ErrorMessage>}
      </LoginForm>
    </LoginContainer>
  );
};

export default LoginPage;
