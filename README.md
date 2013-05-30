sina-extractor
==============

A universal web page parser and content extractor.

### USAGE

For synopsis, check [the pod in the src code](https://github.com/BaiGang/sina-extractor/blob/master/lib/SINA/Extractor.pm#L160). You need a config file for specifying the fields or contents to extract.

### CONFIGURATION

Suppose we are dealing with web pages in a format like this:

    <html>
    <head>
      <meta charset='utf-8'>
      <title>The universal extractor</title>
      <meta name="author" content="Gang Bai">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link href="/favicon.png" rel="icon">
    </head><body><header role="banner"><hgroup>
      <h1><a href="/">Extracting crab legs.</a></h1><h2>From a pot of ugly bisques.</h2>
      </hgroup></header><script type="text/javascript">
    (function() {
      var script = document.createElement('script'); script.type = 'text/javascript'; script.async = true;
      script.src = 'https://apis.google.com/js/plusone.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(script, s);
    })();</script><script type="text/javascript">
    (function(){
    })();</script></div></body>

With a configure:

    meta   name:author attr:content author_of_the_page
    a      href:.+     attr:href    a_link
    title  NULL        content      the_title

Each line of the configure is a field we want to extract. (The function of extracting repeated fields is absent for now...) The first line is configured for extracted a `<meta ...>` field, of which the `name` field has a value `author`, and what we wanna extract is a field (that is why it's with a prefix `attr`). The last column specifies the name of the extracted value in the representation of the extracted result sets.

The second line shows perl regular expressions are appliable in the filters. In the third configuration, a `NULL` indicates that there's no filter for extracting `title` and we want the `content` rather than a field (there's no `attr` prefix for `content`).

### INSTALLATION

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

### LICENCE

Copyright (C) 2013 by Bai Gang

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


