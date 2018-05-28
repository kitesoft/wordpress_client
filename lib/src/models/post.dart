import 'category.dart';

class Post {
  /// The date the object was published, in the site's timezone.
  DateTime date;

  /// The date the object was published, as GMT.
  DateTime date_gmt;

  /// The globally unique identifier for the object.
  dynamic guid;

  /// Unique identifier for the object.
  int id;

  /// URL to the object.
  String link;

  /// The date the object was last modified, in the site's timezone.
  DateTime modified;

  /// The date the object was last modified, as GMT.
  DateTime modified_gmt;

  /// An alphanumeric identifier for the object unique to its type.
  String slug;

  /// A named status for the object.
  ///
  /// One of: publish, future, draft, pending, private
  String status;

  /// Type of Post for the object.
  String type;

  /// A password to protect access to the content and excerpt.
  String password;

  /// The title for the object.
  dynamic title;

  /// The content for the object.
  dynamic content;

  /// The ID for the author of the object
  int author;

  /// The excerpt for the object.
  dynamic excerpt;

  /// The ID of the featured media for the object.
  int featured_media;

  /// Whether or not comments are open on the object
  ///
  /// One of: open, closed
  String comment_status;

  /// Whether or not the object can be pinged.
  ///
  /// One of: open, close
  String ping_status;

  /// The format for the object.
  String format;

  /// Meta fields.
  dynamic meta;

  /// Whether or not the object should be treated as sticky.
  bool sticky;

  /// The theme file to use to display the object.
  String template;

  /// The terms assigned to the object in the category taxonomy.
  List<Category> categories;

  /// The terms assigned to the object in the post_tag taxonomy.
  List tags;

  Post.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    date = map["date"] != null
        ? DateTime.parse(map["date"])
        : null;
    date_gmt = map["date_gmt"] != null
        ? DateTime.parse(map["date_gmt"])
        : null;
    guid = map['guid'];
    id = map['id'];
    link = map['link'];
    modified = map["modified"] != null
        ? DateTime.parse(map["modified"])
        : null;
    modified_gmt = map["modified_gmt"] != null
        ? DateTime.parse(map["modified_gmt"])
        : null;
    slug = map['slug'];
    status = map['status'];
    type = map['type'];
    password = map['password'];
    title = map['title'];
    content = map['content'];
    author = map['author'];
    excerpt = map['excerpt'];
    featured_media = map['featured_media'];
    comment_status = map['comment_status'];
    ping_status = map['ping_status'];
    format = map['format'];
    meta = map['meta'];
    sticky = map['sticky'];
    template = map['template'];
    categories = map['categories'];
    tags = map['tags'];
  }

  Map<String, dynamic> toMap() => {
        'date': date?.toIso8601String(),
        'date_gmt': date_gmt?.toIso8601String(),
        'guid': guid,
        'id': id,
        'link': link,
        'modified': modified?.toIso8601String(),
        'modified_gmt': modified_gmt?.toIso8601String(),
        'slug': slug,
        'status': status,
        'type': type,
        'password': password,
        'title': title,
        'content': content,
        'author': author,
        'excerpt': excerpt,
        'featured_media': featured_media,
        'comment_status': comment_status,
        'ping_status': ping_status,
        'format': format,
        'meta': meta,
        'sticky': sticky,
        'template': template,
        'categories': categories,
        'tags': tags
      };

  toString() => "Post => " + toMap().toString();
}
