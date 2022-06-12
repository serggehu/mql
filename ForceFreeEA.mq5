//+------------------------------------------------------------------+
//|                                                  ForceFreeEA.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"


#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\SpinEdit.mqh>
#include <Controls\Button.mqh>
#include <Controls\ComboBox.mqh>

// INPUT //
input int iNB=1;              //NB TRADES
input double dSL=50;           //NB PIPS SELL_SL
input double dVOL=0.1;       //VOLUME
input double dTP=10;          //NB PIPS SELL_TP

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
/*  enum                currencies
  {
    USD,
    EUR,
    GBP,
    JPY,
    CHF,
    CAD,
    AUD
  };
  enum USD
  {
    EURUSD            = 0,
    GBPUSD            = 1,
    USDCHF            = 0,
    USDJPY            = 1,
    AUDUSD            = 1,
    USDCAD            = 1
  };
  enum EUR
  {
    EURUSD            = 1,
    EURCHF            = 0,
    EURAUD            = 1,
    EURJPY            = 0,
    EURGBP            = 1,
    EURCAD            = 0
  };

    enum GBP
  {
    EURGBP            = 0,
    GBPUSD            = 0,
    GBPCHF            = 1,
    GBPJPY            = 0,
    GBPAUD            = 0,
    GBPCAD            = 1
  };
    enum JPY
  {
    USDJPY            = 0,
    GBPJPY            = 1,
    CHFJPY            = 0,
    EURJPY            = 1,
    AUDJPY            = 0,
    CADJPY            = 1
  };
    enum CHF
  {
    EURCHF            = 1,
    GBPCHF            = 0,
    USDCHF            = 1,
    CHFJPY            = 1,
    AUDCHF            = 1,
    CADCHF            = 0
  };
    enum CAD
  {
    EURCAD            = 1,
    GBPCAD            = 0,
    CADJPY            = 0,
    CADCHF            = 1,
    AUDCAD            = 0,
    USDCAD            = 0
  };
  enum AUD
  {
    EURAUD            = 0,
    GBPAUD            = 1,
    AUDCHF            = 0,
    AUDJPY            = 1,
    AUDUSD            = 0,
    AUDCAD            = 1
  };*/

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
   /*   if(ExtDialog1.bGetInit() == false)
      {
        double dVol = (double)ObjectGetString(0,m_name+"Edit_VOL",OBJPROP_TEXT);
        double dThr = (double)ObjectGetString(0,m_name+"Edit_SL",OBJPROP_TEXT);
        vInitiateTrade(dVol);

        ExtDialog1.vSetInit(true);
        ExtDialog1.vSetIntPaTh(dThr);
        
      }
  
   clButton_START.Show();*/
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//| BUTTON BUY                                                       |
//+------------------------------------------------------------------+
void CControlsDialog::vOnClick_Button_STOP(void)
  {
      bool pos_mod;

  }
void CControlsDialog::vOnClick_Button_DEL(void)
  {
     double dtp = (double)ObjectGetString(0,m_name+"Edit_TP",OBJPROP_TEXT);

  }
// GLOBAL VARIABLES //
CControlsDialog ExtDialog1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

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
     if(ExtDialog1.bGetInit() == false)
      {
   //   double dVol = (double)ObjectGetString(0,m_name+"Edit_VOL",OBJPROP_TEXT);
   //   double dThr = (double)ObjectGetString(0,m_name+"Edit_SL",OBJPROP_TEXT);
      ExtDialog1.vSetIntPaTh(50);
        vInitiateTrade(0.1);
        ExtDialog1.vSetInit(true);
      }

    if(ExtDialog1.bGetInit()==false){return;}

//    bcheckProfitablePair("EUR");
    bcheckProfitablePair("USD");
