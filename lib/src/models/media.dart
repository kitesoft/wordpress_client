class Media {
  /// The date the object was published, in the site's timezone.
  DateTime date;

  /// The date the object was published, as GMT.
  DateTime dateGMT;

  /// The globally unique identifier for the object.
  Map guid;

  /// Unique identifier for the object.
  int id;

  /// URL to the object.
  String link;

  /// The date the object was last modified, in the site's timezone.
  DateTime modified;

  /// The date the object was last modified, as GMT.
  DateTime modifiedGMT;

  /// An alphanumeric identifier for the object unique to its type.
  String slug;

  /// A named status for the object.
  ///
  /// One of: publish, future, draft, pending, private
  String status;

  /// Type of Post for the object.
  String type;

  /// The title for the object.
  Map title;

  /// The ID for the author of the object.
  int author;

  /// Whether or not comments are open on the object.
  ///
  /// One of: open, closed
  String commentStatus;

  /// Whether or not the object can be pinged.
  ///
  /// One of: open, closed
  String pingStatus;

  /// Meta fields.
  dynamic meta;

  /// The theme file to use to display the object.
  String template;

  /// Alternative text to display when attachment is not displayed.
  String altText;

  /// The attachment caption.
  Map caption;

  /// The attachment description.
  Map description;

  /// Attachment type.
  ///
  /// One of: image, file
  String mediaType;

  /// The attachment MIME type.
  String mimeType;

  /// Details about the media file, specific to its type.
  Map mediaDetails;

  /// The ID for the associated post of the attachment.
  int post;

  /// URL to the original attachment file.
  String sourceURL;

  Media.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    date = map["date"] != null
        ? DateTime.parse(map["date"])
        : null;
    dateGMT = map["date_gmt"] != null
        ? DateTime.parse(map["date_gmt"])
        : null;
    guid = map['guid'];
    id = map['id'];
    link = map['link'];
    modified = map["modified"] != null
        ? DateTime.parse(map["modified"])
        : null;
    modifiedGMT = map["modified_gmt"] != null
        ? DateTime.parse(map["modified_gmt"])
        : null;
    slug = map['slug'];
    status = map['status'];
    type = map['type'];
    title = map['title'];
    author = map['author'];
    commentStatus = map['comment_status'];
    pingStatus = map['ping_status'];
    meta = map['meta'];
    template = map['template'];
    altText = map['alt_text'];
    caption = map['caption'];
    description = map['description'];
    mediaType = map['media_type'];
    mimeType = map['mime_type'];
    mediaDetails = map['media_details'];
    post = map['post'];
    sourceURL = map['source_url'];
  }

  Map<String, dynamic> toMap() => {
    'date': date?.toIso8601String(),
    'date_gmt': dateGMT?.toIso8601String(),
    'guid': guid,
    'id': id,
    'link': link,
    'modified': modified?.toIso8601String(),
    'modified_gmt': modifiedGMT?.toIso8601String(),
    'slug': slug,
    'status': status,
    'type': type,
    'title': title,
    'author': author,
    'comment_status': commentStatus,
    'ping_status': pingStatus,
    'meta': meta,
    'template': template,
    'alt_text': altText,
    'caption': caption,
    'description': description,
    'media_type': mediaType,
    'mime_type': mimeType,
    'media_details': mediaDetails,
    'post': post,
    'source_url': sourceURL
  };

  toString() => "Media => " + toMap().toString();
}

