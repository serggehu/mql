//+------------------------------------------------------------------+
//|                                                 AdaptivrPair.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

// INPUT //
input int iNB=1;              //NB TRADES
input double dSL=50;           //NB PIPS SELL_SL
input double dVOL=0.1;       //VOLUME
input double dTP=-10;          //NB PIPS SELL_TP

string   aPairs[21][2];
double   dInitAccountValue;
double   dAccountValueTarget; 


#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\Button.mqh>
#include <Controls\ComboBox.mqh>

#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

#include <Arrays\List.mqh>

#define EXPERT_MAGIC 123456

CTrade         trade;
CAccountInfo   accountInfo;
CPositionInfo  positionInfo;
//+------------------------------------------------------------------+
//| DEFINES                                                          |
//+------------------------------------------------------------------+
#define INDENT_LEFT                         (-60)     // left indent (including the border width)
#define INDENT_TOP                          (11)      // top indent (including the border width)
#define INDENT_RIGHT                        (11)      // right indent (including the border width)
#define INDENT_BOTTOM                       (11)      // bottom indent (including the border width)
#define CONTROLS_GAP_X                      (5)      // spacing along the X-axis
#define CONTROLS_GAP_Y                      (5)      // spacing along the Y-axis
#define LABEL_WIDTH                         (30)      // size along the X-axis
#define EDIT_WIDTH                          (55)      // size along the X-axis
#define EDIT_HEIGHT                         (20)      // size along the Y-axis
#define BUTTON_WIDTH                        (70)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate

//+------------------------------------------------------------------+
//| CPanelDialog class                                               |
//| Function: main application dialog                                |
//+------------------------------------------------------------------+
class CControlsDialog : public CAppDialog
  {
private:

   // ADDITIONAL CONTROLS //
   CLabel            clLabel_NB;    // The "NB" of trades
   CLabel            clLabel_SL;    // The "SL" of trades
   CLabel            clLabel_VOL;   // The "VOL" of trades
   CLabel            clLabel_TP;    // The "TP" of trades
   CLabel            clLabel_PAIR_1;  // The "SYM" of trades
   CLabel            clLabel_PAIR_2;  // The "SYM" of trades
   CLabel            clLabel_PAIR_3;  // The "SYM" of trades
   CLabel            clLabel_PAIR_4;  // The "SYM" of trades

   CSpinEdit         clSpinEdit_NB;// The "NB" value
   CEdit             clEdit_SL;     // The "SL" value
   CEdit             clEdit_VOL;    // The "VOL" value
   CEdit             clEdit_TP;     // The "TP" value

   CButton           clButton_START;             // The "SELL" button object
   CButton           clButton_STOP;              // The "SELL" button object
   CButton           clButton_DEL;

   // PARAMETER VALUES //
   int               iNB;       // The "NB" value
   double            dSL;       // The "SL" value
   double            dVOL;   // The "VOL" value
   double            dTP;       // The "TP" value

  /////////////////////////////////////////////////////////

  //                  USER VARIABLES                      //

  /////////////////////////////////////////////////////////
  bool                bInit;
  int                 iTotPos;
  double              dInterPairThresh;
  string              sPairClose1;
  string              sPairClose2;
  bool                bDeInit;
  double                dProfTreash;
          



  ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////

public:

   CComboBox         clComboBox_PAIR_1; // CComboBox object
   CComboBox         clComboBox_PAIR_2;
   CComboBox         clComboBox_PAIR_3;
   CComboBox         clComboBox_PAIR_4;


                     CControlsDialog(void);
                    ~CControlsDialog(void);

   //--- creation
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);

   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   //--- properties
   void              vSetNB(const int value);
   void              vSetSL(const double value);
   void              vSetVOL(const double value);
   void              vSetTP(const double value);
   void              vSetPair_1(const int value);
   void              vSetPair_2(const int value);
   void              vSetPair_3(const int value);
   void              vSetPair_4(const int value);
  /////////////////////////////////////////////////////////

  //                  USER METHODS                        //

  /////////////////////////////////////////////////////////
  void              vSetInit(bool comm){bInit = comm;}     
  bool              bGetInit(){return(bInit);}

  void              vSetProfTreasch(bool comm){dProfTreash = comm;}     
  double             dGetProfTreash(){return(dProfTreash);}

  void              vSetDeInit(bool comm){bDeInit = comm;}     
  bool              bGetDeInit(){return(bDeInit);}

  void              vSetTotPos(int comm){iTotPos = comm;}
  int               iGetTotPos(){return(iTotPos);}

  void              vSetIntPaTh(int comm){dInterPairThresh = comm;}
  int               dGetIntPaTh(){return(dInterPairThresh);}
  
  void              vSetPairClose1(string comm){sPairClose1 = comm;}
  string            sGetPairClose1(){return(sPairClose1);}

  void              vSetPairClose2(string comm){sPairClose2 = comm;}
  string            sGetPairClose2(){return(sPairClose2);}
  ///////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
   double            vGetdTP(){return(dTP);}
 //  void              bSetDeInit(const bool value);
   //   void              vSetSyms(const string value1, const string value2, const string value3);
   //   void              vSetSymArr(const string value, double &arr[]);


