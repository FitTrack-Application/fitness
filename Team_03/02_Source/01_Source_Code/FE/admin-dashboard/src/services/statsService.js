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
  await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate network delay
  return {
    // General statistics
    totalUsers: 1250,
    activeUsers: 950,
    totalMeals: 320,
    totalFoods: 780,
    totalExercises: 180,

    // New users by month (Line/Bar chart)
    newUsersByMonth: {
      labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
      data: [120, 120, 155, 220, 210, 210],
    },

    // Daily logins (Line chart)
    dailyLogins: {
      labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
      data: [85, 92, 78, 95, 88, 120, 110],
    },

    // Users achieving goals per week (Bar chart)
    weeklyGoalAchievements: {
      labels: ["Week 1", "Week 2", "Week 3", "Week 4"],
      data: [45, 52, 58, 65],
      totalUsers: [100, 100, 100, 100], // For percentage calculation
    },

    // Users whose last login is close to registration (Bar chart)
    earlyChurnByMonth: {
      labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
      data: [30, 25, 20, 15, 18, 22],
      totalNewUsers: [120, 150, 180, 220, 270, 310], // For percentage calculation
    },

    // Percentage of users adding custom food (Pie chart)
    customFoodUsage: {
      labels: ["Used custom food", "Used available food"],
      data: [65, 35],
    },

    // Percentage of users adding custom exercise (Pie chart)
    customExerciseUsage: {
      labels: ["Used custom exercise", "Used available exercise"],
      data: [45, 55],
    },

    // Top 5 custom foods (Bar chart)
    topCustomFoods: {
      labels: [
        "Broken rice",
        "Beef noodle soup",
        "Banh mi",
        "Pho",
        "Fried rice",
      ],
      data: [320, 290, 270, 250, 230],
    },

    // Top 5 custom exercises (Bar chart)
    topCustomExercises: {
      labels: ["Running", "Cycling", "Yoga", "Swimming", "Weight training"],
      data: [180, 150, 140, 120, 90],
    },
  };
};
