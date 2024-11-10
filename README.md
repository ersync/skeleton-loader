# Skeleton Loader

![Gem Version](https://img.shields.io/badge/gem-v0.1.0-brightgreen)
[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/8MamMcAVAVNWTcUqkjQk7R/Sh2DQkMWqqCv4MFvAmYWDL/tree/main.svg?style=svg&circle-token=CCIPRJ_PF8xu3Svcj2Ro4D8jhjCi7_71b7c0a7c781e09fc7194cd58cca67aecdc111b5)](https://dl.circleci.com/status-badge/redirect/circleci/8MamMcAVAVNWTcUqkjQk7R/Sh2DQkMWqqCv4MFvAmYWDL/tree/main)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

**Skeleton Loader** is a Ruby on Rails gem for creating animated placeholders that enhance loading states. Whether rendered through Rails views or dynamically with JavaScript, these skeletons provide a seamless visual experience while content loads.

**⚠** Note: Skeleton Loader is an experimental gem currently in early development, exploring the possibilities in the magical world of Rails gems. While loaders are ideally handled client-side, this gem aims to make it easy to add placeholders directly within Rails realm.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Setup](#setup)
- [Rails Integration](#rails-integration)
- [JavaScript Integration](#javascript-integration)
- [Configuration](#configuration)
- [Code Quality](#code-quality)
- [To-Do](#to-do)
- [Contributing](#contributing)
- [License](#license)

---
![1](https://github.com/user-attachments/assets/f6f91f55-1bfa-42eb-9e8c-41606eb8afd5)


## Features

- 🚀 **Seamless Rails integration** Enhances loading transitions with minimal setup
- 🔨 **Universal skeletons:** Creates loading states in Rails views & JavaScript
- ⚙️ **Consistency:** Unified templates & options across both environments.
- ⚡ **Lightweight & fast** with minimal dependencies, designed to be fast and easy to implement.

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

### Requirements

- **Ruby** 2.5 or higher
- **Rails** 5.0 or higher
- **Asset Pipeline** (Currently supports Asset Pipeline only)

---

## Setup


### 1. Include Assets

The gem provides both JavaScript functionality and CSS styles. Add these to your asset manifests:

In `app/assets/javascripts/application.js`:

```javascript
//= require skeleton_loader
```

In `app/assets/stylesheets/application.css`:

```css
 *= require skeleton_loader
```

### 2. Install Templates

Skeleton Loader comes with a set of predefined templates. Run the following command to install them:

```bash
rails generate skeleton_loader:add_templates
```

This will create skeleton templates in `app/views/skeleton_loader/`. You can customize them to match your application's design.

If you need to restore the original templates at any point:
```bash
rails generate skeleton_loader:reset_templates
```

- After installation, view the templates in `app/views/skeleton_loader/` to see available options
- Customize the templates to match your UI, if needed.
- Use the templates in your views with the `skeleton_loader` helper method

---

## Rails Integration

The gem provides a primary view helper, `skeleton_loader`, which generates a skeleton that is automatically replaced with content once loading completes. You can use it with predefined templates or define your own HTML blocks.

```ruby
skeleton_loader(
  content_id:,         # Required. Target element ID for replacement
  type: "default",     # Optional. Template type, defaults to "default"
  **options,           # Optional. Customize the template
  &block               # Optional. Define custom skeleton HTML (excludes type/options)
)
```

### 1. Pre-defined Templates

Specify `content_id` and, optionally, a template `type` and customization `options`.

```erb
<%= skeleton_loader (content_id: 'content-element', 
  type: "card",
  card_count: 5,
  scale: 1.2,
  animation_type: 'animation-pulse', 
  ) %>
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

---

## JavaScript Integration

The gem also provides a JavaScript API to create skeletons for dynamic content, operating **independently** from Rails views. Both render() and renderCustom() methods return an object with a revealContent() function, which lets you replace the skeleton with your actual content once it's loaded.

### 1. **Using Predefined Templates**

```javascript
skeletonLoader.render({
  contentId:,                  // Required. Target element ID for replacement
  type: "default",            // Optional. Template type, defaults to "default"
  ...options                  // Optional. Customize template
});
```

**Example:**

```javascript
const skeleton = await skeletonLoader.render({
  contentId: 'content-element',
  type: 'product',
  productCount: 12,
  baseWidth: '20rem',
  animationType: 'animation-pulse',
});

// When data is ready
skeleton.revealContent();
```

This generates a skeleton for `content-element` with the "product" template, customized with animation, layout, and styling options.


### 2. **Custom Skeletons with Markup**

```javascript
skeletonLoader.renderCustom({
  contentId:,                // Required. Target element ID
  markup:                    // Required. Custom HTML as a string
});
```
**Example:**

   ```javascript
   const skeleton = await skeletonLoader.renderCustom({
  contentId: 'content-element',
  markup: `                     
       <div class="custom-skeleton">
         <div class="avatar skeleton-circle"></div>
         <div class="text-lines">
           <div class="line skeleton-pulse"></div>
           <div class="line skeleton-pulse"></div>
         </div>
       </div>
     `
});

// When data is ready
skeleton.revealContent();
   ```

This creates a custom skeleton for `content-element` with specified HTML. Once the actual data is loaded, call `skeleton.revealContent()` to reveal the content and hide the skeleton.

---

## Configuration

Skeleton Loader can be customized through an initializer. Create a file `config/initializers/skeleton_loader.rb` in your Rails application:

```ruby
SkeletonLoader.configure do |config|

  # Customize the default values
  config.card_width = 400                # Adjusts base width  
  config.animation_type = "sl-gradient"  # Sets the animation style
  ...

    # Add security settings if needed
    config.additional_allowed_tags = ['custom-element']
  config.additional_allowed_attributes = { 'custom-element' => ['custom-attr'] }
  config.additional_allowed_css_properties = ['custom-property']
end
```

### Available Configuration Options

For an interactive preview of available templates and animations, visit [our GitHub page](https://ersync.github.io/skeleton-loader/).

| Configuration Item | Description | Default |
|--------------------|-------------|---------|
| **General** | | |
| `scale`   | Scale factor for skeleton elements | `1.0` |
| **Profile** | | |
| `profile_width`    | Base width of each profile skeleton | `350` |
| `profile_count`    | Number of profile skeletons | `1` |
| `profile_per_row`  | Number of profiles per row | `1` |
| **Paragraph** | | |
| `paragraph_width`  | Base width of paragraph skeleton | `900` |
| `line_count`       | Number of lines in paragraph | `4` |
| **Gallery** | | |
| `image_width`      | Base width of each each image skeleton | `300` |
| `image_count`      | Number of images | `3` |
| `image_per_row`    | Number of images per row | `3` |
| **Card** | | |
| `card_width`       | Base width of each each card skeletons | `200` |
| `card_count`       | Number of cards | `3` |
| `card_per_row`     | Number of cards per row | `3` |
| **Product** | | |
| `product_width`    | Base width of each each product skeleton | `320` |
| `product_count`    | Number of products | `3` |
| `product_per_row`  | Number of products per row | `3` |
| **Animation** | | |
| `animation_type`   | Animation style | `"sl-gradient"` |
| **Security (Optional)** | | |
| `additional_allowed_tags` | Additional HTML tags | `[]` |
| `additional_allowed_attributes` | Additional HTML attributes | `{}` |
| `additional_allowed_css_properties` | Additional CSS properties | `[]` |



### HTML Sanitization

Skeleton Loader includes built-in HTML sanitization to ensure secure rendering of skeleton templates. By default, it allows only the necessary HTML elements and CSS properties required for skeleton loading animations while protecting against XSS (Cross-Site Scripting) attacks.

The sanitizer uses Rails' built-in `SafeListSanitizer` as its foundation. If your templates require additional HTML elements or CSS properties, you can extend the default sanitization rules using the security configuration options shown above.

---

## Code Quality

Skeleton Loader maintains code quality through:

- **RSpec**: Comprehensive tests covering core functionality.
- **CircleCI**: Continuous integration ensures all new changes meet quality standards.
- **Rubocop**: Consistent linting aligns code with Ruby community conventions.

---

## To-Do

Here are some features I'd like to add when I have time:

- **Additional templates and animations**: Add new templates & animation types for more variety
- **Support for Vite, Importmaps, Webpack**: Extend compatibility beyond Rails Asset Pipeline
- **Turbo & Stimulus Support**: Add Rails Turbo/Stimulus support for dynamic updates.

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
