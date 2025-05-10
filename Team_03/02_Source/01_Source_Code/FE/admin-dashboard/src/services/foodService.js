export const uploadFoodData = async (foodData) => {
  try {
    // For development/testing, you can use this mock response
    // Remove this in production and uncomment the actual API call below
    await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate network delay
    // Mock successful response
    console.log("Food data to upload:", foodData);
    return { success: true, count: foodData.length };

    // Uncomment for actual API integration
    // const response = await api.post('/foods/import', { foods: foodData });
    // return response.data;
  } catch (error) {
    console.error("Error uploading food data:", error);
    if (error.response) {
      throw new Error(
        error.response.data.message || "Failed to upload food data"
      );
    }
    throw error;
  }
};
