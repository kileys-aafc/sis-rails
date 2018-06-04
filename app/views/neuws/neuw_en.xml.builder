atom_feed do |feed|
  feed.title("Cansis")
  feed.subtitle("What's New")
  @neuws.each do |neuw|
    feed.entry(neuw, :url => neuw.url_en) do |entry|
      entry.title(neuw.title_en)
      entry.summary(neuw.summary_en)
    end
  end
end
