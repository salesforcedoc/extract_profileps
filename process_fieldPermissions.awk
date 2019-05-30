BEGIN { 
    cache_it = 0;
    print_it = 0;
    skip_it = 0;
    print_cache = "";
}
/\<fieldPermissions\>/{ cache_it = 1; }
/\<editable\>true\<\/editable\>/{ print_it = 1; }
/\<readable\>true\<\/readable\>/{ print_it = 1; }
/\<field\>OBJECT.FIELD_TO_EXCLUDE\<\/field\>/{ skip_it = 1; }
{
    if (cache_it==1) {
        if (print_cache=="") {
            print_cache = $0; 
        } else {
            print_cache = sprintf("%s\n%s", print_cache, $0); 
        }
        # printf("cache:%s\n", $0);
    } else {
        printf("%s\n", $0);
    }
}
/\<\/fieldPermissions\>/{
    if (print_it==1 && skip_it==0) {
        printf("%s\n", print_cache);
    }
    cache_it = 0;
    print_it = 0;
    skip_it = 0;
    print_cache = "";
}