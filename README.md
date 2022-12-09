# send_to_kindle

### Command line tool that allows you to send epub files directly to your kindle email address. To use this app you have to find a smtp provider and edit constants in the file accordingly.

---

Example use:
```bash
$ send_to_kindle.exe ../example1.mobi example2.epub
../example1.mobi is not a epub file. Trying to convert with ebook-convert: success
Sending... Sent! 👌😉
```

send_to_kindle converts the files using the *ebook-convert* that can be instaled with calibre. 