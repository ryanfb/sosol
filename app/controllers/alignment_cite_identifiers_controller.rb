# Controller for Treebank Cite Identifiers
class AlignmentCiteIdentifiersController < IdentifiersController 
  
  before_filter :authorize
  before_filter :ownership_guard, :only => [:update, :updatexml]


  def update_title
    find_identifier
    # TODO if we start keeping the title in the contents of the file
    # then we need to update the xml too but for now this is only a field
    # on the model in the mysql db
    if @identifier.update_attributes(params[:alignment_cite_identifier])
      flash[:notice] = 'Title was successfully updated.'
    else
      flash[:error] = 'Unable to update title'
    end
    redirect_to :action =>"edit",:id=>params[:id]
  end

  def edit_title
    find_identifier
  end

  # responds to a request to create a new file
  # @param
  def create
    
  end
  
  def create_from_annotation
    @publication = Publication.find(params[:publication_id].to_s)
    
    annotation_doc = @identifier = OACIdentifier.find(params[:a_id])
    annotation = annotation_doc.get_annotation(params[:annotation_uri])     
    # for now only support a single annotation target
    targets = OacHelper::get_targets(annotation)
    bodies = OacHelper::get_bodies(annotation)
    if (targets.size != 1 || bodies.size != 1)
      flash[:error] = "Unable to create alignment item. Need a single uri for each sentence but got #{targets.inspect} and #{bodies.inspect}"
      redirect_to dashboard_url
      return
    end 

    init_value = []
    init_value << CGI::unescape(targets[0])
    init_value << CGI::unescape(bodies[0])
    @identifier = AlignmentCiteIdentifier.new_from_template(@publication,AlignmentCiteIdentifier::COLLECTION,init_value)
    redirect_to polymorphic_path([@publication, @identifier],:action => :edit)
  end
  
  def edit
    find_identifier
    @identifier[:list] = @identifier.edit(parameters = params)
  end
  
   def editxml
    find_identifier
    @identifier[:xml_content] = @identifier.xml_content
    @is_editor_view = true
    render :template => 'alignment_cite_identifiers/editxml'
  end
  
  def preview
    find_identifier
    @identifier[:html_preview] = @identifier.preview(parameters = params)
  end
      
  def destroy
    find_identifier 
    name = @identifier.title
    pub = @identifier.publication
    @identifier.destroy
    
    flash[:notice] = name + ' was successfully removed from your publication.'
    redirect_to pub
    return
  end
  
  protected
    def find_identifier
      @identifier = AlignmentCiteIdentifier.find(params[:id].to_s)
    end
  
    def find_publication_and_identifier
      @publication = Publication.find(params[:publication_id].to_s)
      find_identifier
    end
    
     def find_publication
      @publication = Publication.find(params[:publication_id].to_s)
    end  
end
