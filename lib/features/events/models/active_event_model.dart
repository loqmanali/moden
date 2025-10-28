class ActiveEventResponse {
  const ActiveEventResponse({this.result});

  factory ActiveEventResponse.fromJson(Map<String, dynamic> json) {
    return ActiveEventResponse(
      result: json['result'] is Map<String, dynamic>
          ? EventDetails.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  final EventDetails? result;

  Map<String, dynamic> toJson() {
    return {
      'result': result?.toJson(),
    };
  }
}

class EventDetails {
  const EventDetails({
    required this.id,
    required this.name,
    required this.title,
    required this.isActive,
    required this.isClosed,
    required this.isPublished,
    this.date,
    this.endDate,
    this.startTime,
    this.endTime,
    this.city,
    this.details,
    this.successMsg,
    this.agenda = const [],
    this.applications = const [],
    this.workshops = const [],
    this.requiredFields = const [],
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      isActive: json['isActive'] is bool ? json['isActive'] as bool : false,
      isClosed: json['isClosed'] is bool ? json['isClosed'] as bool : false,
      isPublished:
          json['isPublished'] is bool ? json['isPublished'] as bool : false,
      date: _parseDate(json['date']),
      endDate: _parseDate(json['endDate']),
      startTime: _parseInt(json['startTime']),
      endTime: _parseInt(json['endTime']),
      city: json['city']?.toString(),
      details: json['details']?.toString(),
      successMsg: json['successMsg']?.toString(),
      agenda: _parseList<EventAgendaItem>(
        json['agenda'],
        EventAgendaItem.fromJson,
      ),
      applications: json['applications'] is List
          ? List<dynamic>.from(json['applications'] as List)
          : const [],
      workshops: _parseList<EventWorkshop>(
        json['workshops'],
        EventWorkshop.fromJson,
      ),
      requiredFields: _parseList<EventRequiredField>(
        json['requiredFields'],
        EventRequiredField.fromJson,
      ),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      version: _parseInt(json['__v']),
    );
  }

  final String id;
  final String name;
  final String title;
  final bool isActive;
  final bool isClosed;
  final bool isPublished;
  final DateTime? date;
  final DateTime? endDate;
  final int? startTime;
  final int? endTime;
  final String? city;
  final String? details;
  final String? successMsg;
  final List<EventAgendaItem> agenda;
  final List<dynamic> applications;
  final List<EventWorkshop> workshops;
  final List<EventRequiredField> requiredFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'title': title,
      'isActive': isActive,
      'isClosed': isClosed,
      'isPublished': isPublished,
      'date': date?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'city': city,
      'details': details,
      'successMsg': successMsg,
      'agenda': agenda.map((item) => item.toJson()).toList(),
      'applications': applications,
      'workshops': workshops.map((item) => item.toJson()).toList(),
      'requiredFields': requiredFields.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(mapper)
          .toList(growable: false);
    }
    return const [];
  }
}

class EventAgendaItem {
  const EventAgendaItem({
    required this.title,
    required this.day,
    required this.from,
    required this.to,
    this.presenters = const [],
  });

  factory EventAgendaItem.fromJson(Map<String, dynamic> json) {
    return EventAgendaItem(
      title: json['title']?.toString() ?? '',
      day: EventDetails._parseInt(json['day']) ?? 0,
      from: EventDetails._parseInt(json['from']) ?? 0,
      to: EventDetails._parseInt(json['to']) ?? 0,
      presenters: EventDetails._parseList<EventPresenter>(
        json['presenters'],
        EventPresenter.fromJson,
      ),
    );
  }

  final String title;
  final int day;
  final int from;
  final int to;
  final List<EventPresenter> presenters;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'day': day,
      'from': from,
      'to': to,
      'presenters': presenters.map((item) => item.toJson()).toList(),
    };
  }
}

class EventPresenter {
  const EventPresenter({
    required this.name,
    this.jobDescription,
    this.isOnline,
  });

