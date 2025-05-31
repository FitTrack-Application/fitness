import { useState, useRef } from "react";
import Papa from "papaparse";
import styled, { keyframes } from "styled-components";
import { uploadExerciseData } from "../services/exerciseService";
import { Container } from "../components/common/Container";
import { Title } from "../components/common/Title";
import {
  ImportSection,
  FileInputWrapper,
  FileInput,
  FileInputLabel,
  SelectedFile,
} from "../components/common/FileInput";
import { PreviewTable, Table } from "../components/common/Table";
import {
  ButtonGroup,
  CancelButton,
  ImportButton,
} from "../components/common/Buttons";
import { SuccessMessage, ErrorMessage } from "../components/common/Message";

// Thêm animation xoay đơn giản
const spin = keyframes`
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
`;

// Thêm một spinner đơn giản
const Spinner = styled.div`
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: ${spin} 1s ease-in-out infinite;
  margin-right: 8px;
  vertical-align: middle;
`;

const ExerciseManagement = () => {
  const [file, setFile] = useState(null);
  const [parsedData, setParsedData] = useState([]);
  const [headers, setHeaders] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState({ type: "", text: "" });
  const fileInputRef = useRef(null);

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (selectedFile) {
      setFile(selectedFile);
      parseCSV(selectedFile);
    }
  };

  const parseCSV = (file) => {
    console.log("[DEBUG] Starting to parse CSV file:", file.name);

    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      complete: (results) => {
        console.log("[DEBUG] Parse complete:", results);

        if (results.data && results.data.length > 0) {
          const previewData = results.data.slice(0, 5);
          console.log("[DEBUG] Preview data:", previewData);

          setParsedData(previewData);

          if (results.meta && results.meta.fields) {
            console.log("[DEBUG] Detected headers:", results.meta.fields);
            setHeaders(results.meta.fields);
          }
        } else {
          console.warn("[DEBUG] No data found in CSV file.");
          setMessage({
            type: "error",
            text: "No data found in CSV file.",
          });
        }
      },
      error: (error) => {
        console.error("[DEBUG] Error parsing CSV:", error);
        setMessage({
          type: "error",
          text: "Failed to parse CSV file. Please check the file format.",
        });
      },
    });
  };

  const handleImport = async () => {
    if (!file) return;

    setIsLoading(true);
    setMessage({ type: "", text: "" });

    try {
      Papa.parse(file, {
        header: true,
        complete: async (results) => {
          if (results.data && results.data.length > 0) {
            try {
              const response = await uploadExerciseData(results.data);
              setMessage({
                type: "success",
                text: `${response.message}`,
              });
              // Reset form
              setFile(null);
              setParsedData([]);
              setHeaders([]);
              if (fileInputRef.current) {
                fileInputRef.current.value = "";
              }
            } catch (err) {
              setMessage({
                type: "error",
                text: err.message || "Failed to upload exercise data.",
              });
            } finally {
              // Move setIsLoading(false) here to ensure it happens after data processing
              setIsLoading(false);
            }
          } else {
            setIsLoading(false);
          }
        },
        error: () => {
          setMessage({
            type: "error",
            text: "Failed to parse CSV file. Please check the file format.",
          });
          setIsLoading(false); // Make sure to set loading to false on error
        },
      });
    } catch (err) {
      setMessage({
        type: "error",
        text: err.message || "An error occurred during import.",
      });
      setIsLoading(false); // Also handle errors from try/catch
    }
    // Removed the finally block that was incorrectly setting isLoading to true
  };

  const handleCancel = () => {
    setFile(null);
    setParsedData([]);
    setHeaders([]);
    setMessage({ type: "", text: "" });
    if (fileInputRef.current) {
      fileInputRef.current.value = "";
    }
  };

  return (
    <Container>
      <Title>Exercise Management</Title>

      <ImportSection>
        <h2>Import Exercise Data</h2>
        <p>
          Upload a CSV file containing exercise data to import into the system.
        </p>

        <FileInputWrapper>
          <FileInput
            type="file"
            id="csvFile"
            accept=".csv"
            onChange={handleFileChange}
            ref={fileInputRef}
            disabled={isLoading}
          />
          <FileInputLabel htmlFor="csvFile" disabled={isLoading}>
            Choose CSV File
          </FileInputLabel>
          {file && <SelectedFile>Selected file: {file.name}</SelectedFile>}
        </FileInputWrapper>

        {parsedData.length > 0 && (
          <>
            <h3>Preview:</h3>
            <PreviewTable>
              <Table>
                <thead>
                  <tr>
                    {headers.map((header, index) => (
                      <th key={index}>{header}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {parsedData.map((row, rowIndex) => (
                    <tr key={rowIndex}>
                      {headers.map((header, colIndex) => (
                        <td key={colIndex}>{row[header]}</td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </Table>
            </PreviewTable>

            <ButtonGroup>
              <ImportButton onClick={handleImport} disabled={isLoading}>
                {isLoading ? (
                  <>
                    <Spinner /> Importing...
                  </>
                ) : (
                  "Import Data"
                )}
              </ImportButton>
              <CancelButton onClick={handleCancel} disabled={isLoading}>
                Cancel
              </CancelButton>
            </ButtonGroup>
          </>
        )}

        {message.text &&
          (message.type === "success" ? (
            <SuccessMessage>{message.text}</SuccessMessage>
          ) : (
            <ErrorMessage>{message.text}</ErrorMessage>
          ))}
      </ImportSection>
    </Container>
  );
};

export default ExerciseManagement;
