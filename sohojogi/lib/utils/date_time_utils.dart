String formatTimeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 7) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}