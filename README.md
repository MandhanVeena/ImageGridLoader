# Image Grid iOS Application

This project is an iOS application developed in `Swift` that efficiently loads and displays images in a scrollable grid. The application fetches images from a specified API endpoint, implements caching mechanisms for both memory and disk. The goal is to ensure smooth scrolling performance even when dealing with a large number of images.

<details>
<summary>Features</summary>

- 3-column square image grid.
- Asynchronous loading of images using provided API endpoint.
- Lazy loading to ensure efficient memory usage.
- Cancel image loading for previously scrolled pages when quickly navigating to a new page.
- Both Memory and Disk caching for efficient image retrieval.
- Gracefully handled network errors and image loading failures, displaying placeholders.
</details>

<br>

## Steps to run

1. Clone or Download the repository.
2. Double click the `.xcodeproj` file to open the project in Xcode.
3. Select target iOS device. (Recommended to run on a physical device)
4. Build and run the project - [Cmd+R].

<br>

## Developer Comments

- The project includes the `API URL` internally to minimize the need for external configurations.
- Added a `limit` variable within the `Constants.swift` file to adjust the number of items to fetch from the API.
- Added a header above the grids to cover some space, so that lazy loading can be represented clearly.

<br>

## Sample Video

The video shows:
- Smooth scrolling of images along with lazy loading
- Logs representing the loading of images from **URL**, **Disk cache** or **Memory cache**.
- Memory fluctuations during the image loading process and while clearing up memory cache.

<br>

https://github.com/MandhanVeena/ImageGridLoader/assets/103334361/3bd9900b-926d-4298-b5ad-b0c55cd6cf98

<br>

<details>
<summary>Implementation Details</summary>


#### Image Grid

- The image grid is displayed using a UICollectionView with a custom layout to achieve a 3-column grid layout.
- Images are fetched asynchronously and displayed within UIImageViews in each grid cell.
- Center-cropping is applied to the images to fit them within the square grid cells.

#### Image Loading

- Asynchronous image loading is implemented using URLSession to fetch images from the provided API endpoint.
- Each image URL is constructed using the formula provided in the project overview.

#### Caching

- Both Memory and Disk caching mechanisms are implemented to efficiently store and retrieve images.
- Images fetched from the API are cached in memory as well as disk for quick retrieval.
- If an image is missing in the memory cache, it is fetched from disk cache if available, otherwise from the URL itself.
- When an image is read from disk, the memory cache is updated to improve subsequent retrieval performance.

#### Error Handling

- Network errors and image loading failures are handled gracefully.
- Placeholder images are displayed in place of failed image loads.

</details>



