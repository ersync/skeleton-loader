export default class ClientSkeletonLoader {
  static loadingStates = new Map();
  static activeSkeletons = new Map();

  constructor() {
    this.defaultDisplayStyles = {};
    this.skeletonClass = 'skeleton-loader--client';
    this.contentRefAttr = 'data-content-id';
    this.apiEndpoint = '/skeleton_loader/templates';
  }

  /**
   * Creates or retrieves a skeleton instance for a content element
   */
  getSkeletonInstance(contentId) {
    if (!ClientSkeletonLoader.activeSkeletons.has(contentId)) {
      ClientSkeletonLoader.activeSkeletons.set(contentId, this.createSkeletonInstance(contentId));
    }
    return ClientSkeletonLoader.activeSkeletons.get(contentId);
  }

  /**
   * Creates a new skeleton instance
   */
  createSkeletonInstance(contentId) {
    return {
      isLoading: () => ClientSkeletonLoader.loadingStates.get(contentId) || false,
      reveal: () => {
        const skeletonElement = document.querySelector(`[${this.contentRefAttr}="${contentId}"]`);
        const contentElement = document.getElementById(contentId);
        if (skeletonElement && contentElement) {
          this.revealContent(skeletonElement, contentElement);
        }
      }
    };
  }

  /**
   * Main render method that handles predefined skeletons
   */
  async render({ contentId, type = 'default', ...options } = {}) {
    return this.processRender({
      contentId,
      mode: 'predefined',
      type,
      ...options
    });
  }

  /**
   * Custom render method for user-provided markup
   */
  async renderCustom({ contentId, markup } = {}) {
    if (!markup) return this.logError('Custom markup is required');

    return this.processRender({
      contentId,
      mode: 'custom',
      markup
    });
  }

  /**
   * Core rendering logic shared between render methods
   */
  async processRender(params) {
    const { contentId } = params;
    if (!contentId) return this.logError('contentId is required');

    const skeleton = this.getSkeletonInstance(contentId);
    if (skeleton.isLoading()) {
      console.warn(`Skeleton loading already in progress for ${contentId}`);
      return skeleton;
    }

    try {
      const content = await this.initializeLoading(contentId);
      if (!content) return skeleton;

      const skeletonElement = await this.createSkeletonElement(params);
      if (skeletonElement) this.showSkeleton(skeletonElement, content);

      return skeleton;
    } catch (error) {
      console.error('[SkeletonLoader] Render failed:', error);
      return skeleton;
    }
  }

  /**
   * Initialize loading state and prepare content
   */
  async initializeLoading(contentId) {
    ClientSkeletonLoader.loadingStates.set(contentId, true);
    return this.hideContent(contentId);
  }

  /**
   * Hides the content and stores its original display style
   */
  hideContent(contentId) {
    const content = document.getElementById(contentId);
    if (!content) {
      console.error(`Content not found: #${contentId}`);
      return null;
    }
    const displayStyle = getComputedStyle(content).display;

    if (displayStyle !== 'none') {
      this.defaultDisplayStyles[contentId] = displayStyle;
    }
    content.style.display = 'none';
    return content;
  }

  /**
   * Reveals the content and cleans up the skeleton
   */
  revealContent(skeleton, content) {
    const contentId = content.id;
    if (!ClientSkeletonLoader.loadingStates.get(contentId)) {
      return;
    }

    skeleton.remove();
    content.style.display = this.defaultDisplayStyles[contentId];
    ClientSkeletonLoader.loadingStates.set(contentId, false);
  }

  /**
   * Displays the skeleton by inserting it before the hidden content
   */
  showSkeleton(skeleton, content) {
    this.clearPreviousSkeleton(content.id);
    skeleton.setAttribute(this.contentRefAttr, content.id);
    skeleton.style.display = 'block';
    content.parentNode.insertBefore(skeleton, content);
  }

  /**
   * Removes any existing skeleton associated with the content ID
   */
  clearPreviousSkeleton(contentId) {
    const existingSkeletons = document.querySelectorAll(`[${this.contentRefAttr}="${contentId}"]`);
    existingSkeletons.forEach(skeleton => skeleton.remove());
  }

  /**
   * Creates a skeleton element by fetching the template
   */
  async createSkeletonElement({ contentId, mode, markup = null, type, ...options }) {
    const params = this.buildParams({ contentId, mode, markup, type, ...options });
    try {
      const template = await this.fetchTemplate(params);
      return this.parseTemplateToElement(template, contentId);
    } catch (error) {
      console.error('Error creating skeleton:', error);
      return null;
    }
  }

  /**
   * Fetches the skeleton template from the server
   */
  async fetchTemplate(params) {
    const response = await fetch(`${this.apiEndpoint}?${params.toString()}`, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch skeleton template');
    }

    return response.text();
  }

  /**
   * Converts a template string into a DOM element
   */
  parseTemplateToElement(template, contentId) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(template, 'text/html');
    const skeletonElement = doc.body.firstElementChild;

    if (!skeletonElement) {
      console.error(`Invalid skeleton template for contentId: ${contentId}`);
      return null;
    }
    return skeletonElement;
  }

  /**
   * Builds query parameters for fetching the skeleton template
   */
  buildParams({ contentId, mode, markup, type, ...options }) {
    const params = new URLSearchParams({
      content_id: contentId,
      mode,
      type: type || 'default',
      ...this.formatOptions(options)
    });

    if (markup) params.set('markup', markup);
    return params;
  }

  /**
   * Format options to snake_case for Rails
   */
  formatOptions(options) {
    return Object.fromEntries(
      Object.entries(options).map(([key, value]) => [
        this.toSnakeCase(key),
        value
      ])
    );
  }

  /**
   * Convert camelCase to snake_case
   */
  toSnakeCase(str) {
    return str.replace(/([A-Z])/g, "_$1").toLowerCase();
  }

  /**
   * Logs an error message and returns null
   */
  logError(message) {
    console.error(`[SkeletonLoader] ${message}`);
    return null;
  }
}
