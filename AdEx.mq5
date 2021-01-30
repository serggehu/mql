//+------------------------------------------------------------------+
//|                                                         AdEx.mq5 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include             <Trade\Trade.mqh>
CTrade               trade;

int                  hour_thresch               =      3;
double               cur_trade_prozent;
string               cur_trading_pair;
double               balance_before_trade;
string               last_crossed_pair_1        =     NULL;
string               last_crossed_pair_2        =     NULL;
//+------------------------------------------------------------------+
//|Class CPair                                                       |
//+------------------------------------------------------------------+
class CPair
  {
   string            name;
public:
   string            pair_name;
   double            last_price_change;
   double            cur_price_change;
                     CPair(string abbr);
  };
//+------------------------------------------------------------------+
//|Initialisation objesct of class                                   |
//+------------------------------------------------------------------+
CPair::CPair(string abbr)
  {
   name           =     abbr;
   pair_name      =     abbr;

  }
CPair* PairArr[4];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
//   hour_thresch                     =  3;
                EventSetTimer(1);
   PairArr[0]                       = new CPair("EURUSD");
   PairArr[0].last_price_change     = 0.0;
   PairArr[0].cur_price_change      = 0.0;
   PairArr[1]                       = new CPair("GBPUSD");
   PairArr[1].last_price_change     = 0.0;
   PairArr[1].cur_price_change      = 0.0;
   PairArr[2]                       = new CPair("USDCAD");
   PairArr[2].last_price_change     = 0.0;
   PairArr[2].cur_price_change      = 0.0;
   PairArr[3]                       = new CPair("USDJPY");
   PairArr[3].last_price_change     = 0.0;
   PairArr[3].cur_price_change      = 0.0;

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   MqlDateTime dt_struct;
   datetime dt_Cur = TimeCurrent(dt_struct);
   int hour = dt_struct.hour;
   if(hour>22)
     {
      //      CloseTradeForTheDay();
     }
   UpdatePairLastPriceChange();
   if(hour > hour_thresch && hour<23)
     {

      if(PositionsTotal()<1)
        {
         InitiateTrade();
        }
      else
        {
         CheckCorrectCrossingPair();
         CheckDeleteSparePair();
         CheckCorrectVol();
         CheckBubbleReachedTarget();
        }
     }
  }
