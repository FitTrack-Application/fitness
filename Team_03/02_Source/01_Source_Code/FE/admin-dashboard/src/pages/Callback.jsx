import React from "react";
import styled from "styled-components";

const Wrapper = styled.div`
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  color: #333;
`;

const Callback = () => {
  return <Wrapper>Đang xác thực, vui lòng chờ...</Wrapper>;
};

export default Callback;
