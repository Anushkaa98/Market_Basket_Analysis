# Market Basket Analysis

## Overview
This repository hosts an R-based project designed to conduct Market Basket Analysis using detailed transactional data. The project aims to reveal associations and patterns between different products purchased together, helping businesses understand customer purchase behavior for better marketing and sales strategies.

## Key Features
- **Data Preparation**: Cleansing and preprocessing data to ensure quality and consistency.
- **Association Rules Mining**: Leveraging the `arules` package to discover interesting relationships between items.
- **Visualization**: Utilizing `ggplot2` and `arulesViz` for graphical representation of item frequencies and association rules.

## Technologies Used
- R
- R Libraries: `arules`, `arulesViz`, `tidyverse`, `readxl`, `knitr`, `ggplot2`, `lubridate`, `dplyr`

## How It Works
1. **Data Loading**: The script starts by importing data from an Excel file.
2. **Data Cleaning**: Includes removing incomplete records and converting necessary fields.
3. **Rule Generation**: Implements the Apriori algorithm to generate and filter association rules.
4. **Visualization of Association Rules**:
   - The association rules are visualized using the `arulesViz` package, which provides a method to plot these rules in a graph format. Below are examples of the visualizations generated:
   
   ![Association Rule Visualization 1](images/Image1.png)
   ![Association Rule Visualization 2](images/Image2.png)
   
   Each node in the graph represents an item, and each directed edge indicates that purchasing the item at the tail (start) of the arrow often leads to purchasing the item at the head (end). This visualization aids in quickly understanding key purchase behaviors and decision-making processes of customers.

## Setup and Installation
Ensure R is installed on your system along with the following packages. Run these commands in R to install the necessary packages:
```R
