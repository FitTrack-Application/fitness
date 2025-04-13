export const uploadExerciseData = async (exerciseData) => {
  try {
    // For development/testing, you can use this mock response
    // Remove this in production and uncomment the actual API call below
    await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate network delay
    // Mock successful response
    console.log("Exercise data to upload:", exerciseData);
    return { success: true, count: exerciseData.length };

    // Uncomment for actual API integration
    // const response = await api.post('/exercises/import', { exercises: exerciseData });
    // return response.data;
  } catch (error) {
    console.error("Error uploading exercise data:", error);
    if (error.response) {
      throw new Error(
        error.response.data.message || "Failed to upload exercise data"
      );
    }
    throw error;
  }
};
