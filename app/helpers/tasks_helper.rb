module TasksHelper
  def sortable(column, title)
    case params[:sort]
    when "#{column}_asc"
      symbol = "▲"
    when "#{column}_desc"
      symbol = "▼"
    else
      symbol = ""
    end

    if params[:sort] == "#{column}_asc"
      way_of_sort = "#{column}_desc"
    else
      way_of_sort = "#{column}_asc"
    end

    link_to title+symbol, { :sort => way_of_sort}
  end
end
