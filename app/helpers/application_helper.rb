module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = "")
    base_title = "E-learning platform"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Pluralize without count.
  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end
end
