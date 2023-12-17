enum NotificationType { mention, reply, lostAndFound, news }

NotificationType getNotificationTypeFromString(String notificationType) {
  switch (notificationType) {
    case 'mention':
      return NotificationType.mention;
    case 'reply':
      return NotificationType.reply;
    case 'lostAndFound':
      return NotificationType.lostAndFound;
    default:
      return NotificationType.news;
  }
}
