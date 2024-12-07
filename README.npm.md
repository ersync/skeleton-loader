
# Skeleton Loader JS

![npm version](https://img.shields.io/npm/v/@ersync/skeleton-loader)
![Bundle Size](https://img.shields.io/bundlephobia/min/@ersync/skeleton-loader)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

⚠️ **Important:** This is not a standalone package. It's the JavaScript component of the [Skeleton Loader Rails gem](https://github.com/ersync/skeleton-loader) and requires the gem to be installed and configured in your Rails application.

This package is part of the Skeleton Loader Rails gem ecosystem, providing the JavaScript functionality for client-side skeleton loading states. While this package contains the frontend implementation, it relies on server-side template rendering and configuration from the Rails gem.

For standalone JavaScript skeleton loading, please consider using alternative libraries. This package is specifically designed to work in conjunction with the Rails gem.

![Demo Image](https://github.com/user-attachments/assets/f6f91f55-1bfa-42eb-9e8c-41606eb8afd5)

## Features

- 🎨 **Pre-built Templates**: Ready-to-use loading states for common UI patterns
- ⚡ **Lightweight**: Zero dependencies, minimal bundle size
- 🔧 **Customizable**: Flexible API for custom templates and animations
- 🎭 **Multiple Animations**: Various animation styles to match your design

## Installation

```bash
# Using npm
npm install @ersync/skeleton-loader

# Using yarn
yarn add @ersync/skeleton-loader
```

## Basic Usage

```javascript
import SkeletonLoader from '@ersync/skeleton-loader';

const skeleton = new SkeletonLoader();

// Using pre-built templates
const loader = skeleton.render({
  contentId: 'profile',
  type: 'profile',
  count: 1
});

// Remove skeleton when content is ready
loader.reveal();
```

<details>
<summary><strong>Complete Example</strong></summary>

```javascript
async function loadUserProfile(userId) {
  const loader = skeleton.render({
    contentId: 'profile',
    type: 'profile',
    scale: 1.2
  });

  try {
    const response = await fetch(`/api/users/${userId}`);
    const userData = await response.json();
    
    document.getElementById('profile').innerHTML = createProfile(userData);
    loader.reveal();
  } catch (error) {
    console.error('Failed to load profile:', error);
    loader.reveal(); // Always cleanup
  }
}
```
</details>

## API Reference

### SkeletonLoader Methods

#### `render(options)`
Creates a skeleton using pre-built templates.

```javascript
const loader = skeleton.render({
  contentId,        // Required: Target element ID
  type,            // Optional: Template type (default: 'default')
  count,           // Optional: Number of items
  width,           // Optional: Base width in pixels
  scale,           // Optional: Size multiplier
  animationType    // Optional: Animation style
});
```

#### `renderCustom(options)`
Creates a skeleton with custom HTML.

```javascript
const loader = skeleton.renderCustom({
  contentId,        // Required: Target element ID
  markup           // Required: Custom HTML string
});
```

### Available Templates

| Template | Description | Default Options |
|----------|-------------|-----------------|
| `profile` | User profile card | `width: 320, count: 1` |
| `card` | Content card | `width: 200, count: 3` |
| `gallery` | Image grid | `width: 320, count: 3` |
| `paragraph` | Text block | `width: 900, count: 1` |

### Animation Types

- `sl-gradient`: Smooth gradient movement (default)
- `sl-shine`: Shimmer effect
- `sl-pulse`: Fade in/out
- `sl-flow`: Continuous flow
- `sl-neon`: Subtle glow
- `sl-breathing`: Gentle scaling

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## TypeScript Support

Types are included in the package:

```typescript
import { SkeletonLoader, SkeletonOptions } from '@ersync/skeleton-loader';

const options: SkeletonOptions = {
  contentId: 'profile',
  type: 'profile'
};
```

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Related

- [Ruby Gem Version](https://github.com/ersync/skeleton-loader) - Main package and documentation
- [Documentation](https://ersync.github.io/skeleton-loader) - Full documentation and examples
```
