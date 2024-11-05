# frozen_string_literal: true

SkeletonLoader::Engine.routes.draw do
  get "templates", to: "skeleton_loader#show"
end
