# Image Grid iOS Application

This project is an iOS application developed in `Swift` that efficiently loads and displays images in a scrollable grid. The application fetches images from a specified API endpoint, implements caching mechanisms for both memory and disk, and handles network errors and image loading failures gracefully. The goal is to ensure smooth scrolling performance even when dealing with a large number of images.

## Features

- 3-column square image grid.
- Asynchronously loads images using provided API endpoint.
- Lazy loading to ensure efficient memory usage.
- Cancel image loading for previously scrolled pages when quickly navigating to a new page.
- Both Memory and Disk caching for efficient image retrieval.
- Gracefully handled network errors and image loading failures, displaying informative error messages or placeholders.

## Requirements

- Xcode 14.x or later
- iOS 15.6 or later

## Installation

1. Clone or download the repository.
2. Open the project in Xcode.
3. Build and run the project. (Recommended to run on a physical device)


## Implementation Details

### Image Grid

- The image grid is displayed using a UICollectionView with a custom layout to achieve a 3-column grid layout.
- Images are fetched asynchronously and displayed within UIImageViews in each grid cell.
- Center-cropping is applied to the images to fit them within the square grid cells.

### Image Loading

- Asynchronous image loading is implemented using URLSession to fetch images from the provided API endpoint.
- Each image URL is constructed using the formula provided in the project overview.

### Caching

- Both memory and disk caching mechanisms are implemented to efficiently store and retrieve images.
- Images fetched from the API are cached in memory for quick retrieval.
- If an image is missing in the memory cache, it is fetched from disk cache if available.
- When an image is read from disk, the memory cache is updated to improve subsequent retrieval performance.

### Error Handling

- Network errors and image loading failures are handled gracefully.
- Placeholder images or informative error messages are displayed in place of failed image loads.
- Error messages are provided to inform the user about the issue encountered.


## Sample Video

https://github.com/MandhanVeena/ImageGridLoader/assets/103334361/3bd9900b-926d-4298-b5ad-b0c55cd6cf98