/*    bcheckProfitablePair("GBP");
    bcheckProfitablePair("CHF");
    bcheckProfitablePair("JPY");
    bcheckProfitablePair("CAD");
    bcheckProfitablePair("AUD"); */

    bCheckDoubledPos("USD");
    
  }

  void vInitiateTrade(double dVol)
  {
    double dLot =0 ;
    bool   res;
    string sym;

    sym = "EURUSD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "EUR");
    bSell( sym,  dLot, "USD"); 

    sym = "GBPUSD";
    dLot = dCalcLot(sym, dVol);
    bBuy( sym,  dLot, "USD");
//    bSell( sym,  dLot, "GBP");

    sym = "USDCHF";
    dLot = dCalcLot(sym, dVol);
    bBuy( sym,  dLot, "USD");
//    bSell( sym,  dLot, "CHF");//++++++++++++++++++++++++++++++++

    sym = "USDJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "JPY");
    bSell( sym,  dLot, "USD");
    sym = "AUDUSD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "AUD");
    bSell( sym,  dLot, "USD");

    sym = "USDCAD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "CAD");
    bSell( sym,  dLot, "USD");

    sym = "EURCHF";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "EUR"); 
 //   bSell( sym,  dLot, "CHF");//+++++++++++++++++++++++++++++++++++++

    sym = "EURAUD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "AUD");
//    bSell( sym,  dLot, "EUR");

    sym = "EURJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "EUR");
//    bSell( sym,  dLot, "JPY");

    sym = "EURGBP";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "GBP");
//    bSell( sym,  dLot, "EUR");

    sym = "EURCAD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "EUR");
//    bSell( sym,  dLot, "CAD");

    sym = "GBPCHF";
    dLot = dCalcLot(sym, dVol);
 //   bBuy( sym,  dLot, "CHF");//---------------------------------------
//    bSell( sym,  dLot, "GBP");

    sym = "GBPJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "GBP");
//    bSell( sym,  dLot, "JPY");

    sym = "GBPAUD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "GBP");
//    bSell( sym,  dLot, "AUD");

    sym = "GBPCAD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "GBP");
//    bSell( sym,  dLot, "CAD");

    sym = "CHFJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "CHF");//+++++++++++++++++++++++++++++++++++++++++
//    bSell( sym,  dLot, "JPY");

    sym = "AUDJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "JPY");
//    bSell( sym,  dLot, "AUD");

    sym = "CADJPY";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "CAD");
//    bSell( sym,  dLot, "JPY");

    sym = "AUDCHF";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "AUD");
//    bSell( sym,  dLot, "CHF");//+++++++++++++++++++++++++++++++++++++++++

    sym = "CADCHF";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "CHF");//---------------------------------------
//    bSell( sym,  dLot, "CAD");

    sym = "AUDCAD";
    dLot = dCalcLot(sym, dVol);
