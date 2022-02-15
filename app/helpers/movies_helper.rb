module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def sort?(b)
    return @order == b
  end

  def hilite_header(b)
    return b ? "hilite bg-warning" : ""
  end
end
