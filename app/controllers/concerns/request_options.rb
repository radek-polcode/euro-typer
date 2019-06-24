module RequestOptions
  extend ActiveSupport::Concern

  included do 
    before_action :set_options, only: [:index]    
  end

  def set_options
    @options_hash = {}
    return @options_hash unless params[:include].present?
    @options_hash[:include] = [params[:include].to_sym]
    @options_hash
  end
end