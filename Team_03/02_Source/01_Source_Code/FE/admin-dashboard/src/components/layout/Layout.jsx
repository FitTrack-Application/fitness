import { Outlet } from "react-router-dom";
import Sidebar from "./Sidebar";
import Header from "./Header";
import styled from "styled-components";
import { useAuth } from "../../hook/useAuth";
const LayoutContainer = styled.div`
  display: flex;
  min-height: 100vh;
`;

const MainContent = styled.main`
  flex: 1;
  margin-left: var(--sidebar-width);
  padding: 20px;
  padding-top: calc(var(--header-height) + 20px);
`;

const Layout = () => {
  const { logout } = useAuth();
  return (
    <LayoutContainer>
      <Sidebar />
      <Header onLogout={logout} />
      <MainContent>
        <Outlet />
      </MainContent>
    </LayoutContainer>
  );
};

export default Layout;
