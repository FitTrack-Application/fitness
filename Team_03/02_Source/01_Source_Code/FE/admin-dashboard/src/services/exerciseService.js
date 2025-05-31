import axiosInstance from "./axiosInstance";

export const uploadExerciseData = async (exerciseData) => {
  try {
    const response = await axiosInstance.post(
      "/admin/import/exercise",
      exerciseData
    );
    return {
      success: true,
      message: response.data.generalMessage,
      count: exerciseData.length,
    };
  } catch (error) {
    console.error("Error uploading exercise data:", error);
    if (error.response) {
      throw new Error(
        error.response.data.generalMessage || "Failed to upload exercise data"
      );
    }
    throw error;
  }
};
