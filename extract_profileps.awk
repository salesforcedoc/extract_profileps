BEGIN { 
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
print "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">"
print "    <types>"
} 
{ 
printf "        <members>%s</members>\n", $0
}
END { 
print "        <name>CustomObject</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>Profile</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>PermissionSet</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>Layout</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>ApexClass</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>CustomApplication</name>"
print "    </types>"
print "    <types>"
print "        <members>*</members>"
print "        <name>CustomTab</name>"
print "    </types>"
print "    <version>44.0</version>"
print "</Package>"
} 