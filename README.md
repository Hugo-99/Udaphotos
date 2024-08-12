# Udaphotos
Udaphotos is a mobile application designed to provide users with seamless access to high-quality images from Unsplash. Powered by the Unsplash API, the app allows users to search for and view photo collections effortlessly. Additionally, users can customize their profiles within the app. Udaphotos is an unofficial project built using Swift, utilizing the Async/Await method to enhance the learning experience for developers while exploring modern Swift features.

## Prerequisites
Udaphotos is integrated with the [Unsplash API](https://unsplash.com/developers). To begin using the app, you’ll need to obtain a pair of OAuth keys.

1. Go to [Unsplash](https://unsplash.com/), sign up, and log in. (If you already have an account, you can skip this step.)
2. Navigate to the [Unsplash Application Registration Platform](https://unsplash.com/oauth/applications/new), agree to the terms, and create a new application. You can choose any name and description for your application.
3. After creating the application, you’ll be automatically redirected to the [application details page](https://unsplash.com/oauth/applications).
4. In the `Redirect URI & Permissions` section, under Redirect URI, enter `udaphotos://unsplash`. Ensure all authentication options are selected, as shown in the image below. <img width="860" alt="Screenshot 2024-08-12 at 12 11 43" src="https://github.com/user-attachments/assets/01f7799e-4787-4b6d-af25-2cdec853f390">
6. Once the setup is complete, copy the "Access Key" and "Secret Key" from this page. You’ll need these shortly.

## Installation
1. Run the command to clone this repo
   ```
   git clone https://github.com/Hugo-99/Udaphotos.git
   ```
2. Navigate to `Udaphotos/Auth/Data/AuthClient` and replace `"YOUR_SECRET_KEY"` and `"YOUR_ACCESS_KEY"` with your real keys that you just copied.
  ```
      enum Key: String {
        case secretKey = "YOUR_SECRET_KEY"
        case accessKey = "YOUR_ACCESS_KEY"
    }
  ```
3. Run the project!
