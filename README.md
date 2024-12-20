# Pokédata
#### Video Demo: https://www.youtube.com/watch?v=lAj2kuT4baM
#### Description: 

In a nutshell, this program is an IOS application designed to query, quote and keep track of a collection of Pokémon cards. 

A secure login and registration verification process has been developed to allow users to build a collection—given that they are logged in. All changes are tracked dynamically, and the collection is updated detailing the amount of total cards they possess (found on the profile tab), the total net worth of all their cards as well as specific sets and series the cards belong in. Users are given the option to change and update their personal information at anytime they please, as long as they provide the correct password. Moreover, users are also able to change their password if they would like, as long as the associated account email is provided (username cannot be used for verification as this is displayed on the Personal View tab) along with the correct password, the new password and a confirmation of the new password. Mock legal information regarding the application is also available to users for the purpose of developing adequate customer-service relationships. Credentials for developing the app, including specific datasets and APIs are also provided (along with CS50!). Users are also able to look up specific information regarding the game stats of each Pokémon (supports 8 generations).

## Languages Utilized: Swift, Python, SQLite3, HTML and CSS

### Backend Overview:

Flask was utilized for the backend. Notable files include:
-	app.py
-	functions.py
-	data.py
-	legal (templates folder)
-	pokedex.db
-	accounts.db
-	table_prototypes.txt. 
-	.gitignore

### Frontend Overview:

Swift was utilized for the frontend. The main file is ContentView.swift in which there are 4 SwiftUI files for each tab of the application: 
1)	SearchCardTabView.swift
2)	SearchTabView.swift
3)	CollectionTabView
4)	ProfileTabView

Other notable files include:
-	PokemonCardInfo.swift
-	PokemonInfo.swift
-	LoginView.swift
-	RegisterView.swift
-	PersonalView.swift
-	CreditsView.swift
-	PasswordChangeView.swift

## Backend Specifications

### app.py

#### Imports and Initial Configuration
* Libraries:
    - os: For file system operations like checking or modifying paths.
    - flask_cors.CORS: Allows handling Cross-Origin Resource Sharing (CORS), enabling client-side applications to make requests to this server from different origins.
    - cs50.SQL: Used to interact with a SQLite database (accounts.db), managing user data and card collections.
    - flask: The core framework for building the application, defining routes and handling HTTP requests.
    - werkzeug.security: Provides functions to securely hash and check passwords.
    - datetime and pytz: Handle time and date, including time zone conversion to UTC or Eastern Time.
    - re: Used for regular expression operations, such as validating email formats.
* Flask Configuration: 
    - The app uses filesystem-based sessions (SESSION_TYPE = "filesystem") to store session data.
    - CORS is enabled to allow cross-origin requests.
    - The app stores user data in an SQLite database (accounts.db).
* File Directories:
    - image_folder: Points to archive_new/, where Pokémon card images are stored.
    - template_folder: Refers to legal/, where legal pages like terms of service and privacy policy are kept.
* Global Variables:
    - prev_collection and prev_sets: These store previous collection and set data to avoid unnecessary recalculations or redundant responses.
    
#### Request Handlers (Routes)
1.	Index (/) - Pokémon Info Search:
    - GET: Returns an empty JSON object.
    - POST: Accepts a Pokémon name or Pokedex number and looks up data for that Pokémon. If no data is found, it returns an error message.
2.	Serve Image (/images/<filename>):
    - Serves images from the archive_new/ directory. The send_from_directory function ensures safe serving of files.
3.	Serve Legal Pages (/legal/<page>):
    - Serves legal pages like terms of service or privacy policy from the legal/ directory.
4.	Cards (/cards) - Pokémon Card Search:
    - GET: Returns an empty JSON object.
    - POST: Accepts a Pokémon card name or ID, searches for the card details, and returns them. If no results are found, it returns an error message.
5.	Register (/register):
    - GET: Returns a list of all registered usernames and emails.
    - POST: Handles user registration, validating name, email, date of birth, and password. It ensures the username and email are unique, and that the password matches its confirmation. On successful registration, the user is added to the database.
6.	Login (/login):
    - GET: Returns the list of usernames and emails.
    - POST: Handles user login by verifying the provided username/email and password hash. If successful, it returns the user’s ID.
7.	Profile (/profile):
    - GET: Fetches a user's profile details (e.g., username, email, first and last name, date of birth, collection count) using the provided user ID. The date of birth is formatted using date_shift.
8.	Change Password (/change):
    - POST: Allows users to change their password by verifying their current password and ensuring the new password matches the confirmation. If successful, it updates the password in the database.
9.	Personal Information Update (/personal):
    - POST: Allows users to update their personal details (username, email, first and last name, date of birth, and password). The app checks for existing records before updating the information.
10.	Collection Management (/collection):
    - GET: Fetches a user’s card collection based on their user ID.
    - POST: Allows users to add or remove cards from their collection. It checks the add_request parameter to determine whether a card is being added or removed and updates the collection accordingly.

#### Error Handling
The application has error handling in place to catch issues such as:
* Missing form fields.
* Password mismatches or incorrect passwords.
* Invalid email formats or existing email/username conflicts.
* Database errors, such as not finding a user or collection.

