import axiosInstance from "./axiosInstance";

// export const fetchDashboardStats = async () => {
//   try {
//     // For development/testing, you can use this mock response
//     // Remove this in production and uncomment the actual API call below

//     // Mock data for development
//     return {
//       totalUsers: 1250,
//       totalFoods: 320,
//       totalExercises: 180,
//       userGrowth: {
//         labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
//         data: [120, 150, 180, 220, 270, 310],
//       },
//       foodCategories: {
//         labels: ["Fruits", "Vegetables", "Proteins", "Grains", "Dairy"],
//         data: [65, 85, 70, 50, 50],
//       },
//       exerciseTypes: {
//         labels: ["Cardio", "Strength", "Flexibility", "Balance", "Sports"],
//         data: [40, 60, 30, 20, 30],
//       },
//       weeklyActivity: {
//         labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
//         data: [65, 59, 80, 81, 56, 55, 40],
//       },
//     };

//     // Uncomment for actual API integration
//     // const response = await api.get('/stats/dashboard');
//     // return response.data;
//   } catch (error) {
//     console.error("Error fetching dashboard stats:", error);
//     throw new Error("Failed to load dashboard statistics");
//   }
// };

export const fetchDashboardStats = async () => {
  try {
    const response = await axiosInstance.get("/admin/statistics");
    const data = response.data.data;

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
