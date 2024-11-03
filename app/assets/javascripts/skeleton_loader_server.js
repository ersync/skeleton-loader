class SkeletonLoader {
  static SKELETON_CLASS = 'skeleton-loader';
  static CONTENT_ID_ATTR = 'data-content-id';

  #contentsDisplayStyles = new Map();

  // Start the loader and initialize event listeners
  start() {
    this.#setupInitialLoading();
    this.#setupContentsSwap();
    return this;
  }

  // Private: Setup initial state on DOM load
  #setupInitialLoading() {
    document.addEventListener('DOMContentLoaded', () => {
      this.#captureContentsDisplayStyles();
      this.#hideContents()
      this.#showSkeletons();
    });
  }

  // Private: Handle contents swap on full page load
  #setupContentsSwap() {
    window.addEventListener('load', () => this.#revealContent());
  }

  // Private: Store original display styles of contents elements
  #captureContentsDisplayStyles() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        const originalDisplay = getComputedStyle(content).display || 'block';
        this.#contentsDisplayStyles.set(contentId, originalDisplay);
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }

  // Private: Display skeleton loading states
  #showSkeletons() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'block'; // Show skeletons
    });
  }

  // Private: Swap skeletons with actual contents
  #revealContent() {
    this.#hideSkeletons();
    this.#showContents();
  }

  // Private: Hide skeleton elements
  #hideSkeletons() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      skeleton.style.display = 'none'; // Hide skeletons
    });
  }

  // Private: Show actual contents elements
  #showContents() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        const originalDisplay = this.#contentsDisplayStyles.get(contentId) || 'block';
        content.style.display = originalDisplay; // Restore original display style
        content.style.visibility = 'visible'; // Ensure content is visible
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }

  // Private: Hide actual contents elements

  #hideContents() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.SKELETON_CLASS}`);
    skeletons.forEach(skeleton => {
      const contentId = skeleton.getAttribute(SkeletonLoader.CONTENT_ID_ATTR);
      const content = document.getElementById(contentId);

      if (content) {
        content.style.display = 'none'; // Restore original display style
      } else {
        console.warn(`Content element with id "${contentId}" not found`);
      }
    });
  }



}

new SkeletonLoader().start();
