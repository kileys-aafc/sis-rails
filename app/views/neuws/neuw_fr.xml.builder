atom_feed do |feed|
  feed.title("SISCan")
  feed.subtitle("Quoi du neuf?")
  @neuws.each do |neuw|
    feed.entry(neuw, :url => neuw.url_fr) do |entry|
      entry.title(neuw.title_fr)
      entry.summary(neuw.summary_fr)
    end
  end
end
