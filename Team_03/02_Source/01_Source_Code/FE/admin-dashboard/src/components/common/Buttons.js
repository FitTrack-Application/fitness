import styled from "styled-components";

const Button = styled.button`
  padding: 10px 15px;
  border-radius: 4px;
  font-weight: 500;
  transition: background-color 0.3s;

  &:disabled {
    background-color: #bdbdbd;
    cursor: not-allowed;
  }
`;

export const ButtonGroup = styled.div`
  display: flex;
  gap: 10px;
  margin-top: 20px;
`;

export const ImportButton = styled(Button)`
  background-color: var(--success-color);
  color: white;

  &:hover:not(:disabled) {
    background-color: #388e3c;
  }
`;

export const CancelButton = styled(Button)`
  background-color: var(--error-color);
  color: white;

  &:hover:not(:disabled) {
    background-color: #d32f2f;
  }
`;
