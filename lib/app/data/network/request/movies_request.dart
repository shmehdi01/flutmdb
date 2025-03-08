class MoviesRequest {
  final int page;
  final bool includeAdult;
  final bool includeVideo;
  final String language;
  final String sortBy;

  MoviesRequest({
    required this.page,
    required this.includeAdult,
    required this.includeVideo,
    required this.language,
    required this.sortBy,
  });

  factory MoviesRequest.defaultRequest({required int page}) {
    return MoviesRequest(
      page: page,
      includeAdult: false,
      includeVideo: false,
      language: 'en-US',
      sortBy: 'popularity.desc',
    );
  }

  Map<String, dynamic> toQuery() {
    return {
      'include_adult': includeAdult,
      'include_video': includeVideo,
      'language': language,
      'sort_by': sortBy,
      'page': page,
    };
  }
}