protected:

   // CREATING ADDITIONAL CONTROLS //

   bool              bCreate_Label_NB(void);
   bool              bCreate_Label_SL(void);
   bool              bCreate_Label_VOL(void);
   bool              bCreate_Label_TP(void);
   bool              bCreate_Label_PAIR_1(void);
   bool              bCreate_Label_PAIR_2(void);
   bool              bCreate_Label_PAIR_3(void);
   bool              bCreate_Label_PAIR_4(void);

   bool              bCreate_SpinEdit_NB(void);
   bool              bCreate_Edit_SL(void);
   bool              bCreate_Edit_VOL(void);
   bool              bCreate_Edit_TP(void);

   bool              bCreate_Button_STOP(void);
   bool              bCreate_Button_START(void);
   bool              bCreate_Button_DEL(void);

   bool              bCreate_ComboBox_Pair_1(void);
   bool              bCreate_ComboBox_Pair_2(void);
   bool              bCreate_ComboBox_Pair_3(void);
   bool              bCreate_ComboBox_Pair_4(void);

   //--- handlers of the dependent controls events
   void              vOnClick_Button_START(void);
   void              vOnClick_Button_STOP(void);
   void              vOnClick_Button_DEL(void);

   //--- internal event handlers
   virtual bool      OnResize(void);

  };

// ********************************************** //
// *************** EVENT HANDLING *************** //
// ********************************************** //
EVENT_MAP_BEGIN(CControlsDialog)
ON_EVENT(ON_CLICK,clButton_START,       vOnClick_Button_START)
ON_EVENT(ON_CLICK,clButton_STOP,        vOnClick_Button_STOP)
ON_EVENT(ON_CLICK,clButton_DEL,     vOnClick_Button_DEL)
EVENT_MAP_END(CAppDialog)

// ********************************************** //
// *********** CONSTRUCTOR/DESTRUCTOR *********** //
// ********************************************** //
CControlsDialog::CControlsDialog(void) { }
CControlsDialog::~CControlsDialog(void) { }

// ********************************************** //
// ******************* CREATION ***************** //
// ********************************************** //
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {

//--- calling the parent class method
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);

// CREATING ADDITIONAL CONTROLS //

   if(!bCreate_Label_NB())
      return(false);
   if(!bCreate_Label_SL())
      return(false);
   if(!bCreate_Label_VOL())
      return(false);
   if(!bCreate_Label_TP())
      return(false);
   if(!bCreate_Label_PAIR_1())
      return(false);
   if(!bCreate_Label_PAIR_2())
      return(false);
   if(!bCreate_Label_PAIR_3())
      return(false);
   if(!bCreate_Label_PAIR_4())
      return(false);

   if(!bCreate_SpinEdit_NB())
      return(false);
   if(!bCreate_Edit_SL())
      return(false);
   if(!bCreate_Edit_VOL())
      return(false);
   if(!bCreate_Edit_TP())
      return(false);

   if(!bCreate_Button_STOP())
      return(false);
   if(!bCreate_Button_START())
      return(false);
   if(!bCreate_Button_DEL())
      return(false);

   if(!bCreate_ComboBox_Pair_1())
      return(false);
   if(!bCreate_ComboBox_Pair_2())
      return(false);
   if(!bCreate_ComboBox_Pair_3())
      return(false);
   if(!bCreate_ComboBox_Pair_4())
      return(false);
   return(true);
  }


