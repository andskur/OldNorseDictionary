# Old Norse Dictionary 📚

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Swift](https://img.shields.io/badge/Swift-5.8-orange.svg)](https://swift.org/)

Welcome to the Old Norse Dictionary app repository! This application is available on macOS, iOS, iPadOS, and watchOS. It allows you to explore the fascinating world of Old Norse language with its extensive collection of nouns, verbs, adjectives, adverbs, and more. Whether you're a language enthusiast, a history buff, or just curious about Old Norse, this app is your gateway to the ancient language of the Vikings.

## Features ✨

- Comprehensive collection of Old Norse words with English and Russian translations.
- Filter words by type (noun, verb, adjective, etc.) and search by translation or Old Norse word.
- Detailed word information, including noun cases, verb conjugations, and more.
- Available on macOS, iOS, iPadOS, and watchOS.

## Installation 💻

The Old Norse Dictionary app is available for download on the macOS App Store. You can download it directly from the following link:

[Download Old Norse Dictionary from the App Store](https://apps.apple.com/me/app/oldnorse-dictionary/id6455376968?mt=12)

Please note that the iOS, iPadOS, and watchOS versions of the app are currently under review and will be available on the App Store soon.

For developers who want to run the project locally:

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Choose the desired target (macOS, iOS, iPadOS, or watchOS).
4. Press the Run button or use the `Cmd+R` shortcut to build and run the project.

## Usage 📖

The Old Norse Dictionary app is designed to be intuitive and easy to use. Here's a quick guide on how to use the app:

1. **Search**: Enter a word in the search bar at the top of the screen. You can search for Old Norse words and see their English and Russian translations, or you can search for English or Russian words to find their Old Norse equivalents.

2. **Filter**: Use the filter option to narrow down your search. You can filter words by type (noun, verb, adjective, etc.).

3. **Word Details**: For each word in the search results, you'll see detailed information displayed by default. This includes noun cases, verb conjugations, and more.

4. **Switch Language**: Use the dropdown menu to switch the search direction. You can choose from Old Norse to Russian, English to Old Norse, Old Norse to English, and Russian to Old Norse.

Remember, the app is available on macOS, iOS, iPadOS, and watchOS, so you can explore the Old Norse language on your preferred device.

Stay tuned for more features in future updates!


## Code Structure 🏗️

The codebase is organized into several directories:

```
OldNorseDictionary
│
├── .github/workflows
│   └── main.yml  # GitHub Actions workflow configuration file
│
├── Assets
│   └── WordsData.json  # JSON file containing the data for the words in the dictionary
│
├── Source  # Main source code of the application
│   ├── Models  # Contains the data models
│   │   ├── Case.swift  # Model for grammatical case
│   │   ├── Conjugation.swift  # Model for verb conjugation
│   │   ├── Number.swift  # Model for grammatical number
│   │   ├── Person.swift  # Model for grammatical person
│   │   └── Word.swift  # Main model representing a word in the dictionary
│   │
│   ├── Views  # Contains the SwiftUI views
│   │   ├── WordDetailView.swift  # View for displaying the details of a word
│   │   └── WordSearchView.swift  # View for the word search functionality
│   │
│   ├── Controllers  # Contains the controllers
│   │   └── WordSearchController.swift  # Controller for managing the word search functionality
│   │
│   ├── Services  # Contains the services
│   │   └── WordService.swift  # Service for fetching and filtering words
│   │
│   ├── Assets.xcassets  # Contains the assets used in the app, like images and colors
│   ├── OldNorseDictionaryApp.swift  # Main entry point of the application
│   └── OldNorseDictionary.entitlements  # File for specifying the app's entitlements
│
├── Tests  # Contains the unit tests for the application
│   ├── OldNorseDictionaryUnitTests.xctestplan  # Test plan for the unit tests
│   ├── UnitTests  # Contains the unit test cases
│   │   ├── WordSearchControllerTests.swift  # Test cases for the WordSearchController
│   │   └── WordServiceTests.swift  # Test cases for the WordService
│
├── WatchOSApp  # Contains the source code for the watchOS version of the app
│   ├── Assets.xcassets  # Contains the assets used in the watchOS app
│   ├── OldNorseDictionaryWatchOsApp.swift  # Main entry point of the watchOS application
│   └── WordListView.swift  # View for displaying the list of words in the watchOS app
│
├── LICENSE  # File containing the license for the project
├── PrivacyPolicy.md  # Markdown file containing the privacy policy for the app
└── README.md  # Markdown file containing information about the project

```

## Contributing 🤝

Contributions to the Old Norse Dictionary app are very welcome! Whether it's reporting bugs, suggesting new features, improving documentation, or contributing code, we appreciate all forms of help.

Here's how you can contribute:

1. **Reporting Bugs**: If you find a bug, please open an issue in the GitHub repository. Be sure to include a detailed description of the bug and steps to reproduce it.

2. **Suggesting Features**: Have an idea for a new feature? Open an issue and describe your idea. Be as detailed as possible.

3. **Improving Documentation**: Good documentation makes a great project even better. If you see a place where the documentation could be improved, please open an issue or submit a pull request.

4. **Contributing Code**: If you'd like to contribute code, please fork the repository, make your changes, and submit a pull request. Please make sure your code follows the existing style for consistency.

Thank you for helping to improve the Old Norse Dictionary app!


## License 📜

This project is licensed under the [MIT License](LICENSE).

## Credits 🙏

The Old Norse Dictionary app was created by [Andrey Skurlatov](https://andskur.github.io), a passionate developer with an interest in languages and history.

This project wouldn't be possible without the following resources:

- [Swift](https://swift.org/): The powerful and intuitive programming language for macOS, iOS, watchOS, and tvOS.
- [OpenAI](https://openai.com/): For providing the AI model that helped in code improvements and documentation.
- [School of Medieval Arts](https://vk.com/schoolofmedievalarts): For providing the Old Norse dictionary and fostering a love for the Old Norse language.


## Contact 📬

If you have any questions, comments, or suggestions about the Old Norse Dictionary app, we'd love to hear from you! Here's how you can reach us:

- **GitHub**: Open an issue in the [Old Norse Dictionary repository](https://github.com/andskur/OldNorseDictionary/issues) for any bugs, feature suggestions, or questions about the code.
- **Email**: You can reach us at [a.skurlatov@gmail.com](mailto:a.skurlatov@gmail.com) for any other inquiries.

We look forward to hearing from you!



