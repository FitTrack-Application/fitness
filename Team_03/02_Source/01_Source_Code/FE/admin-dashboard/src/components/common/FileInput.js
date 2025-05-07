import styled from "styled-components";

export const ImportSection = styled.div`
  margin-bottom: 30px;
`;

export const FileInputWrapper = styled.div`
  margin-bottom: 20px;
  margin-top: 10px;
`;

export const FileInput = styled.input`
  display: none;
`;

export const FileInputLabel = styled.label`
  display: inline-block;
  padding: 10px 15px;
  background-color: var(--primary-color);
  color: white;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;

  ${(props) =>
    !props.disabled &&
    `
      &:hover {
        background-color: #303f9f;
      }
    `}

  ${(props) =>
    props.disabled &&
    `
      background-color: #bdbdbd;
      cursor: not-allowed;
    `}
`;

export const SelectedFile = styled.div`
  margin-top: 10px;
  font-size: 0.9rem;
`;
