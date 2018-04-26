module ApplicationHelper
    
    
  def datepicker_input form, field
    content_tag :div, :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true'} do
      form.text_field field, class: 'form-control', placeholder: 'None'
    end
  end
    

    
end
