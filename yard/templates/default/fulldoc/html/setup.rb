def javascripts_full_list
  super + ['js/nolink.js']
end

def class_list(root = Registry.root, tree = TreeContext.new)
  out = ''

  # internal classes
  out << "<li class='#{tree.classes.join(' ')} nolink'>"
  out << "<div class='item' style='padding-left:#{tree.indent}'>"
  out << "<a class='toggle'></a> Internal Classes"
  out << '</div><ul>'

  children = Registry.at('Humidifier').children.reject { |c| c.has_tag?(:aws) }
  tree.nest do
    out << class_list_children(children.sort_by(&:name), tree: tree)
  end
  out << '</ul></li>'

  # AWS classes
  out << "<li class='#{tree.classes.join(' ')} nolink'>"
  out << "<div class='item' style='padding-left:#{tree.indent}'>"
  out << "<a class='toggle'></a> AWS Resources"
  out << '</div><ul>'

  children = Registry.at('Humidifier').children.select { |c| c.has_tag?(:aws) }
  tree.nest do
    out << class_list_children(children.sort_by(&:name), tree: tree)
  end
  out << '</ul></li>'

  out
end

def class_list_children(children, options)
  tree = options[:tree]
  out = ''

  children.compact.sort_by(&:path).each do |child|
    next if !child.is_a?(CodeObjects::NamespaceObject)

    name = child.namespace.is_a?(CodeObjects::Proxy) ? child.path : child.name
    grand_children = run_verifier(child.children)
    has_children = grand_children.any? {|o| o.is_a?(CodeObjects::NamespaceObject) }

    out << "<li id='object_#{child.path}' class='#{tree.classes.join(' ')}'>"
    out << "<div class='item' style='padding-left:#{tree.indent}'>"
    out << "<a class='toggle'></a> " if has_children
    out << linkify(child, name)
    out << " &lt; #{child.superclass.name}" if child.is_a?(CodeObjects::ClassObject) && child.superclass
    out << "<small class='search_info'>#{child.namespace.title}</small>"
    out << "</div>"

    if has_children
      tree.nest do
        out << "<ul>#{class_list_children(grand_children, options)}</ul>"
      end
    end
    out << "</li>"
  end

  out
end
