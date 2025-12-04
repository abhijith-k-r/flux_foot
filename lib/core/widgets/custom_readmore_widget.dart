import 'dart:ui';

import 'package:animated_read_more_text/animated_read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ! Custom READ MORE TEXT
customReadmoreText(String description) {
  return AnimatedReadMoreText(
    description,
    maxLines: 5,
    readLessText: ' Less',
    readMoreText: '...Read more',
    textStyle: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
  );
}
