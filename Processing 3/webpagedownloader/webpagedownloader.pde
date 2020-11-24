import java.util.List;
import java.net.URI;
import java.net.URL;
import java.net.URISyntaxException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.file.FileSystems;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import org.jsoup.select.Selector;
import org.jsoup.Jsoup;

try {
  URI uri = new URI("https://wizardoflegend.gamepedia.com/Arcana");
  URL url = uri.toURL();
  
  Path outputPath = Paths.get("C:\\Users\\Becky\\Documents\\Output\\result.txt");
  
  InputStream stream = url.openStream();
  
  StringBuilder html_builder = new StringBuilder(stream.available());
  int nextByte = 0;
  
  while(nextByte != -1) {
    nextByte = stream.read();
    html_builder.append((char) nextByte);
    //print((char) nextByte);
  }
  
  stream.close();
  
  String html = html_builder.toString();
  
  //println(html);
  
  Document document = Jsoup.parse(html);
  Elements elements = document.select("tr[style=text-align:left] > td:lt(4):gt(0)");
  List<String> text = elements.eachText();
  
  List<String> Names = new ArrayList<String>(text.size() / 3);
  List<String> Descriptions = new ArrayList<String>(text.size() / 3);
  List<String> Types = new ArrayList<String>(text.size() / 3);
  
  for(int i = 0; i < text.size(); i++) {
    switch(i % 3) {
      case 0:
        Names.add(text.get(i));
        break;
      case 1:
        Descriptions.add(text.get(i));
        break;
      case 2:
        Types.add(text.get(i));
        break;
    }
    //println(String.format("Mod 3: %d | Item: %s", i % 3, text.get(i)));
  }
  
  final String luaPath = "C:\\Users\\becky\\Documents\\Output\\Scripts\\Arcana\\%s\\%s.lua";
  final String xmlPath = "C:\\Users\\becky\\Documents\\Output\\Entities\\%s\\Custom_cards\\%s.xml";
  
  final String luaContent = "table.insert( actions,"
                      + "\r\n\t{"
                      + "\r\n\t\tid                  = \"WOL_%s\","
                      + "\r\n\t\tname                = \"%s\","
                      + "\r\n\t\tdescription         = \"%s\","
                      + "\r\n\t\tsprite              = \"files/Sprites/%s/ui_icons/%s.png\","
                      + "\r\n\t\tsprite_unidentified = \"files/Sprites/%s/ui_icons/%s.png\","
                      + "\r\n\t\ttype                = ACTION_TYPE_PROJECTILE,"
                      + "\r\n\t\tspawn_level         = \"1,2,3,4,5,6\","
                      + "\r\n\t\tspawn_probability   = \"1,1,1,1,1,1\","
                      + "\r\n\t\tprice               = 80,"
                      + "\r\n\t\tmana                = 10,"
                      + "\r\n\t\t-- max_uses = 8,"
                      + "\r\n\t\tcustom_xml_file     = \"files/Entities/%s/Custom_cards/%s.xml\","
                      + "\r\n\t\taction              = function()"
                      + "\r\n\t\t\tadd_projectile(\"files/Entities/Projectiles/test.xml\")"
                      + "\r\n\t\t\tc.fire_rate_wait = c.fire_rate_wait + 5"
                      + "\r\n\t\t\tc.spread_degrees = c.spread_degrees - 5.0"
                      + "\r\n\t\tend,"
                      + "\r\n\t} )";
  
  final String xmlContent = "<Entity _tags=\"wol_%s\">"
                      + "\r\n\t<Base file=\"data/entities/base_custom_card.xml\" >"
                      + "\r\n\t\t<SpriteComponent"
                      + "\r\n\t\t\timage_file=\"files/Sprites/%s/ui_icons/%s.png\" >"
                      + "\r\n\t\t</SpriteComponent>"
                      + "\r\n\t\t"
                      + "\r\n\t\t<ItemActionComponent"
                      + "\r\n\t\t\t_tags=\"enabled_in_world\""
                      + "\r\n\t\t\taction_id=\"WOL_%s\" >"
                      + "\r\n\t\t</ItemActionComponent>"
                      + "\r\n\t</Base>"
                      + "\r\n</Entity>";
  
  for(int i = 0; i < text.size() / 3; i++) {
    String name = Names.get(i);
    String description = Descriptions.get(i);
    String type = Types.get(i);
    
    String nameid = (name.equals("Rock n' Roll")) ? "Rock n Roll" : name;
    
    String nameNoSpaces = nameid.replaceAll("\\s", "");
    
    Files.write(Paths.get(String.format(luaPath, type, nameNoSpaces)),
                String.format(luaContent, nameNoSpaces.toUpperCase(), name, description,
                              type, nameNoSpaces.toLowerCase(),
                              type, nameNoSpaces.toLowerCase(),
                              type, nameNoSpaces).getBytes());
    
    Files.write(Paths.get(String.format(xmlPath, type, nameNoSpaces)),
                String.format(xmlContent, nameNoSpaces.toLowerCase(),
                              type, nameNoSpaces.toLowerCase(),
                              nameNoSpaces.toUpperCase()).getBytes());
  }
  
  //Files.copy(stream, outputPath, StandardCopyOption.REPLACE_EXISTING);
  //Files.write(outputPath, html.getBytes());
}
catch(URISyntaxException e) {
  e.printStackTrace();
}
catch(MalformedURLException e) {
  e.printStackTrace();
}
catch(IOException e) {
  e.printStackTrace();
}
finally {
  exit();
}