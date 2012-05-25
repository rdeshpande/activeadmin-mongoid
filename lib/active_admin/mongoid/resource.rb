require 'active_admin'
require 'inherited_resources'

ActiveAdmin::Resource # autoload
class ActiveAdmin::Resource
  def resource_table_name
    if resource.ancestors.include?(ActiveRecord::Base)
      resource.table_name
    else
      resource.collection_name
    end
  end

  # Disable filters
  def add_default_sidebar_sections
  end
end

ActiveAdmin::ResourceController # autoload
class ActiveAdmin::ResourceController
  # Use #desc and #asc for sorting.
  def sort_order(chain)
    if active_admin_config.resource_class.ancestors.include?(ActiveRecord::Base)
      super
    else
      params[:order] ||= active_admin_config.sort_order
      table_name = active_admin_config.resource_table_name
      if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        chain.send($2, $1)
      else
        chain # just return the chain
      end
    end
  end

  # Disable filters
  def search(chain)
    chain
  end
end
