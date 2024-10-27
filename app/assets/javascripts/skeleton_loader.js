(function () {
  window.SkeletonLoader = window.SkeletonLoader || {
    defaultClass: 'skeleton-loader',
    defaultDisplayType: 'block'
  }

  function initializeSkeletonLoaders() {
    const skeletons = document.querySelectorAll(`.${SkeletonLoader.defaultClass}`)

    skeletons.forEach(function (skeletonElement) {
      const targetId = skeletonElement.getAttribute('data-target-id')
      if (!targetId) return

      const targetDisplayType = skeletonElement.getAttribute('data-target-display-type') || SkeletonLoader.defaultDisplayType
      const contentElement = document.getElementById(targetId)

      if (contentElement) {
        hideSkeletonAndShowContent(skeletonElement, contentElement, targetDisplayType)
      }
    })
  }

  function hideSkeletonAndShowContent(skeleton, content, targetDisplayType) {
    skeleton.style.display = 'none'
    content.style.display = targetDisplayType
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeSkeletonLoaders)
  } else {
    initializeSkeletonLoaders()
  }
})()
