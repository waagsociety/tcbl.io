xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
    xml.channel do
        xml.title "TCBL labs projects feed"
        xml.description "Projects by TCBL labs"
        xml.link root_url

        @projects.each do |project|
            xml.item do 
                xml.title project.title
                xml.descriptio project.description
                xml.pubDate  project.updated_at.to_s(:rfc822)
                xml.link project_url(project)
                xml.guid project_url(project)
            end
        end
    end
end
