import axiosInstance from "./axiosInstance";

export const uploadFoodData = async (foodData) => {
  try {
    const response = await axiosInstance.post("/admin/import/food", foodData);
    return {
      success: true,
      message: response.data.generalMessage,
      count: foodData.length,
    };
  } catch (error) {
    console.error("Error uploading food data:", error);
    if (error.response) {
      throw new Error(
        error.response.data.generalMessage || "Failed to upload food data"
      );
    }
    throw error;
  }
};
