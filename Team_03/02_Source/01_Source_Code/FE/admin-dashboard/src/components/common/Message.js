import styled from "styled-components";

const Message = styled.div`
  margin-top: 20px;
  padding: 10px;
  border-radius: 4px;
  text-align: center;
`;

export const SuccessMessage = styled(Message)`
  background-color: rgba(76, 175, 80, 0.1);
  color: var(--success-color);
  border: 1px solid var(--success-color);
`;

export const ErrorMessage = styled(Message)`
  background-color: rgba(244, 67, 54, 0.1);
  color: var(--error-color);
  border: 1px solid var(--error-color);
`;
