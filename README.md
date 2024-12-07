# Skeleton Loader

![Gem Version](https://img.shields.io/badge/gem-v0.1.0-brightgreen)
[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/8MamMcAVAVNWTcUqkjQk7R/Sh2DQkMWqqCv4MFvAmYWDL/tree/main.svg?style=svg&circle-token=CCIPRJ_PF8xu3Svcj2Ro4D8jhjCi7_71b7c0a7c781e09fc7194cd58cca67aecdc111b5)](https://dl.circleci.com/status-badge/redirect/circleci/8MamMcAVAVNWTcUqkjQk7R/Sh2DQkMWqqCv4MFvAmYWDL/tree/main)
![Test Coverage: 100%](https://img.shields.io/badge/Test%20Coverage-100%25-brightgreen)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

**Skeleton Loader** is a Ruby on Rails gem for creating animated placeholders that enhance loading states. Whether rendered through Rails views or dynamically with JavaScript, these skeletons provide a seamless visual experience while content loads.

**⚠ Note:** Skeleton Loader is an experimental gem currently in early development, exploring the possibilities in the magical world of Rails gems. While loaders are ideally handled client-side, this gem aims to make it easy to add placeholders directly within the Rails realm.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Setup](#setup)
- [Rails Integration](#rails-integration)
- [JavaScript Integration](#javascript-integration)
- [Configuration](#configuration)
- [Code Quality](#code-quality)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

![1](https://github.com/user-attachments/assets/f6f91f55-1bfa-42eb-9e8c-41606eb8afd5)

## Features

- 🚀 **Seamless Rails integration:** Enhances loading transitions with minimal setup.
- 🔨 **Universal skeletons:** Creates loading states in Rails views & JavaScript.
- ⚙️ **Consistency:** Unified templates & options across both environments.
- ⚡ **Lightweight & fast:** Designed to be fast and easy to implement with minimal dependencies.

---

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "skeleton-loader"
```

Then, run:

```bash
bundle install
```

#### Requirements

- **Ruby** 2.5 or higher
- **Rails** 5.0 or higher
- **Asset Pipeline** (Required for CSS handling)

---

## Setup

### CSS Assets

The gem's CSS is always managed via the Asset Pipeline:
```javascript
/* app/assets/stylesheets/application.css */
*= require skeleton_loader
```

### JavaScript Assets

Include the JavaScript functionality using Asset Pipeline, Webpack, or Importmap, depending on your setup:


#### **Option 1: Asset Pipeline (Default for Rails 5)**

In `app/assets/javascripts/application.js`, add:

```javascript
//= require skeleton_loader
```

#### **Option 2: Webpack (Default for Rails 6)**

1. Install the package using Yarn:

```bash
yarn add "@ersync/skeleton-loader"
```

```javascript
import SkeletonLoader from "skeleton-loader"
```

#### **Option 3: Importmap (Default for Rails 7)**

1. Pin the package in `config/importmap.rb`:

```ruby
pin "skeleton-loader", to: "skeleton_loader.js"
```

```javascript
import SkeletonLoader from "skeleton-loader"
```

### Install Templates

To install predefined templates, run:

```bash
rails generate skeleton_loader:add_templates
```  

This adds templates to `app/views/skeleton_loader/`. Customize them as needed.

To restore defaults later:

```bash
rails generate skeleton_loader:reset_templates
```  

---

## Rails Integration

The gem provides a primary view helper, `skeleton_loader`, which generates a skeleton that is automatically replaced with content once loading completes. You can use it with predefined templates or define your own HTML blocks.

```ruby
skeleton_loader(
        content_id:,         # Required. Target element ID for replacement
        **options,           # Optional. Customize the template
        &block               # Optional. Define custom skeleton HTML (excludes type/options)
)
```

### 1. Pre-defined Templates

Specify `content_id` and, optionally, a template `type` and customization `options`.

```erb
<%= skeleton_loader(content_id: 'content-element', 
  type: "card",
  count: 5,
  scale: 1.2,
  animation_type: 'animation-pulse') %>
```

### 2. Custom Skeletons with a Block

Define your own HTML structure in a block. Note that `type` and `options` are not used.

```erb
<%= skeleton_loader(content_id: 'content-element') do %>
  <div class="custom-skeleton">
    <div class="avatar skeleton-circle"></div>
    <div class="text-lines"></div>
  </div>
<% end %>
```

See [Configuration](#configuration) for all available options.

---

## JavaScript Integration

Skeleton Loader also provides a JavaScript API to dynamically create skeletons independently of Rails views.

<details>
<summary>💡 You only need this API if you're loading content asynchronously i.e. AJAX calls. For standard Rails views, use the Rails helper method instead.</summary>

### 1. Basic Setup

First, initialize the SkeletonLoader in your JavaScript:

```javascript
const skeleton = new SkeletonLoader();
```

### 2. Creating Skeletons

There are two methods for creating skeletons using JavaScript:

#### Using Pre-defined Templates

```javascript
const loader = skeleton.render({
  contentId,                    // Required. ID of the element to replace with skeleton
  ...options                    // Optional. See configuration section for available options
});
```

#### Creating Custom Skeletons

```javascript
const loader = skeleton.renderCustom({
  contentId,                    // Required. ID of the element to replace with skeleton
  markup                        // Required. Custom HTML string for skeleton content
});
```

### 3. Managing Loading States

Each skeleton instance (both `render()` and `renderCustom()`) returns an object with these methods:

- `isLoading()`: Returns the current loading state
- `reveal()`: Removes skeleton and displays content

```javascript
// Check if still loading
if (loader.isLoading()) {
  // Do something while content loads
}

// Remove skeleton and show content
loader.reveal();
```

<details>
<summary><strong>Practical Examples</strong></summary>

Here's some example showing how to use the skeleton loader with an API call:

```javascript
async function loadUserProfile(userId) {
  // Create skeleton while loading
  const loader = skeleton.render({
    contentId: 'content-element',
    type: 'profile'
  });

  try {
    // Fetch your data
    const response = await fetch(`/api/users/${userId}`);
    const userData = await response.json();

    // Update the DOM with your content
    document.getElementById('content-element').innerHTML = createUserProfile(userData);

    // Remove the skeleton
    loader.reveal();
  } catch (error) {
    console.error('Failed to load user profile:', error);
    loader.reveal(); // Always cleanup the skeleton
  }
}
```

```javascript
async function loadDashboard() {
  // Create multiple skeletons
  const loaders = {
    profile: skeleton.render({ contentId: 'profile', type: 'profile', scale:1.2, width:250 }),
    stats: skeleton.render({ contentId: 'stats', type: 'card', scale:1.3, animationType:"sl-flow" }),
    activities: skeleton.render({ contentId: 'activities', type: 'list' })
  };

  // Load your data
  const [profileData, statsData, activitiesData] = await Promise.all([
    fetchProfile(),
    fetchStats(),
    fetchActivities()
  ]);

  // Update content and reveal each section
  updateProfile(profileData);
  loaders.profile.reveal();

  updateStats(statsData);
  loaders.stats.reveal();

  updateActivities(activitiesData);
  loaders.activities.reveal();
}
```
</details>
</details>

---

## Configuration

### Options

The following options can be passed to both the Rails view helper and JavaScript API. Note that Rails uses snake_case (e.g., `animation_type`), while JavaScript uses camelCase (e.g., `animationType`).


| Option | Type | Description | Default | Example |
|--------|------|-------------|---------|---------|
| `content_id` | String | Unique identifier for the skeleton loader container | `nil` | `"content-element"` |
| `type` | String | Predefined template type (e.g., "product", "profile") | `"default"` | `"product"` |
| `width` | Integer | Base width of a single skeleton item in pixels | Depends on `type` | `250` |
| `count` | Integer | Number of skeleton items to render | Depends on `type` | `6` |
| `per_row` | Integer | Number of skeleton items displayed per row | Depends on `type` | `4` |
| `scale` | Float | Size multiplier for all skeleton item dimensions | `1.0` | `1.2` |
| `animation_type` | String | Type of loading animation | `"sl-gradient"` | `"sl-glow"` |

**Notes:**
- `type` determines default layout and styling
- `scale` affects width and spacing proportionally
- `animation_type` supports different loading effect styles

### Available Templates

Skeleton Loader comes with several pre-built templates, each with their **default** configurations:

| Template Type | Default Width | Count | Items Per Row |
|--------------|---------------|-------|---------------|
| `card`       | 200px         | 3     | 3            |
| `comment`    | 900px         | 2     | 1            |
| `default`    | 900px         | 1     | 1            |
| `gallery`    | 320px         | 3     | 3            |
| `paragraph`  | 900px         | 1     | 1            |
| `product`    | 320px         | 3     | 3            |
| `profile`    | 320px         | 3     | 3            |

For an interactive preview of available templates and animations, visit the [Live Demo](https://ersync.github.io/skeleton-loader/).

### Available Animations

Choose from several animation styles to match your design:
- `sl-gradient` (default): Smooth gradient movement
- `sl-shine`: Shimmer effect
- `sl-pulse`: Fade in/out
- `sl-flow`: Continuous flow
- `sl-neon`: Subtle glow
- `sl-breathing`: Gentle scaling

### Application Defaults

To set application-wide defaults, create `config/initializers/skeleton_loader.rb`:

```ruby
SkeletonLoader.configure do |config|
  # Override default template settings
  config.templates[:product] = {
          width: 400,
          count: 6,
          per_row: 3
  }
  # Global settings
  config.scale = 1.0                     # Default: 1.0
  config.animation_type = "sl-gradient"  # Default: "sl-gradient"
end
```

### Advanced Configuration

For applications requiring custom HTML elements or styles:

```ruby
SkeletonLoader.configure do |config|
  config.additional_allowed_tags = []                  # Default: []
  config.additional_allowed_attributes = {}            # Default: {}
  config.additional_allowed_css_properties = []        # Default: []
end
```

---

## Code Quality

Skeleton Loader maintains code quality through:

- **RSpec**: Comprehensive tests covering core functionality.
- **CircleCI**: Continuous integration ensures all new changes meet quality standards.
- **Rubocop**: Consistent linting aligns code with Ruby community conventions.

---

## Roadmap

Here are some features I'd like to add when I have time:

- **New Templates & Animations**: Expanding template and animation options.
- **Turbo & Stimulus Support**: Enhancing compatibility with Rails Turbo and StimulusJS.
- **Builder Helper for Custom Skeletons:**: Introducing a helper to easily create custom skeletons (e.g., circles, rectangles, etc.) with customizable options, simplifying the process of designing custom skeletons.

Suggestions and contributions are welcome!

---

## Contributing

To contribute:

1. Fork the repository.
2. Create a new feature branch.
3. Add tests for new features.
4. Commit your changes and submit a pull request.

Please follow the [Code of Conduct](https://github.com/ersync/skeleton-loader/blob/main/CODE_OF_CONDUCT.md) for all contributions.

---

## License

Skeleton Loader is licensed under the MIT License. See [LICENSE](https://github.com/ersync/skeleton-loader/blob/main/LICENSE) for details.