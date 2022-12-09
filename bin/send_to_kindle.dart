import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main(List<String> arguments) async {
  // Exit if no input
  if (arguments.isEmpty) {
    stdout.write("Provide at least one attachment to send.\n");
    return;
  }

  // Private data
  const smtpProvider = "smtpProvider.domain"; // Todo: Replace
  const smtpPort = 123; // Todo: Replace
  const username = "smtpProvider username"; // Todo: Replace
  const password = "smtpProvider password"; // Todo: Replace
  const recipient = "EXAMPLE@KINDLE.COM"; // Todo: Replace

  // Set up the email server
  final smtpServer = SmtpServer(
    smtpProvider,
    port: smtpPort,
    username: username,
    password: password,
  );

  // Set up message data
  var message = Message()
    ..from = Address(username, 'Me')
    ..recipients.add(recipient)
    ..subject = "Wake up honey!"
    ..text = "New books just dropped 😉";

  // Add attachments
  for (var argument in arguments) {
    if (argument.toLowerCase().endsWith(".epub")) {
      // Add file if the format is epub
      message.attachments.add(FileAttachment(File(argument)));
    } else {
      stdout.write("$argument is not a epub file. Trying to convert: ");

      // Converting the file
      final desiredPath =
          "${argument.substring(0, argument.lastIndexOf('.'))}(converted).epub";
      await Process.run(
        'ebook-convert',
        [argument, desiredPath],
      ).then((result) {
        if (result.exitCode == 0) {
          stdout.write("success\n");
          message.attachments.add(FileAttachment(File(desiredPath)));
        } else {
          stdout.write("failure\n");
        }
      });
    }
  }

  // Sending message
  stdout.write("Sending... ");
  try {
    await send(message, smtpServer);
    stdout.write("Sent! 👌😉\n");
  } on MailerException catch (e) {
    stderr.write("Not sent 😒 Error: $e\n");
  }
}
