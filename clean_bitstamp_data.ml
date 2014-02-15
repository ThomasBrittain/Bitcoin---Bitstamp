(* By: Thomas Brittain <thomas@pamexx.com> *)
(* Clean the bitcoin historical price dataset into an R ready format *)

(* NOTE: When running in toplevel, make sure to #require "csv";; *)

let in_file = "/home/alpha/Bitcoin Data/BTC_Bitstamp.csv" in
let out_file = "/home/alpha/Bitcoin Data/BTC_Bitstamp_clean.csv" in

(* Original file headers for all columns were:
 * Ticker, Per, Date, Time, Open, High, Low, Close, Volume *)
let headers = "Date,Open,High,Low,Close,Volume\n" in

(* Open the in_channel *)
let (ic : in_channel) = open_in in_file in

(* Create the CSV in_channel *)
let (csv_ic : Csv.in_channel) = Csv.of_channel ~separator:',' ~excel_tricks:false ic in

(* Create the out_channel *)
let (oc : out_channel) = open_out_gen [Open_wronly; Open_creat; Open_trunc] 0o640 out_file in

(* Function to use in Csv.iter *)
let write_line (sl : string list) = 
  let new_string = 
    let date = List.nth sl 2 in
    let year = String.sub date 0 4 in
    let month = String.sub date 4 2 in
    let day = String.sub date 6 2 in
    let open_price = List.nth sl 4 in
    let high_price = List.nth sl 5 in
    let low_price = List.nth sl 6 in
    let close_price = List.nth sl 7 in
    let volume = List.nth sl 8 in 
    (year^"-"^month^"-"^day^","^
     open_price^","^
     high_price^","^
     low_price^","^
     close_price^","^
     volume^"\n")
  in
    (* Write the new line to the output file *)
    output_string oc new_string;
    flush oc;
    (*print_string new_string;*)
in

(* Write the headers to the file *)
output_string oc headers;

(* Write all of the new csv lines to the output file *)
Csv.iter write_line csv_ic;

(* Close the CSV in_channel -- the underlying channel is close as well *)
Csv.close_in csv_ic;



















(*

let _ = 
  let open Core_kernel.In_channel in
  let ic : in_channel = create test_file in                (* Create an in_channel for the file *)
  
  let print_to_new_file s:string = 
    let open Core_kernel in
    let string_list = Core_string.split s ~on: ',' in  (* Split the string into a list of words *)
    let raw_date = List.nth string_list 3 in
    (*let year = Core_string.slice raw_date 0 4 in
    let month = Core_string.slice raw_date 4 6 in
    let day = Core_string.slice raw_date 6 8 in*)

    (*let string_to_print = Core_string.concat ~sep:"," [year; month; day] in*)

    print_string (raw_date^"\n");
    (*print_string (year^"\n");
    print_string (month^"\n");
    print_string (day^"\n");*)

  in
    iter_lines ic print_to_new_file;
    close ic;

    *)
