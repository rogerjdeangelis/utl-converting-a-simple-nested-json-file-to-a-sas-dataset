%let pgm=utl-converting-a-simple-nested-json-file-to-a-sas-dataset;

Converting a simple nested json file to a sas dataset

github
http://tinyurl.com/2km27hy2
https://github.com/rogerjdeangelis/utl-converting-a-simple-nested-json-file-to-a-sas-dataset

Related repos on end

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                      |                                    |                                            */
/*         INPUT                        |        PROCESS                     |     OUTPUT (MAY WANT TO TRANSPOSE)         */
/*                                      |                                    |                                            */
/* {"widget": {                         |                                    |                                            */
/*   "debug": "on",                     |  widget <-fromJSON(                | VARIABLE (3 LEVELS)       VALUE            */
/*   "window": {                        |     "d:/json/widget.txt")          |                                            */
/*       "title": "Sample Widget",      |  want<-t(as.data.frame(widget[1])) | widget.debug              on               */
/*       "name": "main_window",         |  want<-as.data.frame(              |                                            */
/*       "width": 500,                  |    cbind(rownames(want),want))     | widget.window.title       Sample Widget    */
/*       "height": 500                  |                                    | widget.window.name        main_window      */
/*   },                                 |                                    | widget.window.width       500              */
/*   "image": {                         |                                    | widget.window.height      500              */
/*       "src": "Images/Sun.png",       |                                    |                                            */
/*       "name": "sun1",                |                                    | widget.image.src          Images/Sun.png   */
/*       "hOffset": 250,                |                                    | widget.image.name         sun1             */
/*       "vOffset": 250,                |                                    | widget.image.hOffset      250              */
/*       "alignment": "center"          |                                    | widget.image.vOffset      250              */
/*   },                                 |                                    | widget.image.alignment    center           */
/*   "text": {                          |                                    |                                            */
/*       "data": "Click Here",          |                                    | widget.text.data          Click Here       */
/*       "size": 36,                    |                                    | widget.text.size          36               */
/*       "style": "bold",               |                                    | widget.text.style         bold             */
/*       "name": "text1",               |                                    | widget.text.name          text1            */
/*       "hOffset": 250,                |                                    | widget.text.hOffset       250              */
/*       "vOffset": 100,                |                                    | widget.text.vOffset       100              */
/*       "alignment": "center",         |                                    | widget.text.alignment     center           */
/*       "onMouseUp": "sun1.opacity =   |                                    |                                            */
/*         (sun1.opacity / 100) * 90;"  |                                    |                                            */
/*   }                                  |                                    |                                            */
/* }}                                   |                                    |                                            */
/*                                      |                                    |                                            */
/**************************************************************************************************************************/


/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
filename ft15f001 "d:/json/widget.txt";
parmcards4;
{"widget": {
    "debug": "on",
    "window": {
        "title": "Sample Konfabulator Widget",
        "name": "main_window",
        "width": 500,
        "height": 500
    },
    "image": {
        "src": "Images/Sun.png",
        "name": "sun1",
        "hOffset": 250,
        "vOffset": 250,
        "alignment": "center"
    },
    "text": {
        "data": "Click Here",
        "size": 36,
        "style": "bold",
        "name": "text1",
        "hOffset": 250,
        "vOffset": 100,
        "alignment": "center",
        "onMouseUp": "sun1.opacity = (sun1.opacity / 100) * 90;"
    }
}}
;;;;
run;quit;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlfkil(d:/xpt/want.xpt)

%utl_rbegin;
parmcards4;
library(RJSONIO)
library(SASxport)
widget <-fromJSON("d:/json/widget.txt")
want<-t(as.data.frame(widget[1]))
want<-as.data.frame(cbind(rownames(want),want))
colnames(want) <- c('VARIABLE','VALUE')
want
for (i in 1:ncol(want)) {
      label(want[,i])<-colnames(want)[i];
      print(label(want[,i])) }
write.xport(want,file="d:/xpt/want.xpt")
;;;;
%utl_rend;

proc datasets lib=work nolist mt=data mt=view nodetails;delete want; run;quit;

/*--- handles long variable names by using the label to rename the variables  ----*/

libname xpt xport "d:/xpt/want.xpt";
proc contents data=xpt._all_;
run;quit;

data want_r_long_names;
  %utl_rens(xpt.want) ;
  set want;
run;quit;
libname xpt clear;

proc print;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* VARIABLE                  VALUE                                                                                        */
/*                                                                                                                        */
/* widget.debug              on                                                                                           */
/* widget.window.title       Sample Konfabulator Widget                                                                   */
/* widget.window.name        main_window                                                                                  */
/* widget.window.width       500                                                                                          */
/* widget.window.height      500                                                                                          */
/* widget.image.src          Images/Sun.png                                                                               */
/* widget.image.name         sun1                                                                                         */
/* widget.image.hOffset      250                                                                                          */
/* widget.image.vOffset      250                                                                                          */
/* widget.image.alignment    center                                                                                       */
/* widget.text.data          Click Here                                                                                   */
/* widget.text.size          36                                                                                           */
/* widget.text.style         bold                                                                                         */
/* widget.text.name          text1                                                                                        */
/* widget.text.hOffset       250                                                                                          */
/* widget.text.vOffset       100                                                                                          */
/* widget.text.alignment     center                                                                                       */
/* widget.text.onMouseUp     sun1.opacity = (sun1.opacity / 100) * 90;                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
