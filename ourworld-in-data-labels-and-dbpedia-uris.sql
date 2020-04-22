        LOG_ENABLE (2, 1); 

        
        -- Pref Label Cleanup
        -- Countries and States

        SPARQL
        CLEAR GRAPH <urn:ourworldindata:covid19:ecdc:data:full:labels>  ;

        SPARQL

        PREFIX : <urn:ourworldindata:covid19:ecdc:data:full#> 

        INSERT 
                {  
                        GRAPH <urn:ourworldindata:covid19:ecdc:data:full:labels> 
                                {
                                ?href skos:prefLabel ?prefLabel
                                }
                }
        WHERE
                {
                        SELECT ?s1 as ?href 
                                xsd:string(?s11) as ?name
                                ?image
                                xsd:dateTime(?s12) as ?date
                                CONCAT(?s4,' as of ',xsd:string(?s12)) as ?prefLabel
                                xsd:string(?s4) as ?region


                        FROM <urn:ourworldindata:covid19:ecdc:data:full>
                        WHERE 
                                { 
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#location> ?s4 . 
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#total_cases> ?s5 . 
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#new_cases> ?s6 . 
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#new_deaths> ?s7 . 
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#total_deaths> ?s8 .  
                                        ?s1 <urn:ourworldindata:covid19:ecdc:data:full#date> ?s12 .  
                                }
                }  ;

        
        

        -- Deletion

        SPARQL

        PREFIX : <urn:ourworldindata:covid19:ecdc:data:full#> 

        DELETE
                {  
                        GRAPH <urn:ourworldindata:covid19:ecdc:data:full>  
                                {
                                ?s1 :dbpedia_country_id ?oldCountryURI .
                                }
                }
        WHERE
        {
        GRAPH <urn:ourworldindata:covid19:ecdc:data:full>
                {  
                        ?s1 :dbpedia_country_id ?oldCountryURI.
                }
        }  ; 

        -- DBpedia Country

        SPARQL

        PREFIX : <urn:ourworldindata:covid19:ecdc:data:full#> 

        INSERT 
                {  
                        GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                                {
                                ?s1 :dbpedia_country_id ?countryURI .
                                
                                ?countryURI owl:sameAs ?bingCountryURI . 
                                ?bingCountryURI schema:url ?bingCountryURL .
                                }
                }
        WHERE
                {
                GRAPH <urn:ourworldindata:covid19:ecdc:data:full>
                        {  
                                ?s1  <urn:ourworldindata:covid19:ecdc:data:full#location>  ?s4 . 
                                BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                                BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,"-","")),'#')) as ?bingCountryURI)
                                BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,"-","")))) as ?bingCountryURL)
                        }
                }  ;
