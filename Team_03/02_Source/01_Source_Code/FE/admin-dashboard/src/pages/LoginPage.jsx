import { useAuth } from "../hook/useAuth";
import styled from "styled-components";

const LoginContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f5f5;
`;

const LoginBox = styled.div`
  background-color: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 500px;
  text-align: center;
`;

const LoginButton = styled.button`
  width: 100%;
  padding: 12px;
  background-color: #1976d2;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  cursor: pointer;

  &:hover {
    background-color: #115293;
  }
`;

const LoginTitle = styled.h1`
  margin-bottom: 24px;
  color: var(--primary-color);
`;

const LoginPage = () => {
  const { login, loading } = useAuth();

  return (
    <LoginContainer>
      <LoginBox>
        <LoginTitle>My Fitness Admin Website</LoginTitle>
        <LoginButton onClick={login} disabled={loading}>
          {loading ? "Loading..." : "Login"}
        </LoginButton>
      </LoginBox>
    </LoginContainer>
  );
};

export default LoginPage;
