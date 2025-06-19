import styled from "styled-components";

export const PreviewTable = styled.div`
  margin-top: 20px;
  overflow-x: auto;
`;

export const Table = styled.table`
  width: 100%;
  border-collapse: collapse;

  th,
  td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
  }

  th {
    background-color: #f5f5f5;
    font-weight: 500;
  }

  tr:hover {
    background-color: #f9f9f9;
  }
`;
