"""
Class for automated operating system installation.

Oz is a set of classes to do automated operating system installation.  
It has built-in knowledge of the proper things to do for each of the supported
operating systems, so the data that the user must provide is very minimal.
This data is supplied in the form of an XML document that describes what
type of operating system is to be installed and where to get the
installation media. Oz handles the rest.

The simplest Oz program (without error handling or any advanced features)
would look something like:

import oz.TDL
import oz.GuestFactory

tdl_xml = \"\"\"
<template>
  <name>f40jeos</name>
  <os>
    <name>Fedora</name>
    <version>40</version>
    <arch>s390x</arch>
    <install type='url'>
      <url>https://dl.fedoraproject.org/pub/fedora-secondary/releases/40/Everything/s390x/os/</url>
    </install>
  </os>
  <description>Fedora 40 s390x</description>
</template>
\"\"\"

# Choose architecture based on your environment
tdl = oz.TDL.TDL(tdl_xml_s390x)  # or tdl_xml_x86
guest = oz.GuestFactory.guest_factory(tdl, None, None)
guest.generate_install_media()
guest.generate_diskimage()
guest.install()
"""