// ******************************************************************* //
// ***************** CREATING THE DISPLAY ELEMENT NB ***************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Label_NB(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_NB.Create(m_chart_id,m_name+"Label_NB",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_NB.Text("NB"))
      return(false);
   if(!Add(clLabel_NB))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ******************* CREATING THE EDIT ELEMENT NB ****************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_SpinEdit_NB(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

//--- create
   if(!clSpinEdit_NB.Create(m_chart_id,m_name+"SpinEdit_NB",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(clSpinEdit_NB))
      return(false);
   clSpinEdit_NB.MinValue(1);
   clSpinEdit_NB.MaxValue(20);
   clSpinEdit_NB.Value(1);

   return(true);
  }


// ******************************************************************* //
// ******************** CREATING THE SELL BUTTON ********************* //
// ******************************************************************* //
bool CControlsDialog::bCreate_Button_START(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+5*LABEL_WIDTH+5*CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!clButton_START.Create(m_chart_id,"ButtonSTART",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clButton_START.Text("START"))
      return(false);
   if(!Add(clButton_START))
      return(false);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::bCreate_Button_STOP(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+5*LABEL_WIDTH+5*CONTROLS_GAP_X;
   int y1=INDENT_TOP*3;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!clButton_STOP.Create(m_chart_id,"ButtonSTOP",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clButton_STOP.Text("STOP"))
      return(false);
   if(!Add(clButton_STOP))
      return(false);

//   clButton_STOP.Hide();
//   clButton_STOP.Disable();
   return(true);
  }
bool CControlsDialog::bCreate_Button_DEL(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+5*LABEL_WIDTH+5*CONTROLS_GAP_X;
   int y1=INDENT_TOP*5;
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!clButton_DEL.Create(m_chart_id,"ButtonDEL",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clButton_DEL.Text("DEL"))
      return(false);
   if(!Add(clButton_DEL))
      return(false);

//   clButton_DEL.Hide();
//   clButton_DEL.Disable();
   return(true);
  }

// ******************************************************************* //
// ***************** CREATING THE DISPLAY ELEMENT SL ***************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Label_SL(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_SL.Create(m_chart_id,m_name+"Label_SL",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_SL.Text("SL"))
      return(false);
   if(!Add(clLabel_SL))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ******************* CREATING THE EDIT ELEMENT SL ****************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Edit_SL(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+EDIT_HEIGHT+CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE EDIT NB //
   if(!clEdit_SL.Create(m_chart_id,m_name+"Edit_SL",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clEdit_SL.Text(DoubleToString(dSL)))
      return(false);
   if(!clEdit_SL.ReadOnly(false))
      return(false);
   if(!Add(clEdit_SL))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ***************** CREATING THE DISPLAY ELEMENT VOL **************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Label_VOL(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+2*EDIT_HEIGHT+2*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_VOL.Create(m_chart_id,m_name+"Label_VOL",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_VOL.Text("VOL"))
      return(false);
   if(!Add(clLabel_VOL))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ******************* CREATING THE EDIT ELEMENT VOL ***************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Edit_VOL(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+2*EDIT_HEIGHT+2*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE EDIT VOL //
   if(!clEdit_VOL.Create(m_chart_id,m_name+"Edit_VOL",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clEdit_VOL.Text(DoubleToString(dVOL)))
      return(false);
   if(!clEdit_VOL.ReadOnly(false))
      return(false);
   if(!Add(clEdit_VOL))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ***************** CREATING THE DISPLAY ELEMENT TP ***************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Label_TP(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+3*EDIT_HEIGHT+3*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_TP.Create(m_chart_id,m_name+"Label_TP",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_TP.Text("TP"))
      return(false);
   if(!Add(clLabel_TP))
      return(false);

   return(true);
  }

// ******************************************************************* //
// ******************* CREATING THE EDIT ELEMENT TP ****************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Edit_TP(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+3*EDIT_HEIGHT+3*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE EDIT NB //
   if(!clEdit_TP.Create(m_chart_id,m_name+"Edit_TP",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!clEdit_TP.Text(DoubleToString(dTP)))
      return(false);
   if(!clEdit_TP.ReadOnly(false))
      return(false);
   if(!Add(clEdit_TP))
      return(false);

   return(true);
  }

// ******************************************************************* //
// **************** CREATING THE DISPLAY ELEMENT PRICE *************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_Label_PAIR_1(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+4*EDIT_HEIGHT+4*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_PAIR_1.Create(m_chart_id,m_name+"clLabel_PAIR_1",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_PAIR_1.Text("SYM"))
      return(false);
   if(!Add(clLabel_PAIR_1))
      return(false);

   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::bCreate_Label_PAIR_2(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+5*EDIT_HEIGHT+5*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_PAIR_2.Create(m_chart_id,m_name+"clLabel_PAIR_2",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_PAIR_2.Text("SYM"))
      return(false);
   if(!Add(clLabel_PAIR_2))
      return(false);

   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::bCreate_Label_PAIR_3(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+6*EDIT_HEIGHT+6*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_PAIR_3.Create(m_chart_id,m_name+"clLabel_PAIR_3",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_PAIR_3.Text("SYM"))
      return(false);
   if(!Add(clLabel_PAIR_3))
      return(false);

   return(true);
  }
  bool CControlsDialog::bCreate_Label_PAIR_4(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+2*LABEL_WIDTH+2*CONTROLS_GAP_X;
   int y1=INDENT_TOP+7*EDIT_HEIGHT+6*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE LABEL NB//
   if(!clLabel_PAIR_4.Create(m_chart_id,m_name+"clLabel_PAIR_3",m_subwin,x1,y1+1,x2,y2))
      return(false);
   if(!clLabel_PAIR_4.Text("SYM"))
      return(false);
   if(!Add(clLabel_PAIR_4))
      return(false);

   return(true);
  }
// ******************************************************************* //
// **************** CREATING THE COMBOBOX ELEMENT PAIR *************** //
// ******************************************************************* //
bool CControlsDialog::bCreate_ComboBox_Pair_1(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+4*EDIT_HEIGHT+4*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH*2.5;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE CAPTION //
   if(!clComboBox_PAIR_1.Create(m_chart_id,"COMBOBOX_PAIR_1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(clComboBox_PAIR_1))
      return(false);

   int HowManySymbols=SymbolsTotal(true);

   string array_string[], stemp;
   ArrayResize(array_string,HowManySymbols);

   for(int i=0; i<HowManySymbols; i++)
      array_string[i]=SymbolName(i,true);

   for(int i=0; i<HowManySymbols; i++)
     {
      for(int j=i+1; j<HowManySymbols; j++)
        {
         if(StringCompare(array_string[i],array_string[j],false)>0)
           {
            stemp = array_string[i];
            array_string[i]=array_string[j];
            array_string[j]=stemp;
           }
        }
     }

   for(int i=0; i<HowManySymbols; i++)
     {
      clComboBox_PAIR_1.ItemAdd(array_string[i]);
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::bCreate_ComboBox_Pair_2(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+5*EDIT_HEIGHT+5*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH*2.5;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE CAPTION //
   if(!clComboBox_PAIR_2.Create(m_chart_id,"COMBOBOX_PAIR_2",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(clComboBox_PAIR_2))
      return(false);

   int HowManySymbols=SymbolsTotal(true);

   string array_string[], stemp;
   ArrayResize(array_string,HowManySymbols);

   for(int i=0; i<HowManySymbols; i++)
      array_string[i]=SymbolName(i,true);

   for(int i=0; i<HowManySymbols; i++)
     {
      for(int j=i+1; j<HowManySymbols; j++)
        {
         if(StringCompare(array_string[i],array_string[j],false)>0)
           {
            stemp = array_string[i];
            array_string[i]=array_string[j];
            array_string[j]=stemp;
           }
        }
     }

   for(int i=0; i<HowManySymbols; i++)
     {
      clComboBox_PAIR_2.ItemAdd(array_string[i]);
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CControlsDialog::bCreate_ComboBox_Pair_3(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+6*EDIT_HEIGHT+6*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH*2.5;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE CAPTION //
   if(!clComboBox_PAIR_3.Create(m_chart_id,"COMBOBOX_PAIR_3",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(clComboBox_PAIR_3))
      return(false);

   int HowManySymbols=SymbolsTotal(true);

   string array_string[], stemp;
   ArrayResize(array_string,HowManySymbols);

   for(int i=0; i<HowManySymbols; i++)
      array_string[i]=SymbolName(i,true);

   for(int i=0; i<HowManySymbols; i++)
     {
      for(int j=i+1; j<HowManySymbols; j++)
        {
         if(StringCompare(array_string[i],array_string[j],false)>0)
           {
            stemp = array_string[i];
            array_string[i]=array_string[j];
            array_string[j]=stemp;
           }
        }
     }

   for(int i=0; i<HowManySymbols; i++)
     {
      clComboBox_PAIR_3.ItemAdd(array_string[i]);
     }

   return(true);
  }
bool CControlsDialog::bCreate_ComboBox_Pair_4(void)
  {
// COORDINATES //
   int x1=INDENT_LEFT+3*LABEL_WIDTH+3*CONTROLS_GAP_X;
   int y1=INDENT_TOP+7*EDIT_HEIGHT+7*CONTROLS_GAP_Y;
   int x2=x1+EDIT_WIDTH*2.5;
   int y2=y1+EDIT_HEIGHT;

// CREATING THE CAPTION //
   if(!clComboBox_PAIR_4.Create(m_chart_id,"COMBOBOX_PAIR_4",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(clComboBox_PAIR_4))
      return(false);

   int HowManySymbols=SymbolsTotal(true);

   string array_string[], stemp;
   ArrayResize(array_string,HowManySymbols);

   for(int i=0; i<HowManySymbols; i++)
      array_string[i]=SymbolName(i,true);

   for(int i=0; i<HowManySymbols; i++)
     {
      for(int j=i+1; j<HowManySymbols; j++)
        {
         if(StringCompare(array_string[i],array_string[j],false)>0)
           {
            stemp = array_string[i];
            array_string[i]=array_string[j];
            array_string[j]=stemp;
           }
        }
     }

   for(int i=0; i<HowManySymbols; i++)
     {
      clComboBox_PAIR_4.ItemAdd(array_string[i]);
     }

   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the "NB" value                                          |
//+------------------------------------------------------------------+
void CControlsDialog::vSetNB(const int value)
  {

   iNB=value;
   clSpinEdit_NB.Value(value);
  }

//+------------------------------------------------------------------+
//| Setting the "SL" value                                          |
//+------------------------------------------------------------------+
void CControlsDialog::vSetSL(const double value)
  {

   dSL=value;
   clEdit_SL.Text(DoubleToString(value,2));
  }

//+------------------------------------------------------------------+
//| Setting the "VOL" value                                          |
//+------------------------------------------------------------------+
void CControlsDialog::vSetVOL(const double value)
  {

   dVOL=value;
   clEdit_VOL.Text(DoubleToString(value,2));
  }

//+------------------------------------------------------------------+
//| Setting the "TP" value                                           |
//+------------------------------------------------------------------+
void CControlsDialog::vSetTP(const double value)
  {

   dTP=value;
   clEdit_TP.Text(DoubleToString(value,2));
  }
  

//+------------------------------------------------------------------+
//| Resize handler                                                   |
//+------------------------------------------------------------------+
bool CControlsDialog::OnResize(void)
  {
//--- calling the parent class method
   if(!CAppDialog::OnResize())
      return(false);

   return(true);
  }

//+------------------------------------------------------------------+
//| Event handler                                                    |
//| BUTTON SELL                                                      |
//+------------------------------------------------------------------+
void CControlsDialog::vOnClick_Button_START(void)
  {
   if(ExtDialog1.bGetInit() == false)
      {
      
      }   
  clButton_START.Show();
  
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//| BUTTON BUY                                                       |
//+------------------------------------------------------------------+
void CControlsDialog::vOnClick_Button_STOP(void)
  {
      
  }
void CControlsDialog::vOnClick_Button_DEL(void)
  {

  }
// GLOBAL VARIABLES //
CControlsDialog ExtDialog1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {  
aPairs[0][0] = "EURUSD";
aPairs[1][0] = "ERUGBP";
aPairs[2][0] = "EURCHF";
aPairs[3][0] = "EURJPY";
aPairs[4][0] = "EURCAD";
aPairs[5][0] = "EURAUD";
aPairs[6][0] = "GBPUSD";
aPairs[7][0] = "NZDCHF";
aPairs[8][0] = "GBPJPY";
aPairs[9][0] = "GBPCAD";
aPairs[10][0] = "GBPAUD";
aPairs[11][0] = "AUDUSD";
aPairs[12][0] = "AUDCHF";
aPairs[12][0] = "AUDJPY";
aPairs[13][0] = "AUDCAD";
aPairs[14][0] = "CADCHF";
aPairs[15][0] = "CADJPY";
aPairs[16][0] = "USDCHF";
aPairs[17][0] = "USDCAD";
aPairs[18][0] = "USDJPY";
aPairs[19][0] = "NZDUSD";
aPairs[20][0] = "EURNZD";
   ExtDialog1.vSetProfTreasch(0); 
   for(int i=ObjectsTotal(NULL)-1; i>=0; i--)
     {
      string objname = ObjectName(NULL,i);
      string text = ObjectGetString(0,objname,OBJPROP_TEXT); //find the text of the object
      if(text=="Trading Panel")
        {
         return(INIT_SUCCEEDED);
        }
     }

   if(!ExtDialog1.Create(0,"Trading Panel",0,1,1,210,310))  // CREATING THE APPLICATION DIALOG //
      return(-1);
   if(!ExtDialog1.Run())                                  // STARTING THE APPLICATION //
      return(-2);

   ExtDialog1.vSetNB(iNB);
   ExtDialog1.vSetSL(NormalizeDouble(dSL,2));
   ExtDialog1.vSetVOL(dVOL);
   ExtDialog1.vSetTP(dTP);
   ExtDialog1.vSetPairClose1(" ");
   ExtDialog1.vSetPairClose2(" ");
   
   ChartSetInteger(0,CHART_COLOR_BID,clrWhite);
   ChartSetInteger(0,CHART_COLOR_ASK,clrWhite);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrWhite);
   ChartSetInteger(0,CHART_COLOR_GRID,clrWhite);
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);

   return(0);
  }

// CHART EVENT HANDLER //
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   ExtDialog1.ChartEvent(id,lparam,dparam,sparam);        // HANDLING THE EVENT //
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
    MqlDateTime dt_struct;
     datetime dtSer=TimeCurrent(dt_struct);
   
    if(dt_struct.sec >0 &&  dt_struct.sec < 5)
    {
      if(dt_struct.min == 9 || dt_struct.min == 19 || dt_struct.min == 29 || dt_struct.min == 39 || dt_struct.min == 49 || dt_struct.min == 59)
      {
         if(PositionsTotal() == 0)
         {
            dInitAccountValue = AccountInfoDouble(ACCOUNT_EQUITY);
            dAccountValueTarget = dInitAccountValue * 1.1;
         }
         vUpdateSymChange(); // update array with new daily changes
         ArrayPrint(aPairs);
         int iIndMaxChange = vFindBiggestChangeIndex();//finding the index with biggest hange
         bool bPosBiChange = false;
         bool bPosOpened = false;
         if(iIndMaxChange > 0)
         {
            bPosBiChange = bPosHasBiggestDayChange(iIndMaxChange);//freturns true if a position with biggest daily change is open
         }
         if(bPosBiChange != true && iIndMaxChange > 0)//ifposition not opend
         {
            Print("iIndMaxChange ", iIndMaxChange);
          bPosOpened = bOpenBiggestChangePosition(iIndMaxChange);//opens a pos with bigeest daily change pair
         }

         int iIndMinChange = vFindSmallestChangeIndex();
         bool bPosSmChange = false;
         bPosOpened = false;
         if(iIndMinChange > 0)
         {
            bPosSmChange = bPosHasSmallestDayChange(iIndMinChange);
         }
         if(bPosSmChange != true && iIndMinChange > 0)
         {
            bPosOpened = bOpenSmallestChangePosition(iIndMinChange);
         }
      }
      if(PositionsTotal() > 1)
      {
         vCloseOldPos();
      }
    }
    
  }

void vUpdateSymChange()
{
   for(int i = ArrayRange(aPairs, 0)-1; i>=0; i--)
   {
      aPairs[i][1] = 0;
      string sym = aPairs[i][0]; 
      double dAsk = SymbolInfoDouble(sym,SYMBOL_ASK);
      double dBid = SymbolInfoDouble(sym,SYMBOL_BID);
      double dOpen = iOpen(sym, PERIOD_D1,0);
      double dClose = iClose(sym, PERIOD_D1,0);
      
      double dDayChange = (dClose-dOpen)/dOpen;
      aPairs[i][1] =  NormalizeDouble(dDayChange, 5);
      
   }
}
int vFindBiggestChangeIndex()
{
   double dMaxChange    =     0;
   int iIndMaxCh          =     -1;

   for(int i = ArrayRange(aPairs, 0)-1; i>=0; i--)
   {
      if(aPairs[i][1] > dMaxChange)
      {
         dMaxChange = aPairs[i][1];
         iIndMaxCh = i;
      }
   }

   return(iIndMaxCh);
}
int vFindSmallestChangeIndex()
{
   double dMinChange    =     10000;
   int iIndMinCh          =     -1;

   for(int i = ArrayRange(aPairs, 0)-1; i>=0; i--)
   {
      if(aPairs[i][1] < dMinChange)
      {
         dMinChange = aPairs[i][1];
         iIndMinCh = i;
      }
   }

   return(iIndMinCh);
}
bool bPosHasBiggestDayChange(int iIndMaxChange)
{
   for(int v = PositionsTotal()-1; v >= 0; v--)
   {
      ulong position_ticket1 = PositionGetTicket(v);
      if(PositionSelectByTicket(position_ticket1)!= true){continue;}
      string   dPositionSym = PositionGetString(POSITION_SYMBOL);
      if(aPairs[iIndMaxChange][0] == dPositionSym)
      {
         return(true);
      }
   }
   return(false);
}
bool bPosHasSmallestDayChange( int iIndMinChange)
{
   for(int v = PositionsTotal()-1; v >= 0; v--)
   {
      ulong position_ticket1 = PositionGetTicket(v);
      if(PositionSelectByTicket(position_ticket1)!= true){continue;}
      string   dPositionSym = PositionGetString(POSITION_SYMBOL);
      if(aPairs[iIndMinChange][0] == dPositionSym)
      {
         return(true);
      }
   }
   return(false);
}

bool bOpenSmallestChangePosition(int iIndMinChange)
{
   string   sSym     =  aPairs[iIndMinChange][0];
   double   dChange  =  aPairs[iIndMinChange][1];
   double   dAsk = SymbolInfoDouble(sSym,SYMBOL_ASK);
   double   dBid = SymbolInfoDouble(sSym,SYMBOL_BID);
   double   dOpen = iOpen(sSym, PERIOD_D1,0);
   double   dClose = iClose(sSym, PERIOD_D1,0);

   double   dTargetPrice = dOpen*0.99;
   int      iTicksToTarget = (dTargetPrice - dAsk)/SymbolInfoDouble(sSym, SYMBOL_POINT);
   iTicksToTarget = MathAbs(iTicksToTarget);
   double   dCurAccountValue = AccountInfoDouble(ACCOUNT_EQUITY);
   double   dAccountTargetValueToReach = dAccountValueTarget - dCurAccountValue;

   double   dVol = dAccountTargetValueToReach/iTicksToTarget/SymbolInfoDouble(sSym,SYMBOL_TRADE_TICK_VALUE);
   dVol = NormalizeDouble(dVol, 2);
   if(dVol > 5|| dVol == 0)
   {
      return(true);
   }
   bool res = bBuy(sSym, dVol, "God bless");
   return(res);
}
bool bOpenBiggestChangePosition(int iIndMaxChange)
{
   string   sSym     =  aPairs[iIndMaxChange][0];
   double   dChange  =  aPairs[iIndMaxChange][1];
   double   dAsk = SymbolInfoDouble(sSym,SYMBOL_ASK);
   double   dBid = SymbolInfoDouble(sSym,SYMBOL_BID);
   double   dOpen = iOpen(sSym, PERIOD_D1,0);
   double   dClose = iClose(sSym, PERIOD_D1,0);

   double   dTargetPrice = dOpen*1.01;
   int      iTicksToTarget = (dTargetPrice - dAsk)/SymbolInfoDouble(sSym, SYMBOL_POINT);

   double   dCurAccountValue = AccountInfoDouble(ACCOUNT_EQUITY);
   double   dAccountTargetValueToReach = dAccountValueTarget - dCurAccountValue;

   double   dVol = dAccountTargetValueToReach/iTicksToTarget/SymbolInfoDouble(sSym,SYMBOL_TRADE_TICK_VALUE);
   dVol = NormalizeDouble(dVol, 2);
   if(dVol > 5 || dVol == 0)
   {
      return(true);
   }
   bool res = bSell(sSym, dVol, "God bless");
   return(res);
}

bool  bBuy(string sym, double dLot, string commen)
{
   double  dSpread = 0; 
   double  dPrice  = 0;
   double dAsk;
   bool    res   = false;
   
   MqlTradeRequest request={};
   MqlTradeResult  result={};
   if(dLot > 5 || dLot< 0.01)
   {
      return(true);
   }
   do
   {
   MqlTick lastTick;
   if(SymbolInfoTick(sym, lastTick))
      {
         Print("dLot ", dLot);
         request.action   =TRADE_ACTION_DEAL;              
         request.symbol   =sym;                             
         request.volume   =dLot;                              
         request.type     =ORDER_TYPE_BUY;                     
         request.price    =lastTick.ask; 
         request.deviation=5;       
         request.comment = commen;                            
         request.magic    = EXPERT_MAGIC;                      
         res = OrderSend(request,result); 
      }  
   }while(res!= true);
   return(res);
}

void vCloseOldPos()
{
   long  lFirstBiggestPosTicket = 0;
   long  lSecondBiggestPosTicket = 0;

   long  lFirstSmallestPosTicket = 0;
   long  lSecondSmallestPosTicket = 0;
    for(int v = PositionsTotal(); v >= 0; v--)
   {
      ulong position_ticket = PositionGetTicket(v);
      if(PositionSelectByTicket(position_ticket)!= true){continue;}
      
     if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY )
     {
      if(lFirstBiggestPosTicket == 0 )

      {
          lFirstBiggestPosTicket = position_ticket;
      }
      else if(lSecondBiggestPosTicket == 0)
      {
         lSecondBiggestPosTicket = position_ticket;
      }
     }
     else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
     {
         if(lFirstSmallestPosTicket == 0 )
         {
            lFirstSmallestPosTicket = position_ticket;
         }
         else if(lSecondSmallestPosTicket == 0)
         {
             lSecondSmallestPosTicket = position_ticket;
         }
     }
     
   }

   if(lFirstBiggestPosTicket != 0 &&  lSecondBiggestPosTicket != 0)
   {
      if(lFirstBiggestPosTicket < lSecondBiggestPosTicket)
      {
         trade.PositionClose(lFirstBiggestPosTicket, 5);
      }
      if(lFirstBiggestPosTicket > lSecondBiggestPosTicket )
      {
         trade.PositionClose(lSecondBiggestPosTicket, 5);
      }
   }
   if( lFirstSmallestPosTicket != 0 && lSecondSmallestPosTicket != 0 )
   {
      if(lFirstSmallestPosTicket < lSecondSmallestPosTicket)
      {
         trade.PositionClose(lFirstSmallestPosTicket, 5);
      }
      if(lFirstSmallestPosTicket > lSecondSmallestPosTicket)
      {
         trade.PositionClose(lSecondSmallestPosTicket, 5);
      }
   }
}

bool  bSell(string sym, double dLot, string commen)
  {
  
    double  dSpread = 0; 
    double  dPrice  = 0;
    double dBid;
    bool    res   = false;
    MqlTradeRequest request={};
    MqlTradeResult  result={};

    do
    {
      MqlTick lastTick;
      if(SymbolInfoTick(sym, lastTick))
        {
          if(dLot > 5 || dLot< 0.01)
         {
            return(true);
         }
          request.action   =TRADE_ACTION_DEAL;                    
          request.symbol   =sym;                  
          request.volume   =dLot;                 
          request.type     =ORDER_TYPE_SELL;      
          request.price    =lastTick.bid; 
          request.deviation=5;       
          request.comment = commen;       
          request.magic    = EXPERT_MAGIC; 
          res = OrderSend(request,result); 
        }  
      }while(res!= true);
    return(res);
  }