### Usage

Your query will fail, if you try to compare Id field to invalid ID value. You either need a 15 char string or a 
valid 18 character ID string. The last tree characters could serve as simple checksum or for case insensitive 
sorting of ids.

    eval {
        $search_id = WWW::Salesforce::Id->new($key);
    };
    die $@
        if ($@);

    $sfdc->do_query(sprintf("SELECT Id, Title, FirstName, LastName, Email FROM Contact WHERE Id = '%s'", $search_id->id15);


### Warning

Please, be aware of possible SOQL Injection, when composing queries from user input. Be respnsible and drink more 
coffee and beer.

### License
CC-0 or WTF-PL

### Resources

* [CASESAFEID](https://help.salesforce.com/apex/HTViewHelpDoc?id=customize_functions_a_h.htm&language=en_US#CASESAFEID)
* [Salesforce Standard Object Record ID Prefixes](http://www.salesforcefast.com/2012/02/salesforce-standard-object-record-id.html)
* [15 or 18 Character IDs in Salesforce.com](https://astadiaemea.wordpress.com/2010/06/21/15-or-18-character-ids-in-salesforce-com-%E2%80%93-do-you-know-how-useful-unique-ids-are-to-your-development-effort/)
* [What are Salesforce ID's composed of?](https://salesforce.stackexchange.com/questions/1653/what-are-salesforce-ids-composed-of)
