import { useState, useEffect } from "react";
import styled from "styled-components";
import { Bar, Pie, Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  PointElement,
  LineElement,
} from "chart.js";
import { fetchDashboardStats } from "../services/statsService";
import { ErrorMessage } from "../components/common/Message";

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  PointElement,
  LineElement
);

const DashboardContainer = styled.div`
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;

  @media (max-width: 1024px) {
    grid-template-columns: 1fr;
  }
`;

const Card = styled.div`
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  padding: 20px;
`;

const CardHeader = styled.div`
  margin-bottom: 20px;
  border-bottom: 1px solid var(--border-color);
  padding-bottom: 10px;
`;

const CardTitle = styled.h2`
  font-size: 1.2rem;
  color: var(--primary-color);
`;

const StatsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 15px;
  margin-bottom: 20px;
`;

const StatCard = styled.div`
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  padding: 15px;
  text-align: center;
`;

const StatValue = styled.div`
  font-size: 2rem;
  font-weight: bold;
  color: var(--primary-color);
`;

const StatLabel = styled.div`
  font-size: 0.9rem;
  color: #666;
  margin-top: 5px;
`;

const LoadingMessage = styled.div`
  text-align: center;
  padding: 40px;
  font-size: 1.2rem;
  color: #666;
  grid-column: 1 / -1;
`;

const Dashboard = () => {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const loadStats = async () => {
      try {
        const data = await fetchDashboardStats();
        setStats(data);
      } catch (err) {
        setError("Failed to load dashboard statistics");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    loadStats();
  }, []);

  if (loading) {
    return <LoadingMessage>Loading dashboard data...</LoadingMessage>;
  }

  if (error) {
    return <ErrorMessage>{error}</ErrorMessage>;
  }

  const newUsersByMonthData = {
    labels: stats.newUsersByMonth.labels,
    datasets: [
      {
        label: "New Users",
        data: stats.newUsersByMonth.data,
        backgroundColor: "rgba(63, 81, 181, 0.5)",
        borderColor: "rgba(63, 81, 181, 1)",
        borderWidth: 1,
      },
    ],
  };

  const earlyChurnData = {
    labels: stats.earlyChurnByMonth.labels,
    datasets: [
      {
        label: "Users Not Returning",
        data: stats.earlyChurnByMonth.data,
        backgroundColor: "rgba(255, 99, 132, 0.5)",
        borderColor: "rgba(255, 99, 132, 1)",
        borderWidth: 1,
      },
    ],
  };

  const customFoodData = {
    labels: stats.customFoodUsage.labels,
    datasets: [
      {
        data: stats.customFoodUsage.data,
        backgroundColor: ["#FF6384", "#36A2EB"],
        borderWidth: 1,
      },
    ],
  };

  const customExerciseData = {
    labels: stats.customExerciseUsage.labels,
    datasets: [
      {
        data: stats.customExerciseUsage.data,
        backgroundColor: ["#FFCE56", "#4BC0C0"],
        borderWidth: 1,
      },
    ],
  };

  const topCustomFoodsData = {
    labels: stats.topCustomFoods.labels,
    datasets: [
      {
        label: "Usage Count",
        data: stats.topCustomFoods.data,
        backgroundColor: "rgba(153, 102, 255, 0.5)",
        borderColor: "rgba(153, 102, 255, 1)",
        borderWidth: 1,
      },
    ],
  };

  const topCustomExercisesData = {
    labels: stats.topCustomExercises.labels,
    datasets: [
      {
        label: "Usage Count",
        data: stats.topCustomExercises.data,
        backgroundColor: "rgba(54, 162, 235, 0.5)",
        borderColor: "rgba(54, 162, 235, 1)",
        borderWidth: 1,
      },
    ],
  };

  return (
    <>
      <StatsGrid>
        <StatCard>
          <StatValue>{stats.totalUsers}</StatValue>
          <StatLabel>Total Users</StatLabel>
        </StatCard>
        <StatCard>
          <StatValue>{stats.activeUsers}</StatValue>
          <StatLabel>Active Users</StatLabel>
        </StatCard>
        <StatCard>
          <StatValue>{stats.totalMeals}</StatValue>
          <StatLabel>Total Meals</StatLabel>
        </StatCard>
        <StatCard>
          <StatValue>{stats.totalFoods}</StatValue>
          <StatLabel>Total Foods</StatLabel>
        </StatCard>
        <StatCard>
          <StatValue>{stats.totalExercises}</StatValue>
          <StatLabel>Total Exercises</StatLabel>
        </StatCard>
      </StatsGrid>

      <DashboardContainer>
        <Card>
          <CardHeader>
            <CardTitle>New Users per Week</CardTitle>
          </CardHeader>
          <Line data={newUsersByMonthData} />
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Early Churn Rate per Week</CardTitle>
          </CardHeader>
          <Line data={earlyChurnData} />
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Custom Food Usage Rate</CardTitle>
          </CardHeader>
          <Pie data={customFoodData} />
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Custom Exercise Usage Rate</CardTitle>
          </CardHeader>
          <Pie data={customExerciseData} />
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Top Most Used Foods</CardTitle>
          </CardHeader>
          <Bar data={topCustomFoodsData} />
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Top Most Used Exercises</CardTitle>
          </CardHeader>
          <Bar data={topCustomExercisesData} />
        </Card>
      </DashboardContainer>
    </>
  );
};

export default Dashboard;