  factory EventPresenter.fromJson(Map<String, dynamic> json) {
    return EventPresenter(
      name: json['name']?.toString() ?? '',
      jobDescription: json['jobDescription']?.toString(),
      isOnline: json['isOnline'] is bool ? json['isOnline'] as bool : null,
    );
  }

  final String name;
  final String? jobDescription;
  final bool? isOnline;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'jobDescription': jobDescription,
      'isOnline': isOnline,
    };
  }
}

class EventWorkshop {
  const EventWorkshop({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    this.attachments = const [],
    this.date,
    this.from,
    this.to,
    this.day,
    this.speakers = const [],
    this.version,
  });

  factory EventWorkshop.fromJson(Map<String, dynamic> json) {
    return EventWorkshop(
      id: json['_id']?.toString() ?? '',
      eventId: json['event']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      attachments: json['attachments'] is List
          ? List<dynamic>.from(json['attachments'] as List)
          : const [],
      date: EventDetails._parseDate(json['date']),
      from: json['from']?.toString(),
      to: json['to']?.toString(),
      day: EventDetails._parseInt(json['day']),
      speakers: EventDetails._parseList<EventWorkshopSpeaker>(
        json['speakers'],
        EventWorkshopSpeaker.fromJson,
      ),
      version: EventDetails._parseInt(json['__v']),
    );
  }

  final String id;
  final String eventId;
  final String name;
  final String? description;
  final List<dynamic> attachments;
  final DateTime? date;
  final String? from;
  final String? to;
  final int? day;
  final List<EventWorkshopSpeaker> speakers;
  final int? version;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'event': eventId,
      'name': name,
      'description': description,
      'attachments': attachments,
      'date': date?.toIso8601String(),
      'from': from,
      'to': to,
      'day': day,
      'speakers': speakers.map((item) => item.toJson()).toList(),
      '__v': version,
    };
  }
}

class EventWorkshopSpeaker {
  const EventWorkshopSpeaker({
    required this.name,
    this.id,
  });

  factory EventWorkshopSpeaker.fromJson(Map<String, dynamic> json) {
    return EventWorkshopSpeaker(
      name: json['name']?.toString() ?? '',
      id: json['_id']?.toString(),
    );
  }

  final String name;
  final String? id;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      '_id': id,
    };
  }
}

class EventRequiredField {
  const EventRequiredField({
    required this.condition,
    required this.field,
    required this.label,
    required this.placeholder,
    required this.required,
    required this.type,
    this.enumValues = const [],
  });

  factory EventRequiredField.fromJson(Map<String, dynamic> json) {
    return EventRequiredField(
      condition: EventRequiredCondition.fromJson(
        json['condition'] is Map<String, dynamic>
            ? json['condition'] as Map<String, dynamic>
            : const {},
      ),
      field: json['field']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      placeholder: json['placeholder']?.toString() ?? '',
      required: json['required'] is bool ? json['required'] as bool : false,
      type: json['type']?.toString() ?? '',
      enumValues: json['enum_values'] is List
          ? (json['enum_values'] as List)
              .map((item) => item?.toString() ?? '')
              .toList(growable: false)
          : const [],
    );
  }

  final EventRequiredCondition condition;
  final String field;
  final String label;
  final String placeholder;
  final bool required;
  final String type;
  final List<String> enumValues;

  Map<String, dynamic> toJson() {
    return {
      'condition': condition.toJson(),
      'field': field,
      'label': label,
      'placeholder': placeholder,
      'required': required,
      'type': type,
      'enum_values': enumValues,
    };
  }
}

class EventRequiredCondition {
  const EventRequiredCondition({
    this.field,
    this.value,
  });

  factory EventRequiredCondition.fromJson(Map<String, dynamic> json) {
    return EventRequiredCondition(
      field: json['field']?.toString(),
      value: json['value']?.toString(),
    );
  }

  final String? field;
  final String? value;

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'value': value,
    };
  }
}
