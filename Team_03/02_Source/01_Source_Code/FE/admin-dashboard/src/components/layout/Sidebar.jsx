import { NavLink } from "react-router-dom";
import styled from "styled-components";
import { BarChart2, Coffee, Activity } from "react-feather";

const SidebarContainer = styled.aside`
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: var(--sidebar-width);
  background-color: #fff;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  z-index: 100;
  padding-top: var(--header-height);
`;

const Logo = styled.div`
  padding: 20px;
  font-size: 1.5rem;
  font-weight: bold;
  color: var(--primary-color);
  border-bottom: 1px solid var(--border-color);
`;

const NavMenu = styled.nav`
  padding: 20px 0;
`;

const NavItem = styled(NavLink)`
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: var(--text-color);
  transition: all 0.3s ease;

  &:hover {
    background-color: rgba(63, 81, 181, 0.1);
  }

  &.active {
    background-color: var(--primary-color);
    color: white;
  }

  svg {
    margin-right: 10px;
  }
`;

const Sidebar = () => {
  return (
    <SidebarContainer>
      <Logo>Admin Dashboard</Logo>
      <NavMenu>
        <NavItem
          to="/admin/dashboard"
          className={({ isActive }) => (isActive ? "active" : "")}
        >
          <BarChart2 size={20} />
          Dashboard
        </NavItem>
        <NavItem
          to="/admin/food"
          className={({ isActive }) => (isActive ? "active" : "")}
        >
          <Coffee size={20} />
          Food Management
        </NavItem>
        <NavItem
          to="/admin/exercise"
          className={({ isActive }) => (isActive ? "active" : "")}
        >
          <Activity size={20} />
          Exercise Management
        </NavItem>
      </NavMenu>
    </SidebarContainer>
  );
};

export default Sidebar;
