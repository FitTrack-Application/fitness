import styled from "styled-components";
import { LogOut, User } from "react-feather";

const HeaderContainer = styled.header`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: var(--header-height);
  background-color: white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding: 0 20px;
  z-index: 99;
`;

const UserSection = styled.div`
  display: flex;
  align-items: center;
  margin-right: 20px;
`;

const UserInfo = styled.div`
  margin-left: 10px;
  font-weight: 500;
`;

const LogoutButton = styled.button`
  display: flex;
  align-items: center;
  padding: 8px 16px;
  background-color: var(--error-color);
  color: white;
  border-radius: 4px;
  transition: background-color 0.3s;

  &:hover {
    background-color: #d32f2f;
  }

  svg {
    margin-right: 8px;
  }
`;

const Header = ({ onLogout }) => {
  return (
    <HeaderContainer>
      <LogoutButton onClick={onLogout}>
        <LogOut size={16} />
        Logout
      </LogoutButton>
    </HeaderContainer>
  );
};

export default Header;
