import axiosInstance from "./axiosInstance";

export const fetchDashboardStats = async () => {
  try {
    const response = await axiosInstance.get("/admin/statistics");
    console.log("response");
    console.log(response);
    const data = response.data.data;

    console.log("data");
    console.log(data);

    // Transform the API response to match the dashboard's expected format
    return {
      // General statistics
      totalUsers: data.totalUsers,
      activeUsers: data.activeUsers,
      totalMeals: data.totalMeals,
      totalFoods: data.totalFoods,
      totalExercises: data.totalExercises,

      // New users by week
      newUsersByMonth: {
        labels: data.newUsersByWeek.map((item) => item.date),
        data: data.newUsersByWeek.map((item) => item.count),
      },

      // Early churn by week
      earlyChurnByMonth: {
        labels: data.earlyChurnByWeek.map((item) => item.date),
        data: data.earlyChurnByWeek.map((item) => item.count),
      },

      // Custom food usage
      customFoodUsage: {
        labels: data.customFoodUsage.map((item) => item.label),
        data: data.customFoodUsage.map((item) => item.count),
      },

      // Custom exercise usage
      customExerciseUsage: {
        labels: data.customExerciseUsage.map((item) => item.label),
        data: data.customExerciseUsage.map((item) => item.count),
      },

      // Top foods
      topCustomFoods: {
        labels: data.topFoods.map((item) => item.name),
        data: data.topFoods.map((item) => item.count),
      },

      // Top exercises
      topCustomExercises: {
        labels: data.topExercises.map((item) => item.name),
        data: data.topExercises.map((item) => item.count),
      },
    };
  } catch (error) {
    console.error("Error fetching dashboard stats:", error);
    throw new Error("Failed to load dashboard statistics");
  }
};
