# Movie Explorer App
## Overview

**Movie Explorer** is a Flutter-based app that offers a comprehensive browsing experience for movies and TV shows. Leveraging **The Movie Database (TMDB) API**, the app displays a wide selection of trending and top-rated content, enabling users to explore popular and upcoming releases, view detailed information, and watch trailers.

## Features
* **Movies**

    * Trending Movies of the Day and Week
    * Upcoming Movies
    * Popular Movies
    * Top-Rated Movies
* **TV Shows**

    * Popular TV Shows
    * Top-Rated TV Shows
    * Ongoing TV Shows
* **Detailed Movie/TV Show Pages**

    * Ratings and Reviews
    * Full Descriptions and Synopses
    * Official Trailers and Media
*   **Search Functionality**

    * Autocomplete Search: Quickly find movies and shows by title with real-time suggestions.
## Technology Stack
* **Frontend**: Flutter (Dart)
* **Data Source**: TMDB API (The Movie Database)
* **Networking**: HTTP requests with API key for TMDB data
## Getting Started
* Clone the repository and navigate to the project directory.
* Run flutter pub get to install dependencies.
* Set up TMDB API keys by configuring your .env file with the required TMDB API key.
* Launch the app on your desired platform using flutter run.




## API Reference

#### Get all popular movie

```http
  GET /api/movie/popular?api_key={api_key}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |

#### Get specific movie by id

```http
  GET /api/movie/{id}?api_key={api_key}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of item to fetch |