//+------------------------------------------------------------------+
bool CheckCorrectCrossingPair()
  {
   for(int a_p = 0; a_p<ArraySize(PairArr); a_p++)
     {
      string   a_p_name          =     PairArr[a_p].pair_name;
      double   cur_price_change  =     PairArr[a_p].cur_price_change;
      double   last_price_change =     PairArr[a_p].last_price_change;
      bool     open_buy_condi_1  =     false;
      bool     open_buy_condi_2  =     false;
      bool     open_buy_condi_3  =     false;
      bool     open_buy_condi_4  =     false;
      //      Print(" cur_price_change ", cur_price_change, " ", last_price_change, " a_p_name ", a_p_name);
      if(a_p_name == cur_trading_pair)
         continue;
      if(cur_price_change>last_price_change)
         open_buy_condi_1=true;
      if(cur_price_change==cur_trade_prozent && last_price_change<cur_trade_prozent)
         open_buy_condi_2=true;
      if(cur_price_change>cur_trade_prozent && last_price_change<cur_trade_prozent)
         open_buy_condi_3 = true;
      if(cur_price_change>cur_trade_prozent && last_price_change==cur_trade_prozent)
         open_buy_condi_4 = true;

      /*      if(open_buy_condi_1 && (open_buy_condi_2 || open_buy_condi_3
                                    || open_buy_condi_4))*/
      if(open_buy_condi_2 || open_buy_condi_3
         || open_buy_condi_4)
        {
         Print(" a_p_name ", a_p_name, " last_crossed_pair_1 ",last_crossed_pair_1);
         if(a_p_name == last_crossed_pair_1)
            return(true);
         double price = SymbolInfoDouble(a_p_name,SYMBOL_ASK);
         trade.Buy(0.02, a_p_name, price, 0, 0, NULL);
         cur_trading_pair=a_p_name;
         return(true);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
bool InitiateTrade()
  {
   for(int a_p = 0; a_p<ArraySize(PairArr); a_p++)
     {
      string   a_p_name          =  PairArr[a_p].pair_name;
      double   cur_price_change  =  PairArr[a_p].cur_price_change;
      double   last_price_change =  PairArr[a_p].last_price_change;
      bool     open_buy_condi_1  =  false;
      bool     open_buy_condi_2  =  false;
      bool     open_buy_condi_3  =  false;
      bool     open_buy_condi_4  =  false;
      if(cur_price_change==0 || last_price_change==0)
         continue;
      if(cur_price_change>last_price_change)
         open_buy_condi_1=true;
      if(cur_price_change==0.0 && last_price_change<0.0)
         open_buy_condi_2=true;
      if(cur_price_change>0.0 && last_price_change<0.0)
         open_buy_condi_3 = true;
      if(cur_price_change>0.0 && last_price_change==0.0)
         open_buy_condi_4 = true;
      if(open_buy_condi_1 && (open_buy_condi_2 || open_buy_condi_3
                              || open_buy_condi_4))
        {
         balance_before_trade=AccountInfoDouble(ACCOUNT_BALANCE);
         double price = SymbolInfoDouble(a_p_name,SYMBOL_ASK);
         trade.Buy(0.01, a_p_name, price, 0, 0, NULL);
         cur_trading_pair=a_p_name;
         return(true);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
bool UpdatePairLastPriceChange()
  {
   for(int a_p = 0; a_p<ArraySize(PairArr); a_p++)
     {
      string a_p_name      =     PairArr[a_p].pair_name;
      double Prozent       =     0;
      PairArr[a_p].last_price_change = PairArr[a_p].cur_price_change;
      if(iClose(a_p_name,PERIOD_W1,0)!=0 && iClose(a_p_name,PERIOD_W1,1)!=0
         && iClose(a_p_name,PERIOD_W1,1) !=0)
        {
         Prozent=NormalizeDouble((((iClose(a_p_name,PERIOD_W1,0)
                                    -iClose(a_p_name,PERIOD_W1,1))
                                   /iClose(a_p_name,PERIOD_W1,1))*100),4);
        }
      PairArr[a_p].cur_price_change = Prozent;
      if(PairArr[a_p].pair_name == cur_trading_pair)
         cur_trade_prozent = PairArr[a_p].cur_price_change;
     }
   string comm0 = PairArr[0].pair_name +" "+ DoubleToString(PairArr[0].cur_price_change);
   string comm1 = PairArr[1].pair_name +" "+ DoubleToString(PairArr[1].cur_price_change);
   string comm2 = PairArr[2].pair_name +" "+ DoubleToString(PairArr[2].cur_price_change);
   string comm3 = PairArr[3].pair_name +" "+ DoubleToString(PairArr[3].cur_price_change);
   Comment(comm0, "\n",comm1, "\n",comm2, "\n",comm3, "\n");

   return(true);
  }
//+------------------------------------------------------------------+
bool CheckDeleteSparePair()
  {
   for(int p =0; p< PositionsTotal(); p++)
     {
      ulong p_tick = PositionGetTicket(p);
      string p_name = PositionGetSymbol(p);
      if(p_name != cur_trading_pair)
        {
         PositionSelectByTicket(p_tick);
         trade.PositionClose(p_tick, 10);
         //         last_crossed_pair_2 = last_crossed_pair_1;
         last_crossed_pair_1 = p_name;
         Print("last crossed pair changed", last_crossed_pair_1);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
bool CheckCorrectVol()
  {
   double cur_pips   = SymbolInfoDouble(cur_trading_pair,SYMBOL_BID)
                       -iClose(cur_trading_pair,PERIOD_W1,1);
   double tick_value = SymbolInfoDouble(cur_trading_pair,SYMBOL_TRADE_TICK_VALUE);
   double point     = SymbolInfoDouble(cur_trading_pair, SYMBOL_POINT);
   double prof_on_init_vol = cur_pips/point*tick_value*0.01;
   //Comment(" prof_on_init_vol ", prof_on_init_vol);
   if(AccountInfoDouble(ACCOUNT_EQUITY)>prof_on_init_vol+balance_before_trade)
     {
      for(int p = 0; p< PositionsTotal(); p++)
        {
         ulong    p_tick   =  PositionGetTicket(p);
         double   vol      =  PositionGetDouble(POSITION_VOLUME);
         if(vol<0.02)
            return(true);
         trade.PositionClosePartial(p_tick, 0.01, 0);
         return(true);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
bool CheckBubbleReachedTarget()
  {
   string    highest_pair=NULL;
   double    highest_percent=0;
   for(int a_p=0; a_p<ArraySize(PairArr); a_p++)
     {
      if(PairArr[a_p].cur_price_change>highest_percent)
        {
         highest_pair=PairArr[a_p].pair_name;
         highest_percent = PairArr[a_p].cur_price_change;
        }
     }
   if(cur_trading_pair == highest_pair)
     {
      PositionSelect(highest_pair);
      if(PositionGetDouble(POSITION_VOLUME)<0.02
         && PositionGetDouble(POSITION_PROFIT)>3)
        {
         trade.PositionClose(highest_pair, 1);
         Print("TRADE CLOSED AS HIGHEST IST REACHED");
         last_crossed_pair_1 = NULL;
         last_crossed_pair_2 = NULL;
        }
     }

   return(true);
  }
//+------------------------------------------------------------------+
bool CloseTradeForTheDay()
  {
   for(int p=0; p<PositionsTotal(); p++)
     {
      ulong p_tick   =  PositionGetTicket(p);
      trade.PositionClose(p_tick, 1);
      last_crossed_pair_1 = NULL;
      last_crossed_pair_2 = NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