#### Database Interaction
* SQLite Database (accounts.db): The app uses the cs50.SQL library to interact with a SQLite database that stores user and collection information.
    * Users Table: Stores user-related information such as username, hashed password, email, etc.
    * Collections Table: Manages the relationship between users and Pokémon cards, linking user IDs with card IDs.

In general, these routes cover functionalities for user registration, login, profile management, Pokémon-related features, and collection handling.

---

### functions.py 

#### Imports and Configurations
* UUID: Used to generate unique identifiers.
* CS50 SQL: Used for interacting with SQLite databases (pokedex.db and accounts.db).
* PokemonTcgSdk: A Python SDK for accessing the Pokémon Trading Card Game (TCG) API, allowing you to fetch card details, set details, prices, etc.
* Datetime and Time: Used for handling and formatting time and dates.
* Pytz: Used for timezone conversion.

#### Database and API Configuration
* poke_db: SQLite connection for the Pokémon database (pokedex.db).
* db: SQLite connection for the user account database (accounts.db).
* RestClient.configure: Configures the Pokémon TCG SDK with an API key to access Pokémon card data.

#### Functions
1.	lookup(value):
    - Checks if a value is a Pokémon name or ID.
    - If it's a name, the function queries the Pokémon database (pokedex.db) for Pokémon whose name is similar to the provided value.
    - If it’s a number, the function queries the Pokémon database (pokedex.db) for the corresponding Pokémon by its ID.
2.	find(value):
    - Searches for a Pokémon card using the Pokémon TCG SDK (Card.where).
    - If the card is not found by its name, it searches by card ID.
    - For each found card, the function checks and extracts various details:
        - Ancient Trait, Abilities, Attacks, Weaknesses, Resistances, and Prices.
    - Returns a dictionary containing these details for each found card.
3.	date_formatter(time):
    - Strips the time value and returns only the date.
4.	date_shift(date):
    - Converts a date from the format YYYY-MM-DD to MM/DD/YYYY.
5.	timezone(time):
    - Converts a given time into UTC time and formats it into YYYY-MM-DD.
