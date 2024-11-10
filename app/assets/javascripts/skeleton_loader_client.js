class SkeletonLoaderClient {
  constructor() {
    this.API_ENDPOINT = '/skeleton_loader/templates';
    this.CONTENT_NOT_FOUND_ERROR = 'Content element not found';
    this.REQUIRED_PARAMS_ERROR = 'contentId is a required parameter';

    // Use a plain object instead of private field and Map
    this.contentsDisplayStyles = {};
  }

  // ============= PUBLIC API =============

  render(options = {}) {
    const { contentId, ...otherOptions } = options;
    return this.processSkeletonRequest(contentId, () =>
      this.fetchPredefinedSkeleton(contentId, otherOptions)
    );
  }

  renderCustom(options = {}) {
    const { contentId, markup } = options;

    if (!markup) {
      console.error('markup is required for custom rendering');
      return Promise.resolve(null);
    }

    return this.processSkeletonRequest(contentId, () =>
      this.fetchCustomSkeleton(contentId, markup)
    );
  }

  revealContent(skeleton, content) {
    skeleton.style.display = 'none';
    const originalDisplay = this.contentsDisplayStyles[content.id] || 'block';
    content.style.display = originalDisplay;
  }

  // ============= CORE PROCESSING =============

  processSkeletonRequest(contentId, skeletonFetcher) {
    if (!this.validateContentId(contentId)) return Promise.resolve(null);

    try {
      const contentElement = this.initializeContent(contentId);
      return skeletonFetcher().then(skeletonElement => {
        this.displaySkeleton(skeletonElement, contentElement);
        return this.createControlAPI(skeletonElement, contentElement);
      }).catch(error => {
        console.error('Skeleton loader error:', error);
        return null;
      });
    } catch (error) {
      console.error('Skeleton loader error:', error);
      return Promise.resolve(null);
    }
  }

  // ============= CONTENT MANAGEMENT =============

  initializeContent(contentId) {
    const content = document.getElementById(contentId);
    if (!content) {
      throw new Error(`${this.CONTENT_NOT_FOUND_ERROR}: #${contentId}`);
    }

    this.saveOriginalDisplay(content);
    content.style.display = 'none';
    return content;
  }

  saveOriginalDisplay(content) {
    const originalDisplay = getComputedStyle(content).display || 'block';
    this.contentsDisplayStyles[content.id] = originalDisplay;
  }

  displaySkeleton(skeleton, content) {
    skeleton.style.display = "block";
    content.parentNode.insertBefore(skeleton, content);
  }

  // ============= SKELETON FETCHING =============

  fetchPredefinedSkeleton(contentId, options) {
    const params = this.buildParams(contentId, { ...options, mode: 'predefined' });
    return this.fetchAndCreateSkeleton(params);
  }

  fetchCustomSkeleton(contentId, markup) {
    const params = this.buildParams(contentId, { markup, mode: 'custom' });
    return this.fetchAndCreateSkeleton(params);
  }

  fetchAndCreateSkeleton(params) {
    return this.fetchTemplate(params).then(template => this.createElementFromTemplate(template));
  }

  // ============= HTTP & DOM UTILITIES =============

  fetchTemplate(params) {
    return fetch(`${this.API_ENDPOINT}?${params.toString()}`, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    }).then(response => {
      if (!response.ok) {
        throw new Error('Failed to fetch skeleton markup');
      }
      return response.text();
    });
  }

  createElementFromTemplate(template) {
    const container = document.createElement('div');
    container.innerHTML = template;
    return container.firstElementChild;
  }

  // ============= HELPERS =============

  validateContentId(contentId) {
    if (!contentId) {
      console.log(contentId)
      console.error(this.REQUIRED_PARAMS_ERROR);
      return false;
    }
    return true;
  }

  buildParams(contentId, options) {
    return new URLSearchParams({
      content_id: contentId,
      ...this.formatOptions(options)
    });
  }

  formatOptions(options) {
    const formatted = {};
    for (const key in options) {
      formatted[this.toSnakeCase(key)] = options[key];
    }
    return formatted;
  }

  toSnakeCase(str) {
    return str.replace(/([A-Z])/g, "_$1").toLowerCase();
  }

  createControlAPI(skeleton, content) {
    return {
      revealContent: () => this.revealContent(skeleton, content)
    };
  }
}

// Initialize the SkeletonLoaderClient
const skeletonLoader = new SkeletonLoaderClient();