//    bBuy( sym,  dLot, "CAD");
//    bSell( sym,  dLot, "AUD");   

    ExtDialog1.vSetInit(true);
  }
  double dCalcLot(string sym, double dVol)
  {
    double res = 0;
    if(sym == "EURUSD" || sym == "EURGBP" || sym == "EURJPY" || sym == "EURCHF" || sym == "EURCAD" || sym == "EURAUD" )
    {
      res = dVol/SymbolInfoDouble("EURUSD", SYMBOL_ASK);
    }
    else if (sym == "GBPUSD" || sym == "GBPCAD" || sym == "GBPCHF" || sym == "GBPJPY" || sym == "GBPAUD")
    {
      res = dVol/SymbolInfoDouble("GBPUSD", SYMBOL_ASK);
    }
        else if (sym == "AUDCAD" || sym == "AUDCHF" || sym == "AUDUSD" || sym == "AUDJPY")
    {
      res = dVol/SymbolInfoDouble("AUDUSD", SYMBOL_ASK);
    }
    else if (sym == "CADCHF" || sym == "CADJPY")
    {
      res = dVol*SymbolInfoDouble("USDCAD", SYMBOL_ASK);
    }
    else if (sym == "USDCAD" || sym == "USDCHF" || sym == "USDJPY")
    {
      res = dVol;
    }
    else if (sym == "CHFJPY")
    {
      res = dVol*SymbolInfoDouble("USDCHF", SYMBOL_ASK);
    }
    res = NormalizeDouble(res, 2);
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
    
    do
    {
      MqlTick lastTick;
      if(SymbolInfoTick(sym, lastTick))
        {
          
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
  bool  bBuyLimit(string sym, double dLot, string commen)
  {
    double  dSpread = 0; 
    double  dPrice  = 0;
    double dAsk;
    bool    res   = false;
    
    MqlTradeRequest request={};
    MqlTradeResult  result={};
    
    do
    {
      MqlTick lastTick;
      if(SymbolInfoTick(sym, lastTick))
        {
          
          request.action   =TRADE_ACTION_PENDING;              
          request.symbol   =sym;                             
          request.volume   =dLot;                              
          request.type     =ORDER_TYPE_BUY_LIMIT;                     
          request.price    =lastTick.ask; 
          request.deviation=5;       
          request.comment = commen;                            
          request.magic    = EXPERT_MAGIC;                      
          res = OrderSend(request,result); 
        }  
      }while(res!= true);
    return(res);
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
bool  bSellLimit(string sym, double dLot, string commen)
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
         
         request.action   =TRADE_ACTION_PENDING;                    
         request.symbol   =sym;                  
         request.volume   =dLot;                 
         request.type     =ORDER_TYPE_SELL_LIMIT;      
         request.price    =lastTick.bid; 
         request.deviation=5;       
         request.comment = commen;       
         request.magic    = EXPERT_MAGIC; 
         res = OrderSend(request,result); 
      }  
   }while(res!= true);
   return(res);
}

  bool MyOrderSend(MqlTradeRequest &request,MqlTradeResult &result)

  {

   ResetLastError();

   bool success=OrderSend(request,result);


      int answer=result.retcode;
      Print("TradeLog: Trade request failed. Error = ",GetLastError());
      switch(answer)
        {

         case 10004:
           {
            Print("TRADE_RETCODE_REQUOTE");
            Print("request.price = ",request.price,"   result.ask = ",
                  result.ask," result.bid = ",result.bid);
            return(false);
            break;
           }
         case 10006:
           {
            Print("TRADE_RETCODE_REJECT");
            Print("request.price = ",request.price,"   result.ask = ",
                  result.ask," result.bid = ",result.bid);
            return(false);
            break;
           }
         case 10015:
           {
            Print("TRADE_RETCODE_INVALID_PRICE");
            Print("request.price = ",request.price,"   result.ask = ",
                  result.ask," result.bid = ",result.bid);
            return(false);
            break;
           }
         case 10016:
           {
            Print("TRADE_RETCODE_INVALID_STOPS");
            Print("request.sl = ",request.sl," request.tp = ",request.tp);
            Print("result.ask = ",result.ask," result.bid = ",result.bid);
            return(false);
            break;
           }
         case 10014:
           {
            Print("TRADE_RETCODE_INVALID_VOLUME");
            Print("request.volume = ",request.volume,"   result.volume = ",
                  result.volume);
            return(false);
            break;
           } 
         case 10019:
           {
            Print("TRADE_RETCODE_NO_MONEY");
            Print("request.volume = ",request.volume,"   result.volume = ",
                  result.volume,"   result.comment = ",result.comment);
            return(false);
            break;
           } 
         default:
           {
            Print("Other answer = ",answer);
           return(false);
           }
      }
   return(true);
  }

void  bcheckProfitablePair(string comm)
{
  double aBaseUp[6][3];
  double aBaseDo[6][3];

  long   aBaseUpInd[6];
  long   aBaseDoInd[6];

  int     posTot=PositionsTotal();
  int     indUp = 0;
  int     indDo = 0;
  for(int i = posTot; i>=0; i--)
  {
    ulong position_ticket = PositionGetTicket(i);
    ulong magic = PositionGetInteger(POSITION_MAGIC);
    if(PositionSelectByTicket(position_ticket))
    {
      if(PositionGetString(POSITION_COMMENT) == comm)
      {
        string sPosName = PositionGetString(POSITION_SYMBOL);
        string sPosBase = SymbolInfoString(sPosName, SYMBOL_CURRENCY_BASE);
        if(comm == sPosBase)
        {
          if(PositionGetInteger(POSITION_TYPE) == 0)
          {
              aBaseUp[indUp][0] = PositionGetDouble(POSITION_PROFIT);
              aBaseUpInd[indUp] = position_ticket;
              aBaseUp[indUp][2] = 0;
              indUp+=1;
          }
          else if(PositionGetInteger(POSITION_TYPE) == 1)
          {
            aBaseDo[indDo][0] = PositionGetDouble(POSITION_PROFIT);
            aBaseDoInd[indDo] = position_ticket;
            aBaseDo[indDo][2] = 1;
            indDo+=1;
          }
        }
        else if(comm != sPosBase)
        {
          if(PositionGetInteger(POSITION_TYPE) == 0)
          {
            aBaseDo[indDo][0] = PositionGetDouble(POSITION_PROFIT);
            aBaseDoInd[indDo] = position_ticket;
            aBaseDo[indDo][2] = 0;
            indDo+=1;
          }
          else if(PositionGetInteger(POSITION_TYPE) == 1)
          {
            aBaseUp[indUp][0] = PositionGetDouble(POSITION_PROFIT);
            aBaseUpInd[indUp] = position_ticket;
            aBaseUp[indUp][2] = 1;
            indUp+=1;
          }
        }
      }
    }
  }
  double  dBigUpPr = -10000;
  double  dBigDoPr = -10000;
  double  dBigUpLot  =  0;
  double  dBigDoLot  =  0;
  ulong   dBigUpInd = 0;
  ulong   dBigDoInd = 0;
  int     dBigUpDir = 99;
  int     dBigDoDir = 99;
  for(int i = 5; i>=0; i--)
  {
    if(aBaseUp[i][0] > dBigUpPr)
    {
      dBigUpPr = aBaseUp[i][0];
      dBigUpInd  = aBaseUpInd[i];
      dBigUpDir  = aBaseUp[i][2];
    }
    if(aBaseDo[i][0] > dBigDoPr)
    {
      dBigDoPr = aBaseDo[i][0];
      dBigDoInd  = aBaseDoInd[i];
      dBigDoDir  = aBaseDo[i][2];
    }

      aBaseUp[i][0] = -1000;
      aBaseUp[i][1] = -1000;
      aBaseUp[i][2] = -1000;
      aBaseUpInd[i]  = -1000;

      aBaseDo[i][0] = -1000;
      aBaseDo[i][1] = -1000;
      aBaseDo[i][2] = -1000;
      aBaseDoInd[i]  = -1000;
  }
  string symBigUp = " ";
  string symBigDo = " ";
  string commUp = " ";
  string commDo = " ";
   
  if(dBigUpPr + dBigDoPr > 50)
  {
    if(PositionSelectByTicket(dBigUpInd))
    {
      symBigUp = PositionGetString(POSITION_SYMBOL);
      commUp = PositionGetString(POSITION_COMMENT);
      dBigUpLot = PositionGetDouble(POSITION_VOLUME);
    }
    if(PositionSelectByTicket(dBigDoInd))
    {
      symBigDo = PositionGetString(POSITION_SYMBOL);
      commDo = PositionGetString(POSITION_COMMENT);
      dBigDoLot = PositionGetDouble(POSITION_VOLUME);
    }
    if(symBigUp !=" " && symBigDo !=" ")
    {
//      dLot = dCalcLot(symBigUp, dVol);
      if(dBigUpDir == 0)
      {
         if(bCheckPenidngOrder( symBigUp,  dBigUpLot*2, commUp)==true)return;
         bSellLimit( symBigUp,  dBigUpLot*2, commUp);
         Sleep(500);
   //      ExtDialog1.vSetPairClose1(symBigUp);

         }
      else if(dBigUpDir == 1)
      {
         if(bCheckPenidngOrder(symBigUp,  dBigUpLot*2, commUp) == true)return;
         bBuyLimit( symBigUp,  dBigUpLot*2, commUp);
         Sleep(500);
   //      ExtDialog1.vSetPairClose1(symBigUp);
      }

//      dLot = dCalcLot(symBigDo, dVol);
      if(dBigDoDir == 0)
      {
         if(bCheckPenidngOrder(symBigDo,  dBigDoLot*2, commDo) == true)return;
         bSellLimit( symBigDo,  dBigDoLot*2, commDo);
         Sleep(500);
   //      ExtDialog1.vSetPairClose2(symBigDo);
      }
      else if(dBigDoDir == 1)
      {
         if(bCheckPenidngOrder(symBigDo,  dBigDoLot*2, commDo) == true)return;
         bBuyLimit( symBigDo,  dBigDoLot*2, commDo);
         Sleep(500);
   //      ExtDialog1.vSetPairClose2(symBigDo);
      }
    }
  }
}
bool bCheckDoubledPos(string comm)
{
   ulong lPosTicketB1 =  0;
   ulong lPosTicketB2 =  0;
   ulong lPosTicketS1 =  0;
   ulong lPosTicketS2 =  0;
/*   if(ExtDialog1.sGetPairClose1() == " " && ExtDialog1.sGetPairClose2() == " ")
   {
      return(true);
   }*/
   for(int v = PositionsTotal(); v >= 0; v--)
   {
      ulong position_ticket1 = PositionGetTicket(v);
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      
      if(PositionSelectByTicket(position_ticket1)!= true){continue;}
      int iPositionType1 = PositionGetInteger(POSITION_TYPE);
      string   dPositionSym1 = PositionGetString(POSITION_SYMBOL);
      double dPositionLot1 = PositionGetDouble(POSITION_VOLUME);
      if(PositionGetString(POSITION_COMMENT) != comm){continue;}
      
      for(int w = PositionsTotal(); w >= 0; w--)
      {
         ulong position_ticket2 = PositionGetTicket(w);
         if(PositionSelectByTicket(position_ticket2)!=true){continue;}
         if(PositionGetString(POSITION_COMMENT) != comm){continue;}
         if(position_ticket2 == position_ticket1)continue;
         int iPositionType2 = PositionGetInteger(POSITION_TYPE);
         string   dPositionSym2 = PositionGetString(POSITION_SYMBOL);
         double dPositionLot2 = PositionGetDouble(POSITION_VOLUME);
         if(dPositionSym1 == dPositionSym2)
         {
            Print("next");
            Print(dPositionSym2 , " ", position_ticket1 , " ", dPositionLot1);
            Print(dPositionSym2 , " ",position_ticket2,  " ", dPositionLot2);
            trade.PositionCloseBy(position_ticket1, position_ticket2);
         }
      }


   

   /*   if(PositionSelectByTicket(position_ticket))
      {
         if(PositionGetString(POSITION_COMMENT) != comm){continue;}
         if(PositionGetInteger(POSITION_TYPE) == 0)
         {
            if(lPosTicketB1 == 0){lPosTicketB1 = position_ticket;}
            else if(lPosTicketB2 == 0 && position_ticket != lPosTicketB1)
            {
               lPosTicketB2 = position_ticket;
            }            
         }
         if(PositionGetInteger(POSITION_TYPE) == 1)
         {
            if(lPosTicketS1 == 0){lPosTicketS1 = position_ticket;}
            else if(lPosTicketS2 == 0 && position_ticket != lPosTicketS1)
            {
               lPosTicketS2 = position_ticket;
            }            
         }
      }
   }
      ulong tempVarTick = 0;
      if(lPosTicketB1 != 0 && lPosTicketB2 != 0)
      {
         if (lPosTicketB1 > lPosTicketB2)
         {
            tempVarTick = lPosTicketB1;
            lPosTicketB1 = lPosTicketB2;
            lPosTicketB2 = tempVarTick;
         }
         trade.PositionCloseBy(lPosTicketB1, lPosTicketB2);
      }
      tempVarTick = 0;
      if(lPosTicketS1 > 0 && lPosTicketS2 > 0)
      {
         if (lPosTicketS1 > lPosTicketS2)
         {
            tempVarTick = lPosTicketS1;
            lPosTicketS1 = lPosTicketS2;
            lPosTicketS2 = tempVarTick;
         }
         Print("PositionCloseBy");
         bool res = false;
         res = trade.PositionCloseBy(lPosTicketS1, lPosTicketS2);
         Print("res", res);
      }*/
   }
   return(true);
}

bool bCheckPenidngOrder(string sym,  double lot, string comm)
{
   int posTot = PositionsTotal();
   string sSymPos = " ";
   string sCommPos = " ";
   double dLotPos = 0;
   for(int i = posTot; i>=0; i--)
   {
      ulong position_ticket = PositionGetTicket(i);
   //   ulong magic = PositionGetInteger(POSITION_MAGIC);
      if(PositionSelectByTicket(position_ticket))
      {
         sSymPos = PositionGetString(POSITION_SYMBOL);
         sCommPos = PositionGetString(POSITION_COMMENT);
         dLotPos = PositionGetDouble(POSITION_VOLUME);
         if(sym == sSymPos && lot == dLotPos && comm == sCommPos)
         {
            return(true);
         }
      }
  }
  return(false);
}
