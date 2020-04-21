    LOG_ENABLE (2, 1); 

    -- Geo coordinates

    SPARQL
    CLEAR GRAPH <urn:johns-hopkins:covid19:fips:lookup:geo>   ;

    SPARQL
    PREFIX g: <http://www.w3.org/2003/01/geo/wgs84_pos#>
    PREFIX geo: <urn:johns-hopkins:covid19:fips:lookup#>

    INSERT { 
            GRAPH <urn:johns-hopkins:covid19:fips:lookup:geo> 
                    {
                    ?s g:lat ?lat ; 
                        g:long ?long 
                    }
            } 
    WHERE {
            ?s geo:Long_ ?long ; 
            geo:Lat ?lat . 
        } ;


    -- Pref Label Cleanup
    -- Countries and States

    SPARQL
    CLEAR GRAPH <urn:johns-hopkins:covid19:fips:lookup:labels>  ;

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    INSERT 
            {  
                    GRAPH <urn:johns-hopkins:covid19:fips:lookup:labels> 
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
                            CONCAT(?s13,' as of ',xsd:string(?s12)) as ?prefLabel
                            xsd:string(?s2) as ?fips
                            xsd:string(?s3) as ?state
                            xsd:string(?s4) as ?region
                            xsd:string(?s11) as ?admin


                    FROM <urn:johns-hopkins:covid19:fips:lookup>
                    WHERE 
                            { 
                                    # ?s1 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?s2 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?s3 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Country_Region> ?s4 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Confirmed> ?s5 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Active> ?s6 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Deaths> ?s7 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Recovered> ?s8 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Lat> ?s9 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Long_> ?s10 . 
                                    # ?s1 <urn:johns-hopkins:covid19:fips:lookup#Admin2> ?s11 . 
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Last_Update> ?s12 .  
                                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Combined_Key> ?s13 .  
                            }
            }  ;

    -- Labeling for Countries 

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    INSERT 
    {  
            GRAPH <urn:johns-hopkins:covid19:fips:lookup:labels> 
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
                    CONCAT(?s13,' as of ',xsd:string(?s12)) as ?prefLabel
                    xsd:string(?s2) as ?fips
                    xsd:string(?s3) as ?state
                    xsd:string(?s4) as ?region
                    xsd:string(?s11) as ?admin
            FROM <urn:johns-hopkins:covid19:fips:lookup>
            WHERE 
            { 
                    # ?s1 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?s2 . 
                    # ?s1 <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?s3 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Country_Region> ?s4 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Confirmed> ?s5 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Active> ?s6 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Deaths> ?s7 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Recovered> ?s8 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Lat> ?s9 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Long_> ?s10 . 
                    # ?s1 <urn:johns-hopkins:covid19:fips:lookup#Admin2> ?s11 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Last_Update> ?s12 .  
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Combined_Key> ?s13 .  
            }
    }  ;

    -- DBpedia State, County, FIPS Mapping

    SPARQL
    CLEAR GRAPH <urn:dbpedia:country:state:country:fips:mapping>   ;

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    INSERT 
            {  
                    GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                            {
                            ?s1 :dbpedia_county_id ?countyURI .
                            }
            }
    WHERE {
            GRAPH <urn:johns-hopkins:covid19:fips:lookup>   
                {   
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#FIPS> ?s2 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?s3 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Country_Region> ?s4 . 
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Admin2> ?s11 . 
                    BIND (IRI(CONCAT('http://dbpedia.org/resource/',?s11,'_County,','_',replace(?s3," ","_"))) as ?countyURI) . 
                    FILTER (?s4 = "US"^^xsd:string && (!CONTAINS(?s11,"Out of") && !CONTAINS(?s11, "Unassigned")))

                }

        }  ;

    -- DBpedia Country, State

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    INSERT 
            {  
                    GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                            {
                            ?s1 :dbpedia_state_id ?stateURI ;
                            :dbpedia_country_id ?countryURI .
                            }
            }
    WHERE
            {
            GRAPH <urn:johns-hopkins:covid19:fips:lookup>
                    {  
                            ?s1 <urn:johns-hopkins:covid19:fips:lookup#Province_State> ?s3 . 
                            ?s1 <urn:johns-hopkins:covid19:fips:lookup#Country_Region> ?s4 . 
                            BIND (IRI(CONCAT('http://dbpedia.org/resource/',replace(?s3," ","_"))) as ?stateURI) .
                            BIND (IRI(CONCAT('http://dbpedia.org/resource/',replace(?s4," ","_"))) as ?countryURI)
                    }
            }  ;

    -- Change US to United States
    -- INSERT 

    SPARQL 
    CLEAR GRAPH <urn:dbpedia:country:country:name:fixes>  ;

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    INSERT 
            {  
                    GRAPH <urn:johns-hopkins:covid19:fips:lookup>  
                            {
                            ?s1 :dbpedia_country_id ?newCountryURI .
                            }
            }
    WHERE
    {
    GRAPH <urn:johns-hopkins:covid19:fips:lookup>
            {  
                    ?s1 <urn:johns-hopkins:covid19:fips:lookup#Country_Region> ?s4 . 
                    BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                    BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(?s4),'#')) as ?bingCountryURI)
                    BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(?s4))) as ?bingCountryURL)
                    BIND (<http://dbpedia.org/resource/United_States> as ?newCountryURI)
                    FILTER (?s4 = "US"^^xsd:string)
            }
    }  ; 

    -- Deletion

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    DELETE
            {  
                    GRAPH <urn:johns-hopkins:covid19:fips:lookup>  
                            {
                            ?s1 :dbpedia_country_id ?oldCountryURI .
                            }
            }
    WHERE
    {
    GRAPH <urn:johns-hopkins:covid19:fips:lookup>
            {  
                    ?s1 :dbpedia_country_id ?oldCountryURI.
            }
    }  ; 

    -- DBpedia Country

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

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
            GRAPH <urn:johns-hopkins:covid19:fips:lookup>
                    {  
                            ?s1  <urn:johns-hopkins:covid19:fips:lookup#Country_Region>  ?s4 . 
                            BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                            BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,"-","")),'#')) as ?bingCountryURI)
                            BIND (IRI(CONCAT('https://bing.com/covid/local/',LCASE(REPLACE(?s4,"-","")))) as ?bingCountryURL)
                    }
            }  ;

    -- Bing URI for United States

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    CONSTRUCT
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
            GRAPH <urn:johns-hopkins:covid19:fips:lookup>
                    {  
                            ?s1  <urn:johns-hopkins:covid19:fips:lookup#Country_Region>  ?s4 . 
                            BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                            FILTER (?s4 = "US"^^xsd:string)
                    }
            }  ;

    SPARQL

    PREFIX : <urn:johns-hopkins:covid19:fips:lookup#> 

    DELETE
            {  
                    GRAPH <urn:dbpedia:country:state:country:fips:mapping>  
                            {
                                    ?s1 :dbpedia_country_id ?countryURI .
                                    
                                    ?countryURI owl:sameAs <https://bing.com/covid/local/us#> . 
                                    <https://bing.com/covid/local/us#>  schema:url <https://bing.com/covid/local/us>  .
                            }
            }
    WHERE
            {
            GRAPH <urn:johns-hopkins:covid19:fips:lookup>
                    {  
                            ?s1  <urn:johns-hopkins:covid19:fips:lookup#Country_Region>  ?s4 . 
                            BIND (IRI(CONCAT('http://dbpedia.org/resource/',REPLACE(?s4," ","_"))) as ?countryURI)
                            FILTER (?s4 = "US"^^xsd:string)
                    }
            }  ;
