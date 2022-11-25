module ApplicationHelper
  def current_firm
    @current_firm ||= Firm.find_by_subdomain!(request.subdomain)
   
  # return @current_firm if defined?(@current_firm)
  # @current_firm = current_user.firm
  end
  def string_for_klass(klass)
    klass.class.to_s.downcase.pluralize
  end
  def all_users
    @all_users ||= current_firm.users.order("name")
  end 
   
  def all_projects
    @all_projects ||= current_user.projects.where(["active = ?", true]).order('name ASC')
  end 
   
  def all_customers
    if current_user.role == "external_user"
      @all_customers = []
    else
      @all_customers ||= current_firm.customers.order("name")
    end
  end
  
  def time_zone_now
    #exchange for Time.now
    Time.zone = current_firm.time_zone
    return Time.now.in_time_zone
  end

	def truncate_string(text, length = 18, truncate_string = '...')
     if text.nil? then return end
     l = length - truncate_string.length
     text.length > length ? text[0...l] + truncate_string : text
	end

	def image(person, css_class)
		if person.avatar_file_name.nil?
			 image_tag("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(person.email)}?default=mm&s=100", :alt => 'Avatar', :class => css_class)
		else
			if css_class == "image32"
				image_tag person.avatar.url(:small), :class => css_class
			elsif css_class == "image100" or css_class == "image64"
				image_tag person.avatar.url(:original), :class => css_class	
			end
		end
	end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("invoices/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  def add_fields_to_table( f, association, lines)
    fields = ""
    lines.each do |l|
    new_object = f.object.send(association).klass.new(description: l.description, quantity: l.quantity, price: l.price, tax: l.tax)
    id = new_object.object_id
    fields << f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
  end
    fields.gsub("\n", "")
  end
  #for PDF
  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end
  
  #for devise
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def prices_to_currency(price, unit)
    number_to_currency price, unit: unit, strip_insignificant_zeros: true
  end
end
