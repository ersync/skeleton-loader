export class ServerSkeletonLoader {
  constructor() {
    this.SKELETON_CLASS = 'skeleton-loader--server';
    this.CONTENT_ID_ATTR = 'data-content-id';
    this.contentsDisplayStyles = {};
  }

  // Instead of class fields, move static properties inside the class
  static get SKELETON_CLASS() {
    return 'skeleton-loader--server';
  }

  static get CONTENT_ID_ATTR() {
    return 'data-content-id';
  }

  // ============= PUBLIC API =============

  // Start the loader and initialize event listeners
  start() {
    this.setupInitialLoading();
    this.setupContentsSwap();
    return this;
  }

  // ============= CORE PROCESSING =============

  // Setup initial loading states for skeletons on DOM load
  setupInitialLoading() {
    document.addEventListener('DOMContentLoaded', () => {
      this.captureContentsDisplayStyles();
      this.hideContents();
      this.showSkeletons();
    });
  }

  // Swap skeletons with content on full page load
  setupContentsSwap() {
    window.addEventListener('load', async() => await this.revealContent());
  }

  // ============= CONTENT MANAGEMENT =============

  // Store the original display styles of content elements for later restoration
  captureContentsDisplayStyles() {
    const skeletons = document.querySelectorAll(`.${ServerSkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(ServerSkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        const originalDisplay = getComputedStyle(content).display || 'block';
        this.contentsDisplayStyles[contentId] = originalDisplay;
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }

  // Show skeleton loading elements by setting their display property
  showSkeletons() {
    const skeletons = document.querySelectorAll(`.${ServerSkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'block';
    });
  }

  // Reveal content by swapping skeletons with actual content elements
  async revealContent() {
    this.hideSkeletons();
    this.showContents();
  }

  // Hide skeleton loading elements once content is ready to be shown
  hideSkeletons() {
    const skeletons = document.querySelectorAll(`.${ServerSkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'none';
    });
  }

  // Display actual content elements by restoring their original display styles
  showContents() {
    const skeletons = document.querySelectorAll(`.${ServerSkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(ServerSkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        const originalDisplay = this.contentsDisplayStyles[contentId] || 'block';
        content.style.display = originalDisplay;
        content.style.visibility = 'visible'; // Ensure content is visible
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }

  // Hide content elements initially to be replaced with skeleton loaders
  hideContents() {
    const skeletons = document.querySelectorAll(`.${ServerSkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(ServerSkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        content.style.display = 'none';
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }
}