6.	current_time():
    - Retrieves the current local time. (Although the full functionality isn't implemented, it checks if daylight saving time is active.)
7.	generate_uuid():
    - Generates a unique 128-bit UUID and returns the upper 64 bits of it as an integer.
8.	set_call(valid_sets):
    - Retrieves all available Pokémon TCG sets from the API.
    - Filters sets based on valid set IDs and sorts them by release date.
    - Extracts the unique series names of the sets and ensures that "Other" series is moved to the end.
    - Returns a dictionary containing set details (id, name, total, release date, logo, etc.) for each series.
9. find_set(user_id):
    - Queries the collection table in the user database (accounts.db) to find the card IDs associated with the user's collection.
    - Fetches the set IDs of those cards by querying the Pokémon TCG API for each card's set information.
    - Returns a list of valid set IDs associated with the user's collection.

---

### data.py

#### Imports and Setup
* The script imports two Python modules:
    * sqlite3: For interacting with the SQLite database.
    * csv: For reading the CSV file.
* The CSV file path (pokemon.csv) and the SQLite database file (accounts.db) are defined as variables.

#### Database Connection and Cursor
* The script establishes a connection to the SQLite database using sqlite3.connect(sql_file).
* A cursor object is created using conn.cursor(), which allows SQL commands to be executed.

#### Creating the Pokedex Table
* The script checks if the pokemon table already exists using the SQL command:
    ' CREATE TABLE IF NOT EXISTS pokemon (...) ' 
* The table is defined with various columns, each representing an attribute of a Pokémon. For example:
    - id: Primary key, unique Pokémon identifier.
    - pokedex_num: The Pokémon's Pokédex number.
    - name: The name of the Pokémon (in English).
    - jap_name: The Pokémon's Japanese name.
    - Various other columns describe Pokémon stats, abilities, types, and resistances against other types.
* Some columns allow NULL values (e.g., type_2, ability_2, etc.), indicating that these attributes may be absent for certain Pokémon.

#### Reading the CSV File:
* The csv.DictReader is used to read the CSV file. This reads each row of the CSV file into a dictionary where the keys are the column names.
* The script processes each row to extract the relevant values and convert them to the appropriate data types:
    * Integers (int()) are used for numerical columns like pokedex_num, generation, and stats like hp, attack, etc.
    * Floating point numbers (float()) are used for columns like height_m, weight_kg, and resistances against different types.
    * Missing values are handled by using None where appropriate (e.g., if weight_kg or catch_rate is missing).
    * The get() method is used for optional columns (e.g., type_2, ability_2, egg_type_2, etc.), which may be None if not present in the CSV.

#### Inserting Data into the Database:
* After reading and processing the data from the CSV file, the script uses the cursor.executemany() method to insert multiple rows into the pokemon table at once.
* The INSERT INTO pokemon ' (...) VALUES (?, ?, ?, ...) ' SQL command is used to insert the data into the appropriate columns.
* The rows variable, which contains a list of tuples, is passed to executemany(). Each tuple contains the data for one Pokémon, and the placeholders (?) in the SQL command are replaced with the corresponding values from the tuple.

#### Committing the Changes:
* The script commits the changes to the database using conn.commit(), ensuring that the data is saved.
* The connection to the database is closed using conn.close().

#### Success Message:
* A message Data Imported Successfully is printed to indicate that the data has been successfully imported into the database.

---

### legal (templates folder)
The legal folder serves as a resource directory in my project that contains HTML templates for displaying mock legal agreements. These include:
1.	Disclaimer: A statement that limits liability and clarifies the scope of the services I provide.
2.	EULA (End-User License Agreement): Defines the terms under which users can use my software or application.
3.	Privacy Policy: Explains how user data is collected, stored, and used, addressing any privacy concerns.
4.	Terms and Conditions: Sets the rules, guidelines, and expectations for users interacting with my service.

---

### archive_new (images folder)
The archive_new folder serves as an image directory for approximately 1044 different pokemon. These images are displayed dynamically through the "/images/<filename>” route which is accessed by the frontend SwiftUI.

#### Integration with SwiftUI
SwiftUI is used to access and display these HTML templates within my app. By leveraging SwiftUI’s HTML rendering, I ensure these pages are displayed dynamically and consistently, allowing users to easily navigate and view the legal information.

#### Styling
The styles for these HTML templates are centralized in the styles.css file. This file ensures a cohesive and professional design across all four legal pages. It standardizes fonts, colors, and layouts, making it easy for me to maintain and update the design in the future.

This setup provides a polished way to present legal information, enhancing the credibility and usability of my application.

--- 

### pokedex.db and accounts.db

pokedex.db and accounts.db are database files that handle two distinct types of information. The db file pokedex.db, surveys over the extensive pokedex information available for each pokemon in pokemon.csv from generation 1-8 —1044 different pokemon (pokedex numbers range from 1 – 898)— which is stored in one detailed table. Conversely, accounts.db is the main database file utilized for fetching user information from personal account information to collection information. Since data.py creates the pokedex found in pokedex.db, the table layout is found there and for accounts.db, I’ve included another file called table_prototypes.txt in which all relevant tables can be found. 

---

### .gitignore

Includes all files that are not present in my github repo for this project including my personal network information as well as files that might be developed in the future including CameraView.swift and HistoryView.swift. 

---

## Frontend Specifications

### ContentView.swift
This SwiftUI file defines the structure of a Pokémon-themed application that uses TabView for navigation between four primary tabs: Cards, Search, Collection, and Profile. The app incorporates various data models (e.g., Pokemon, PokemonCard, UserInfo) and observable objects (cards, series) to manage Pokémon-related and user-specific data. Each tab displays a distinct view, such as search functionalities, card collections, and user profiles, with state variables tracking user interactions and app behavior, like login status, selected Pokémon/cards, and active views. The app also supports future enhancements, such as camera integration and history views, indicated by commented-out placeholders.
#### Key Features:
##### Structs for Decodable Models
* Pokemon: Represents Pokémon data, including basic stats, abilities, types, and more. This struct adheres to the Decodable and Identifiable protocols for easy integration with SwiftUI lists.
* PokemonCard: Represents detailed Pokémon card data, including abilities, attacks, prices, and images. It also conforms to Decodable, Identifiable, Equatable, and Hashable.
* Set and Series: Used to represent card sets and series for organization.
* UserInfo: Stores information about a logged-in user, such as their username, email, and card collection details.

##### Observable Objects for Dynamic Updates
* cards: Stores and updates the Pokémon cards in the user’s collection.
* series: Tracks all available series and their sets, allowing for dynamic updates in the UI.

##### State Management
Various @State and @AppStorage variables manage app-wide data:

* @AppStorage("user_id"): Tracks the global user ID for logged-in users.
* Collection States: Manage the user's collection, including edits (collectionEdit) and selected cards.
* Login and View States: Determine which views to show (e.g., login, register, personal profile) based on the user's actions and authentication status.
* Search and Detail Views: Handle input, search results, and toggling detailed views for Pokémon and cards.
 
#### Implementation of Tabview Navigation:
##### Card Tab
* Displays card-related information using SearchCardTabView.
* Listens for updates to the card collection and gracefully hides detailed views when the user navigates away.

##### Search Tab
* Integrates with a Pokémon database to fetch Pokémon data based on user input.
* Uses a responsive layout to adapt to different screen sizes.

##### Collection Tab
* Manages the user's collection of Pokémon cards.
* Syncs with backend services to handle updates and display market values dynamically.

##### Profile Tab
* Provides login and registration views for new and existing users.
* Includes a personal profile view with settings for changing passwords and viewing personal details.
 
#### Future Enhancements:
There are placeholders for future features, such as:
- Camera Integration: A camera view to scan Pokémon cards and fetch related data.
- History View: A log of previous searches or collection modifications.
- Dynamic UI Transitions: Smooth animations for transitioning between views.
 
#### Code Design Principles:
- Modularity: The app's functionality is seperated into different structs and classes for better organization and scalability.
- SwiftUI Features: Extensive use of @State, @AppStorage, ObservableObject, and EnvironmentObject for seamless state management and reactivity.
- Customizability: Allows for flexible user interactions, from searching Pokémon data to managing detailed card collections.
- UI Adaptability: Ensures the app works well on various devices and screen sizes, thanks to SwiftUI's GeometryReader and dynamic layouts.
 
#### Developer Notes:
##### Handling Backend Interactions
* State variables like message, errorCode, and fault are used for error handling and feedback when interacting with the backend.

##### Extensibility
The file is designed to support additional features (e.g., camera integration) with minimal refactoring. Future views or functionalities can plug into the existing architecture.

#### Functions:
1.	fetchUserData():
    - This function fetches user data using the user_id. If no user_id is provided, it prints an error. It makes an HTTP GET request to the server using the Config.baseURL and user_id, decodes the response JSON into UserInfo, and updates the userData state on the main thread.
2.	resetSetsOnStart():
    - This function resets user sets using the user_id. It constructs a URL with the Config.baseURL and user_id, makes an HTTP GET request to reset the sets, and prints a success message upon completion.
3.	calculateMarketPrice(for pokemoncard: PokemonCard) -> String:
    - This function calculates the market price of a Pokémon card by checking different types of card prices. It returns the price as a formatted string in USD if available; otherwise, it returns "N/A".
4.	fetchUserID():
    - This function retrieves the user_id from UserDefaults. If no user_id is stored, it returns 0 as a default.

---

### SearchCardTabView.swift
SearchCardTabView is a SwiftUI file designed for users to search, browse, and interact with Pokémon cards. It integrates user interactions with backend data retrieval and manages the display of detailed card information. The component features animations, conditional views, and data binding to create a dynamic user experience.

#### Key Features:
##### Search Interface with Animations:
* Users can search for Pokémon cards using a search bar.
* Smooth animations are applied when toggling the search state (search).

##### Dynamic Views:
* The main screen adapts between the default state, search results, and card detail views.
* The UI hides or transitions elements dynamically based on user interactions.

##### Backend Integration:
* Sends a POST request with the Pokémon card search term to retrieve data from the backend.
* Parses the API response and updates the card list (cardData).

##### Card Details Display:
* When a card is selected, a detailed view (PokemonCardInfo) appears, showing attributes like name, set details, and market price.
* Market price calculations are performed dynamically.

##### Customizable View States:
* The UI responds to various bindings, allowing external components to control behaviors like showing login, register views, and handling error messages.

#### Data Management:
##### State Variables:
- search: Toggles the search bar.
- hasAnimated: Tracks if the search animation has completed.
- cardData: Stores fetched Pokémon card data.
- pokecard: Stores the current search input.
- isSearchFieldFocused: Tracks focus state of the search bar.
##### Binding Variables:
- showCardDetail: Controls the visibility of the card detail view.
- selectedCard: Stores the currently selected Pokémon card.
- collectionEdit, collection: Manage the user's card collection.
- market: Stores the market price of the selected card.
- showLoginView, showRegisterView: Handle authentication-related views.
- message, errorCode, fault: Manage and display error messages.

#### Component Workflow:

##### Default View:
* Displays a placeholder image and a search bar.

##### Search Execution:
* Users input a search term, triggering an API call via submitPokecard().
* Retrieved data is displayed in a list format.

##### Card Selection:
* Users select a card, which triggers the PokemonCardInfo view to display details.

##### Dynamic Layouts:
* Layout adjusts based on device type (e.g., notch devices) using GeometryReader.
##### Animations:
* Smooth transitions are applied when toggling between views.

#### Functions:
1. submitPokecard():
    - Sends a POST request to the backend to fetch Pokémon card data.
    - Updates cardData state with the retrieved results or resets it on error.

#### Future Enhancements:
##### Camera Integration:
* Upload and capture options are outlined but commented out.
##### Additional Animations:
* Fine-tuning transitions for better UX.
 
---

### SearchTabView.swift
The SearchTabView is a SwiftUI component designed for the Pokémon app, providing a dynamic search interface where users can find Pokémon by name or Pokédex number. It integrates seamless animations, user-friendly input handling, and a detailed list of results with the ability to view more information about each Pokémon.

#### Features:
##### Search Bar Animation:
* The search bar dynamically appears and expands when the user begins typing.
* Includes a "Back" button to collapse the search bar, allowing the user to exit search mode.

##### Responsive Design:
* Adapts to devices with and without a notch, ensuring visual consistency across different screen sizes.
* Adjusts heights, offsets, and layouts based on the geometry and safe area insets.

##### Pokémon Display:
* Displays a list of Pokémon matching the search query with their corresponding images, names, and Pokédex numbers.
* Clicking on a Pokémon reveals a detailed view with an image and stats, transitioning smoothly with animations.

##### Image Handling:
* Downloads Pokémon images from a server and caches them locally for immediate display during future interactions.

##### Search Field:
* Supports autocomplete-like functionality by fetching and displaying Pokémon data as the user types.
* Input is sanitized with disabled autocorrect and lowercase enforcement for a better user experience.

##### Fallback and Error Handling:
* Gracefully handles scenarios where no Pokémon data is fetched by clearing the list and providing user feedback.
8 Manages image download failures with safe URL validation and task handling.

##### Animations:
* Smooth transitions for UI elements, including appearing/disappearing search components and the Pokémon detail view.

#### Key Components:
##### State Management:
* @State variables manage search status, user input, and Pokémon data.
* @Binding properties allow this view to work seamlessly with parent views.

##### Focus Handling:
* Utilizes @FocusState to focus and unfocus the search field based on user interactions.

##### Backend Integration:
* Sends search queries to a Flask backend, retrieves data in real time, and decodes JSON responses into a list of Pokémon objects.

##### List Rendering:
* Dynamically updates the list view based on the fetched Pokémon data, ensuring a responsive and interactive experience.

##### Detail View Overlay:
* Displays an overlay when a Pokémon is selected, showing detailed information with a smooth slide-in transition.

#### Functions:
1.	submitPokedata:
    - Sends a POST request to the backend with the current search query (pokedata).
    - Decodes the returned JSON into an array of Pokemon objects, updating the UI with the results.
2.	fetchImage:
    - Downloads an image for a specific Pokémon using its name and caches it in the pokemonImages dictionary.

--- 
 
### CollectionTabView.swift
The CollectionTabView is a SwiftUI view designed to display and manage a user's Pokémon card collection. It supports various states, from displaying cards to showing loading indicators or prompts when the collection is empty.

#### Key Features:
##### User Management: 
* Uses @AppStorage for user ID persistence and checks login status to adjust the UI accordingly.
##### Collection Overview: 
* Displays a summary of the collection, including an estimated net worth calculated from Pokémon cards. If the collection is empty, a prompt encourages adding cards.
##### Series and Set Display: 
* Cards are grouped by series and set, with images of set logos and symbols. The view shows counts of collected vs. total cards and allows users to expand or collapse sets to view detailed cards.
##### Card Interaction: 
* Cards are displayed in rows, sorted numerically by card number. Tapping a card reveals detailed information, including the card’s market price and image. The detail view uses a smooth transition for appearing and disappearing.
##### Loading and Error States: 
* Displays loading spinners when data is being fetched and shows placeholder messages if data is unavailable.
##### Detail View: 
* Provides detailed information about selected cards, including market price and card image. It allows for easy dismissal back to the collection list.
##### User Interaction: 
* Includes buttons to toggle the visibility of series and sets and interaction that affects the UI state (e.g., expanding or collapsing sets).
##### Error Handling: 
* Displays placeholder messages when data is missing or unavailable and provides feedback through random phrases when the collection is empty.
 
#### Components:
##### State Management: 
* Utilizes @AppStorage for user ID and @EnvironmentObject for accessing the card collection and series data. Local state management is handled using @State for UI elements like loading states and animations.
##### UI Layout: 
* Uses VStack and HStack for organizing UI elements, GroupBox for grouping content, and AsyncImage to handle image loading. ProgressView indicates loading states.
##### Data Fetching: 
* Fetches series, set data, and user card collections on view initialization and updates UI state accordingly. Random phrases are used to prompt users if the collection is empty.
##### Detail View: 
* PokemonCardInfo displays detailed information about selected cards with a dismissable view using an animation.
##### Lifecycle Events: 
* onAppear is used to initialize data fetching and manage state when the view appears. shown state updates for each series ensure a consistent UI.

#### Functions:
1.	fetchCollection():
    - This function is responsible for retrieving a user's Pokémon card collection from the server. It starts by setting a loading state and constructing a URL for the request. Using URLSession, it makes a GET request to the server. Upon receiving a response, it checks for any error or status code issues. If successful, it decodes the response data into an array of PokemonCard objects and updates the UI state accordingly.
2.	fetchSets():
    - This function fetches the different Pokémon card sets associated with the user. It sets a loading indicator and constructs a URL for the sets request. It then uses URLSession to make a network call. Depending on the response, it either decodes the data into an array of Series objects or an integer and updates the UI state to reflect the fetched data.
3.	total() -> Double:
    - This function calculates the total market value of all the Pokémon cards in the user's collection. It iterates through each card, summing up their market prices across different card types. The result is returned as a Double, representing the total value of the collection.
4.	fetchCount(completion: @escaping (Int) -> Void):
    - This function retrieves the count of Pokémon cards in the user's collection. It creates a URL for the count request and uses URLSession to fetch the data. Upon receiving a response, it decodes the data to an integer and calls the provided completion handler with this count.
 
---

### ProfileTabView.swift
ProfileTabView is a SwiftUI file that provides a comprehensive view for managing user profiles. It displays the user's profile picture, username, and card collection count. The view includes sections for account management (personal details, password change, and future history) and legal information (terms, privacy policy, EULA, disclaimer). It offers animations to enhance user interaction, such as toggling between views when buttons are clicked. The component also includes a sign-out button that resets the user ID and updates the state to reflect that the user is no longer logged in.
#### Key Features:
##### User Interface: 
* The ProfileTabView provides a user interface for managing a user's profile and account settings. It uses GeometryReader to adapt UI elements based on screen size.
##### User Data: 
* It displays the username and the count of collected cards for the logged-in user, fetched from the UserInfo binding.
##### Profile Image: 
* The profile picture is displayed using an Image view, clipped into a circular shape, with a black border.
##### Account Management: 
* It includes buttons to toggle views for personal details, password change, and history (future implementation). Each button uses animation to show/hide the corresponding view.
##### Legal Information: 
* There are buttons to open URLs for terms and conditions, privacy policy, EULA agreement, and a disclaimer. The URLs are constructed using the base URL from Config and open in the system’s default browser.
##### Sign Out Functionality: 
* A sign-out button is provided, which sets the user ID to 0, triggers a state change for login visibility, and marks the user as not logged in.
##### Animations: 
* Animations are used for transitioning views when buttons are clicked.

---

### PokemonCardInfo.swift
PokemonCardInfo is designed to display detailed information about a specific Pokémon card. It allows users to add or remove the card from their collection, view its details, and check market prices. The view uses GeometryReader to ensure responsive layout adjustments based on screen size.
#### Key Features:
##### User Interface:
* The view includes a back button for easy navigation and an Add/Remove button that toggles the card’s collection status. AsyncImage is used to display the Pokémon card image and set symbol, with a loading placeholder for a smooth user experience. Card details such as name, series, set name, and card number are prominently displayed.
##### Market Price Display:
* Current market prices for the Pokémon card are shown, allowing users to quickly see the card's value.
##### Card Information:
* This section includes detailed card information, such as subtypes, rarity, types, and legalities. It lists Pokedex numbers, regulation marks, health points (HP), Ancient Traits, abilities, attacks (including energy costs and damage values), weaknesses, resistances, retreat costs, special Pokémon types (EX, GX, VSTAR, etc.), flavor text, and artist details.
##### Data Management:
* The view uses state variables to manage the visibility of sections (shown, collectRequest, notLoggedIn) and the collection request status. It updates the collection state based on user actions, storing preferences using UserDefaults to maintain persistence.
##### Network Interaction:
* collectRequest is used to determine if a card should be added or removed from the user’s collection, and changes are submitted via submitCollect(). The view also handles cases where the user is not logged in by displaying appropriate messages.
##### Expandable Pricing Sections:
* Pricing information (Market Prices, Low Prices, Mid Prices, High Prices, Direct Low Prices) is categorized and expandable with a chevron icon.
* Each section uses ForEach to display data conditionally, showing "Price Unavailable" if data is missing.
##### Dynamic Pricing Display:
* Prices are displayed based on type (Market, Low, Mid, High, Direct Low).
* Each price section is structured to show relevant information, including formatted USD values.
* Error handling ensures users are informed if price data is not available.
##### Card Update Information:
* Displays the last updated timestamp for the card’s pricing data (pokemonCard.tcgUpdatedAt), keeping users informed about the recency of the data.
##### User Authentication Flow:
* The view uses a sheet to present LoginView or RegisterView when the user is not logged in (notLoggedIn state).
* A "Close" button allows users to dismiss authentication views.
* On changing pokemonCard, collectRequest is updated to store user preferences across sessions.
##### Error Handling:
* Error codes and messages are updated as needed, and the view manages fault states to ensure users are informed when something goes wrong, such as network errors or data processing issues.
#### Functions:
1.	submitCollect():
    - This function sends a collection request for a Pokémon card to the server. It validates the URL, sets up an HTTP POST request with the necessary card details, and sends it asynchronously using URLSession. It handles errors and checks if the server response is successful (status code in the 200-299 range).
2.	isPriceAvailable(in prices: [String: Double?]) -> Bool:
    - This function checks whether any price is available in the given dictionary of Pokémon card prices. It returns true if any price is not nil, indicating that at least one card has a price, otherwise false.
3.	updateLoginState():
    - This function updates the login state based on the visibility of the showRegisterView and showLoginView. If both views are not visible, it sets notLoggedIn to false, indicating that the user is logged in. This helps manage the UI components based on the user's authentication status.
 
---

### PokemonInfo.swift
PokemonInfo view is a SwiftUI view that presents detailed information about a specific Pokémon. It allows users to view essential data such as the Pokémon’s name, type, abilities, stats, and how it fares against different types in terms of resistance and weakness. The view includes a back button for navigation, displays images, and visualizes data through lists and bars.
#### Key Features:
##### User Interface:
* The view uses a clean and structured design that prioritizes readability and usability. It features a simple and intuitive layout, which makes it easy for users to navigate and find the information they need.
* The main content is divided into sections, including Pokémon details, type information, abilities, stats, and resistances/weaknesses. Each section is clearly labeled to provide context and enhance user understanding.
##### Visual Presentation:
* Pokemon Details: The view displays the Pokémon’s name, Japanese name, and Pokedex number using Text views. These elements are presented in a clear and straightforward manner.
* Image Display: An Image view is used to show the Pokémon’s visual representation. It defaults to a placeholder if no image is available, ensuring the interface remains consistent.
* Type Visualization: Types are represented using HStack with colored backgrounds, allowing users to quickly identify the Pokémon’s type. The colors provide visual cues and enhance the presentation of type-related information.
##### Data Visualization:
* Abilities and Stats: Each ability is displayed in a List view. The Pokémon’s stats (e.g., HP, Attack, Defense) are visualized using horizontal bars (ProgressView) that indicate each stat’s value with a color-coded representation based on the Pokémon’s type.
* Resistances and Weaknesses: These are presented in a DisclosureGroup that allows for easy expansion and contraction. Each type resistance and weakness is clearly labeled and accompanied by a numerical multiplier, providing quick insights into the Pokémon’s strengths and vulnerabilities.
##### User Interaction:
* The view ensures that all elements are easy to interact with. Whether it’s tapping to view more details or swiping through sections, the user interface is designed to provide a smooth and responsive experience.
#### Functions:
1.	func calculateWidth(for value: Int, max: Int, columnWidth: CGFloat) -> CGFloat
    - This function calculates the width of a UI element (such as a progress bar) relative to a given value compared to a maximum value. It’s useful for dynamically sizing UI components based on their content, ensuring they are visually proportionate.
2.	func colorForStat(_ value: Int, max: Int) -> Color
    - This function determines the color to represent a Pokémon’s stat value on the UI. It provides a visual indication of the stat’s magnitude by mapping it to a color spectrum, allowing users to quickly interpret the data.

---

### LoginView.swift
The LoginView code provides a user-friendly interface for logging into an application. It includes input fields for username/email and password with real-time validation and error handling. The view manages state using @State and @Binding properties to control user interactions and display backend error messages. The login process is facilitated by sending a POST request to the server and handles transitions to the registration view if needed. It also retrieves existing user data through a GET request, ensuring a seamless experience for users.
#### Key Features:
##### User Interface:
* The LoginView presents a clean and straightforward interface for logging in with fields for username/email and password, accompanied by dynamic error messages.
* The layout is organized using a GroupBox, styled with padding, background colors, and rounded corners for a polished look.
* Input fields include error handling to provide feedback on invalid or missing information.
##### State Management:
* @State properties manage user input and UI state, including account, password, loggedIn, accountError, passwordError, and existingUserData.
* @Binding properties like showLoginView, showRegisterView, message, errorCode, and fault control view transitions and display backend error messages.
##### Validation and Error Handling:
* The LoginView validates user inputs, showing appropriate error messages for missing or incorrect entries.
* The submitLogin function handles login requests, updating the UI based on the success or failure of the login attempt.
##### Login Process:
* The login process is triggered when the user clicks the "Log In" button, sending a POST request to authenticate the user.
* On successful login, it retrieves and stores the user ID. If there’s an error, it displays a corresponding error message.
##### Network Requests:
* The submitLogin function sends a POST request to the backend to authenticate the login.
* The getData function retrieves existing user data via a GET request to the server.
##### Transition Management:
* The "Don't Have an Account?" button provides an option to transition to the registration view smoothly.
##### Error State Management:
* The fault state indicates login errors, displaying appropriate messages based on backend responses.
* message and errorCode store error details for user feedback.

--- 

### RegisterView.swift
RegisterView is a SwiftUI view designed for user registration, featuring a form with fields for personal information, email, and password. It includes real-time error messages for various input fields, date picker for birth date selection, and secure password fields with validation. The view manages state for user inputs, error handling, and form submission to a backend server, with animations for transitions between registration and login views. It also handles existing user data checks to prevent duplicate entries.
#### Key Features:
##### User Interface:
* Includes fields for user information, such as first name, last name, birth date, email, username, password, and confirm password.
* Real-time error messages are displayed to inform users of validation issues, such as incomplete or mismatched information.
* A date picker allows users to select their birth date, and a confirmation button submits the selected date.
* Password fields are secured with validation to ensure the password and confirm password match.
##### State Management:
* State variables manage user inputs like first name, last name, birth date, email, username, password, and confirm password, as well as validation errors.
* Focus management is handled using @FocusState to manage which field is currently in focus.
* The view checks existing user data to prevent duplicate emails or usernames.
##### Error Handling:
* Backend error messages, error codes, and fault flags are managed through @Binding variables.
* Frontend error checking validates user inputs before submission and provides clear error messages for each field.
##### Submission Logic:
* The view validates all user inputs before sending the registration data to the backend.
* Upon successful registration, the view transitions between the registration and login views.
* An alert displays error information if there is a backend fault.
#### Functions:
1.	func submitRegistration(completion: @escaping (Bool) -> Void)
    - This function sends a registration request to the server using a POST request with user inputs like first name, last name, birth date, email, username, password, and confirm password. It sets up the request with the appropriate URL and Content-Type, then sends it via URLSession. The function handles server responses, updating the UI with an error message if the response indicates a fault (status code >= 400) and setting a fault flag. For a successful submission, it calls the completion closure with the fault status.
2.	func getUserData()
    - This function retrieves user data from the server by sending a GET request. It parses the JSON response into a dictionary and updates the existingUserData state variable on the main thread. If parsing fails or an error occurs, it resets existingUserData and prints an error message.
3.	func dateClipper(_ date: Date) -> String?
    - This function formats a Date object into a string in the MM/dd/yyyy format using a DateFormatter. It returns the formatted date string for display or storage.
4.	func isValidEmail(_ email: String) -> Bool
    - This function uses a regular expression to validate whether the provided email string matches a typical email format. It returns true if the email is valid, otherwise false.

---

### PersonalView.swift
The PersonalView SwiftUI view provides a form-based interface for updating user profile details such as name, birthdate, email, username, and password. It includes a two-step process with a password confirmation screen and a detailed personal details editing screen. The view features error validation for fields, date pickers for birthdate selection, and dynamic UI updates using animations and focus states. It integrates with user data bindings and handles alert displays for backend errors, offering a smooth and interactive user experience for managing personal information.
#### Key Features: 
##### State Management:
* The struct uses several state variables to track user input, errors, and UI state:
    * @State for fields like firstName, lastName, birthDate, email, username, and password.
    * @State for error messages (nameError, birthDateError, emailError, usernameError, passwordError).
    * @State for flags like shown, changed, same, confirmation, showAlert.
##### View Hierarchy and Navigation:
* The view conditionally displays different content based on the confirmation state:
    * If confirmation is true, it displays the confirmationView asking for password confirmation.
    * If confirmation is false, it displays the formContent where the user can edit personal details.
* Navigation back and forth between confirmationView and formContent is managed with buttons.
* Alerts are shown based on error states (showAlert).
##### Form Content:
* Personal details are divided into sections for Name (firstName, lastName), Date of Birth, Email, and Username.
* Each section includes appropriate text fields with validation:
    * Fields are autocompleted and have custom styling (padding, background color, corner radius).
    * Each field has a @FocusState to keep focus on the active field.
    * Validation and error messages are displayed dynamically (e.g., if a field is empty or contains invalid data).
##### User Interaction and Error Handling:
* The PersonalView struct validates user inputs on the frontend and triggers backend validation when submitting changes.
* User actions (confirm, update, revert changes) are handled with buttons.
* Validation errors are dynamically updated and displayed based on the current user input against existing data (firstName, lastName, birthDate, email, username).
* On successful submission, the view animates with .easeInOut().
##### Date Handling:
* Date picker for selecting the birthDate is displayed with a WheelDatePickerStyle().
* The selected date is formatted and displayed in the view.
* Date errors are handled, ensuring the user’s birthdate is valid and not in the future.
##### Error Messages and Feedback:
* Error messages are color-coded to distinguish between user-facing (e.g., blue) and critical (e.g., red) messages.
* Feedback like same tracks if there have been changes to user data and adjusts messages accordingly.
* Alerts are shown for critical errors during submission, allowing the user to take corrective action.
#### Functions:
1.	submitConfirmation(completion: @escaping (Bool) -> Void)
    - This function sends a POST request to confirm user information with the server. It constructs the request with user_id and password, handles server responses, and calls a completion handler with a fault flag indicating success or failure.
2.	submitChange(completion: @escaping (Bool) -> Void)
    - This function sends a POST request to update user information (like name, birth date, email, and username) on the server. It processes the server response and updates the fault flag accordingly, passing the result to the completion handler.
3.	fetchInfo()
    - This function retrieves the user's personal information from the server via a GET request. It handles the server response asynchronously, parses the JSON data, and updates existingUserData.
4.	resetFields()
    - This function clears the user input fields to their default empty state, allowing for a fresh start.
5.	dateShift(_ dateString: String) -> String
    - This helper function converts a date string from one format to a more readable format (MMMM dd, yyyy). If the date string is invalid, it returns an error message.
 
---

### PasswordChangeView.swift
The PasswordChangeView enables users to update their account passwords. It incorporates error handling, user input validation, and a network request to submit the password change. The view uses SwiftUI bindings and focuses on an interactive user interface with visual feedback.
#### Key Features:
##### User Data Management:
* Uses @AppStorage for storing the user_id and binds to userData for managing user information.
* Uses @Binding properties for message, errorCode, and fault to handle feedback and state updates.
* Maintains local states for fields like email, password, newPassword, and confirmNewPassword.
##### Error Handling and Validation:
* Validates user inputs with state variables for errors (emailError, passwordError, newPasswordError, confirmNewPasswordError).
* Checks if the email is valid, if the new password differs from the old password, and if both passwords match.
* Displays error messages in the UI if validation fails.
* Alerts the user when the operation fails with details from message and errorCode.
##### User Interface:
* Uses SecureField for secure password input fields.
* Includes buttons for reverting changes and updating passwords, with associated actions.
* Hides fields until certain conditions are met and focuses the user’s attention as needed.
* Uses GeometryReader for a responsive layout and ZStack for layering UI elements.
##### Handling Changes and Alerts:
* Calls submitPasswordChange to send a POST request for updating passwords.
* Handles responses, including displaying an alert if the password is incorrect or if there’s an error.
* Uses @State variables to manage UI state (e.g., loggedIn, check, showAlert).
* Provides animations for UI transitions when changing passwords.
##### Networking:
* Utilizes URLSession to handle network requests for updating the password.
* Constructs the request body using user_id, email, password, newPassword, and confirmNewPassword.
* Handles errors and successful responses from the server, updating the fault state accordingly.
#### Functions:
1.	resetFields()
    - This function clears the user input fields to their default empty state, allowing for a fresh start.
 
---

### CreditsView.swift
The CreditsView in SwiftUI displays acknowledgments and resources used in the app. It includes a dismiss button at the top, a heading "Credits & Acknowledgement", and links to various resources like the Kaggle Pokemon dataset, the Pokemon TCG API, and Harvard CS50x course materials. Each link is styled as a button with rounded corners and a border. The view is responsive, adapting to different screen sizes by stacking buttons vertically. There is also a placeholder for potential future features such as a camera view.
#### Key Features:
##### Grouped Content:
* CreditsView displays all credits and acknowledgements in a grouped format within a GroupBox, making it easy to read and understand the different resources and credits.
##### Resource Links: 
* It provides multiple buttons linking to important resources:
    * A Kaggle dataset URL for a comprehensive Pokemon dataset.
    * A link to the Pokemon Trading Card Game API documentation.
    * A Harvard CS50x link
##### Button Styling: 
* Buttons that link to resources are styled with rounded corners, padding, and a border to improve their visual appeal and user interaction.
##### Responsive Layout: 
* The layout adjusts for smaller screens, with buttons stacking vertically in a VStack for better usability on mobile devices.
 
## Enjoy exploring the world of Pokémon!

