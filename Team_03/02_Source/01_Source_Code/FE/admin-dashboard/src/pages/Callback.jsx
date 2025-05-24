import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../hook/useAuth";
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
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  const { isAuthenticated, loading } = useAuth();

  useEffect(() => {
    if (!loading) {
      if (isAuthenticated) {
        navigate("/admin");
      } else {
        setError("Xác thực không thành công");
      }
    }
  }, [isAuthenticated, loading, navigate]);

  return (
    <Wrapper>
      {loading && !error && <h1>Đang xử lý...</h1>}
      {error && <h1>Lỗi xác thực</h1>}
    </Wrapper>
  );
};

export default Callback;
