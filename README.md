yasnippet-commented-licence
===========================

This is a licence yasnippet generator. From a single set of snippet source
files it generators new snippets for multiple languages, commented
appropriately for different programming languages. 

This is not a particularly slick package -- generating the snippets only needs
to happen when a new licence or a new language is added. 


Installation 
------------

expand-snippets.el requires not installation per se. It's easier to just load
it when needed. It has no entry points; there are two comments at the
beginning that you can eval which runs the code to generate all the licences. 

Once you have done this, add the directory to your yas-snippet-dirs
configuration. 

    (setq yas-snippet-dirs
          '(
            "~/emacs/yasnippet-commented-license"))
            

Adding a new mode
-----------------

To add a new mode, add to expand-snippets-mode. You can specify :before,
:after or :all which describes the characters to add as comments before, after
and of every line. 

Adding a new licence
--------------------

Licences are just normal yasnippets, and support header comments -- generally
useful to set (yas/ident-line 'fixed). Names will be added, so there is no
point doing this. 




