class SkeletonLoader {
  static SKELETON_CLASS = 'skeleton-loader--static';
  static CONTENT_ID_ATTR = 'data-content-id';

  contentsDisplayStyles = {};

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
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
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
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'block';
    });
  }

  // Reveal content by swapping skeletons with actual content elements
  async revealContent() {
    await new Promise(resolve => setTimeout(resolve, 13000)) // Shorter delay
    this.hideSkeletons();
    this.showContents();
  }

  // Hide skeleton loading elements once content is ready to be shown
  hideSkeletons() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'none';
    });
  }

  // Display actual content elements by restoring their original display styles
  showContents() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
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
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        content.style.display = 'none';
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }
}

// Initialize and start the SkeletonLoader
new SkeletonLoader().start();
