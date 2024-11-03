class SkeletonLoaderClient {
  static API_ENDPOINT = '/skeleton_loader/templates';
  static CONTENT_NOT_FOUND_ERROR = 'Content element not found';
  static REQUIRED_PARAMS_ERROR = 'Type and contentId are required parameters';

  #contentsDisplayStyles = new Map();

  // Public API
  async render(type, { contentId, ...options } = {}) {
    if (!this.#validateParams(type, contentId)) return null;

    try {
      const contentElement = this.#initializeContent(contentId);
      const skeletonElement = await this.#createSkeleton(type, contentId, options);
      skeletonElement.style.display = "block"

      this.#insertSkeleton(skeletonElement, contentElement);
      return this.#createControlAPI(skeletonElement, contentElement);
    } catch (error) {
      console.error('Skeleton loader error:', error);
      return null;
    }
  }

  // Private: reveal Content
  revealContent(skeleton, content) {
    skeleton.style.display = 'none';
    const originalDisplay = this.#contentsDisplayStyles.get(content.id) || 'block';
    content.style.display = originalDisplay;
  }

  // Private: Validation methods
  #validateParams(type, contentId) {
    if (!type || !contentId) {
      console.error(SkeletonLoaderClient.REQUIRED_PARAMS_ERROR);
      return false;
    }
    return true;
  }

  // Private: Content handling
  #initializeContent(contentId) {
    const content = document.getElementById(contentId);
    if (!content) {
      throw new Error(`${SkeletonLoaderClient.CONTENT_NOT_FOUND_ERROR}: #${contentId}`);
    }

    this.#captureContentStyle(content);
    content.style.display = 'none';
    return content;
  }

  #captureContentStyle(content) {
    const originalDisplay = getComputedStyle(content).display || 'block';
    this.#contentsDisplayStyles.set(content.id, originalDisplay);
  }

  // Private: Skeleton creation and insertion
  async #createSkeleton(type, contentId, options) {
    const params = this.#buildRequestParams(type, contentId, options);
    const template = await this.#fetchTemplate(params);
    return this.#createElementFromTemplate(template);
  }

  #buildRequestParams(type, contentId, options) {
    const params = new URLSearchParams({
      type,
      content_id: contentId,
      ...this.#formatOptions(options)
    });
    return params;
  }

  #formatOptions(options) {
    return Object.fromEntries(
      Object.entries(options).map(([key, value]) => [
        this.#toSnakeCase(key),
        value
      ])
    );
  }

  #toSnakeCase(str) {
    return str.replace(/([A-Z])/g, "_$1").toLowerCase();
  }

  // Private: API interactions
  async #fetchTemplate(params) {
    const response = await fetch(
      `${SkeletonLoaderClient.API_ENDPOINT}?${params.toString()}`,
      {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      }
    );

    if (!response.ok) {
      throw new Error('Failed to fetch skeleton template');
    }
    return response.text();
  }

  // Private: DOM manipulation
  #createElementFromTemplate(template) {
    const container = document.createElement('div');
    container.innerHTML = template;
    return container.firstElementChild;
  }

  #insertSkeleton(skeleton, content) {
    content.parentNode.insertBefore(skeleton, content);
  }

  // Private: Control API creation
  #createControlAPI(skeleton, content) {
    return {
      revealContent: () => this.revealContent(skeleton, content)
    };
  }
}

const skeletonLoader = new SkeletonLoaderClient();
