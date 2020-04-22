    LOG_ENABLE (2, 1); 

    
    -- Pref Label Cleanup
    -- Countries and States

    SPARQL
    CLEAR GRAPH <urn:covidtracking:crawl:data:labels>  ;

    SPARQL

    PREFIX : <urn:covidtracking:crawl:data#> 

    INSERT 
            {  
                    GRAPH <urn:covidtracking:crawl:data:labels> 
                            {
                             ?href skos:prefLabel ?prefLabel
                            }
            }
    WHERE
            {
                    SELECT 
                        ?s1 as ?href 
                        CONCAT(?province,' as of ',xsd:string(?date)) as ?prefLabel
                            
                    FROM <urn:covidtracking:crawl:data>
                    WHERE 
                            {
                                ?s1  :fips ?fips;
                                     :dateChecked ?date.

                                GRAPH <urn:johns-hopkins:covid19:fips:lookup> 
                                    {
                                        ?s2 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?fips; 
                                            <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?province.
                                        BIND(CONCAT("http://dbpedia.org/resource/",?province) as ?state)
                                    }

                            }
            };            


    -- Deletion

    SPARQL

    PREFIX : <urn:covidtracking:crawl:data#> 

    DELETE
            {  
                    GRAPH <urn:covidtracking:crawl:data:mapping>  
                            {
                            ?s1 :dbpedia_country_id ?oldCountryURI .
                            }
            }
    WHERE
    {
    GRAPH <urn:covidtracking:crawl:data:mapping>
            {  
                    ?s1 :dbpedia_country_id ?oldCountryURI.
            }
    }  ; 

    

    -- DBpedia Country, State

    SPARQL

    PREFIX : <urn:covidtracking:crawl:data#> 

    INSERT 
            {  
                    GRAPH <urn:covidtracking:crawl:data:mapping>  
                            {
                            ?href :dbpedia_state_id ?stateURI ;
                            :dbpedia_country_id ?countryURI .
                            }
            }
    WHERE
            {
                    SELECT 
                        ?s1 as ?href 
                        CONCAT(?province,' as of ',xsd:string(?date)) as ?prefLabel
                        ?stateURI
                        ?countryURI
                            
                    FROM <urn:covidtracking:crawl:data>
                    WHERE 
                            {
                                ?s1  :fips ?fips;
                                     :dateChecked ?date.

                                GRAPH <urn:johns-hopkins:covid19:fips:lookup> 
                                    {
                                        ?s2 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?fips; 
                                            <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?province.
                                        BIND(IRI(CONCAT("http://dbpedia.org/resource/",REPLACE(?province," ","_"))) AS ?stateURI)
                                    }
                                        BIND(IRI("http://dbpedia.org/resource/United_States") AS ?countryURI)
                            }
            };     

    

    

    -- Bing URI for United States

    SPARQL

    PREFIX : <urn:covidtracking:crawl:data#> 

    INSERT INTO GRAPH <urn:dbpedia:country:state:country:fips:mapping> 
            {  
                    GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                            {
                                    ?s1 :dbpedia_country_id ?countryURI .
                                    
                                    ?countryURI owl:sameAs <https://bing.com/covid/local/unitedstates#> . 
                                    <https://bing.com/covid/local/unitedstates#>  schema:url <https://bing.com/covid/local/unitedstates>  .
                            }
            }
    WHERE
            {
                    SELECT 
                        ?s1 as ?href 
                        CONCAT(?province,' as of ',xsd:string(?date)) as ?prefLabel
                        ?stateURI
                        ?countryURI
                            
                    FROM <urn:covidtracking:crawl:data>
                    WHERE 
                            {
                                ?s1  :fips ?fips;
                                     :dateChecked ?date.

                                GRAPH <urn:johns-hopkins:covid19:fips:lookup> 
                                    {
                                        ?s2 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?fips; 
                                            <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?province.
                                        BIND(CONCAT("http://dbpedia.org/resource/",REPLACE(?province," ","")) AS ?stateURI)
                                    }
                                        BIND("http://dbpedia.org/resource/United_States" AS ?countryURI)
                            }
            };