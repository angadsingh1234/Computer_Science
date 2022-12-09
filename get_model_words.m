function [model_words, num_tvs, list_of_tvs] = get_model_words(data)
    fn = fieldnames(data);
    num_tvs = 1624;
    special_characters = ["/"; "-" ; ":"; "."; "("; ")"; "\"; "'"; "["; "]"];
    special_characters_title = [":"; "."; "("; ")"; "\"; "'"; "["; "]"];
    inch = ["Inch"; "inches"; '"'; '”'; "-inch"; " inch" ; "Inch"; " Inch";"-Inch"];
    hertz = ["Hertz"; "hertz"; "Hz"; "HZ"; "-hz"];
    brands = ["Panasonic"; "Samsung"; "Sharp"; "Coby"; "LG"; "Sony";
          "Vizio"; "Dynex"; "Toshiba"; "HP"; "Supersonic"; "Elo";
          "Proscan"; "Westinghouse"; "SunBriteTV"; "Insignia"; "Haier";
          "Pyle"; "RCA"; "Hisense"; "Hannspree"; "ViewSonic"; "TCL";
          "Contec"; "NEC"; "Naxa"; "Elite"; "Venturer"; "Philips";
          "Open Box"; "Seiki"; "GPX"; "Magnavox"; "Hello Kitty"; "Naxa"; "Sanyo";
          "Sansui"; "Avue"; "JVC"; "Optoma"; "Sceptre"; "Mitsubishi"; "CurtisYoung"; "Compaq";
          "UpStar"; "Azend"; "Contex"; "Affinity"; "Hiteker"; "Epson"; "Viore"; "SIGMAC"; "Craig"; "Apple";
          "Proscan"];
    
    
    brands_from_title = strings(num_tvs, 1);
    model_words = strings(2000,1);
    list_of_tvs = struct();
    tv = 0;
    model_word_index = 0; 

    for k=1:numel(fn)
        tvs_in_item = length(data.(fn{k}));
        for z = 1:tvs_in_item
    
            tv =  tv + 1;
           
            %Data Cleansing
            
            %Normalize inch
            for str = 1:length(inch)
                data.(fn{k})(z).('title') = strrep(data.(fn{k})(z).('title'),inch(str),'inch');    
            end
            %Normalize Hertz
            for str = 1:length(hertz)
                data.(fn{k})(z).('title') = strrep(data.(fn{k})(z).('title'),hertz(str),'hz');    
            end
    
            %Create brands vector
            for i = 1:length(brands)
                if contains(lower(data.(fn{k})(z).('title')), lower(brands(i)))
                    brands_from_title(tv) = lower(brands(i));
                    list_of_tvs(tv).brand = lower(brands(i));
                    break;
                end
            end
            
            %Get Model Words from title
            mw_title = regexp(data.(fn{k})(z).('title'),'([a-zA-Z0-9]*(([0-9]+[^0-9, ]+)|([^0-9, ]+[0-9]+))[a-zA-Z0-9]*)','match');
            max_length = 0;
            max_index = 0; 
            for i = 1:length(mw_title)
                model_word_index = model_word_index + 1;
                model_words(model_word_index) = mw_title(i);
                %Check for longest string found by the regular expression
                if strlength([mw_title(i)]) > max_length
                    max_length = strlength([mw_title(i)]);
                    max_index = i;
                end
            end
%             
%             %Delete Special Characters from titles
%             for str = 1:length(special_characters)
%                 data.(fn{k})(z).('title') = strrep(data.(fn{k})(z).('title'),special_characters(str),'');    
%             end
            
            %Assign this longest string to be model id from the title
            model_ids_from_title(tv) = mw_title(max_index);
            
            %Create list of tvs
            list_of_tvs(tv).modelID = data.(fn{k})(z).modelID;
            list_of_tvs(tv).shop = data.(fn{k})(z).shop;
        end
    end
    
    for i = 1:length(model_ids_from_title)
        if contains(model_ids_from_title(i), 'inch') || contains(model_ids_from_title(i), 'hz') ...
            || contains(model_ids_from_title(i), '720p') || contains(model_ids_from_title(i), 'cd/m2') ...
            || contains(model_ids_from_title(i), 'cdm2') || contains(model_ids_from_title(i), '3D') ...
            || contains(model_ids_from_title(i), '40in') 
            
            model_ids_from_title(i) = ""; 

        end
    end
    model_words = unique(model_words);
    
    %Remove special characters from model_words
    for i = 1:length(model_words)
        for str = 1:length(special_characters)
            model_words(i) = strrep(model_words(i), special_characters(str), '');    
        end
    end

    %Remove special characters from model_ids_from_title
    for i = 1:length(model_ids_from_title)
        for str = 1:length(special_characters_title)
            model_ids_from_title(i) = strrep(model_ids_from_title(i), special_characters_title(str), '');    
            list_of_tvs(i).modelID_title = model_ids_from_title(i);
        end
    end
end

