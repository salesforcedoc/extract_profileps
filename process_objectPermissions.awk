BEGIN { 
    cache_it = 0;
    print_it = 0;
    skip_it = 0;
    print_cache = "";
}
/\<objectPermissions\>/{ cache_it = 1; print_it = 1; }
/\<object\>SOME_OBJECT__/{ skip_it = 1; }
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
/\<\/objectPermissions\>/{
    if (print_it==1 && skip_it==0) {
        printf("%s\n", print_cache);
    }
    cache_it = 0;
    print_it = 0;
    skip_it = 0;
    print_cache = "";
}