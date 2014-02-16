(* By: Thomas Brittain <thomas@pamexx.com> *)
(* Clean the bitcoin historical price dataset into an R ready format *)

(* NOTE: When running in toplevel, make sure to #require "csv";; *)

let in_file = "/home/alpha/Bitcoin Data/BTC_Bitstamp.csv" in
let out_file = "/home/alpha/Bitcoin Data/BTC_Bitstamp_clean.csv" in

(* Original file headers for all columns were:
 * Ticker, Per, Date, Time, Open, High, Low, Close, Volume *)
let headers = "Date,Time,Open,High,Low,Close,Volume\n" in

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
    let time = List.nth sl 3 in

    let hour = 
      if String.length time = 6 then String.sub time 0 2
      else if String.length time = 5 then "0"^(String.sub time 0 1)
      else "00" 
    in

    let minute = 
      if String.length time = 6 then String.sub time 2 2
      else if String.length time = 5 then String.sub time 1 2 
      else if String.length time = 4 then String.sub time 0 2
      else if String.length time = 3 then "0"^(String.sub time 0 1)
      else "00"
    in

    let open_price = List.nth sl 4 in
    let high_price = List.nth sl 5 in
    let low_price = List.nth sl 6 in
    let close_price = List.nth sl 7 in
    let volume = List.nth sl 8 in 

    (year^"-"^month^"-"^day^","^
     hour^":"^minute^","^
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
