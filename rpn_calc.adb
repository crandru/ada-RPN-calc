-- Name: Chris Rand
-- Date: April 6th, 2018
-- Course: ITEC 320 Procedural Analysis and Design

-- Purpose: This program implements an interactive reverse Polish notation RPN
-- calculator that operates with signed bignums and following ops (+,-,*).
-- Input: A series of signed bignums, operators, and print/pop calls (p/P).
-- Output: The current top of the stack whenever print (p) is called.
-- Example: Text file with following expressions (input/output is mixed)
-- 10
-- 20+p
-- 30 (output)
-- p
-- 30 (output)
-- P
-- 2   6   *   p
-- 12 (output)
-- 9 8 * +
-- raised RPN_CALC.SIGNED_BIGNUM_STACK.STACK_EMPTY (output)

-- Help received: Material from 320 Course page and Ada 2005 Textbook
-- no outside help.
with ada.text_io; use ada.text_io;
with stackpkg, bignumpkg.signed;
use bignumpkg.signed;

procedure rpn_calc is
   package BigNumStackPk is new stackpkg(Size => 100,
      ItemType => Signed_BigNum);
   use BigNumStackPk;

   ----------------------------------------------------------
   -- Purpose: Removes whitespace until valid char reached
   -- Parameters: None
   -- Precondition: File contains valid chars (non whitespace)
   -- Postcondition: Input marker is on valid char
   ----------------------------------------------------------
   procedure find_next is
      c: Character; --holds current character
      eol: Boolean; --identifies end of line
   begin
      loop
         look_ahead(c, eol);
         if eol then
            skip_line;
         elsif c = ' ' then
            get(c);
         else
            exit;
         end if;
      end loop;
   end find_next;

   ----------------------------------------------------------
   -- Purpose: Performs the indicated operation on top 2 stack elements
   -- Parameters: c: char operation (+,-,*), s: stack of signed bignums
   -- Precondition: c is valid operation and s contains >= 2 elements
   -- Postcondition: result of operation placed on s
   ----------------------------------------------------------
   procedure operate(c: Character; s: in out BigNumStackPk.Stack) is
   xNum, yNum, result: Signed_BigNum; --holds signed bignums for calculations
   begin
      yNum := top(s);
      pop(s);
      xNum := top(s);
      pop(s);
      case c is
         when '+' => result := xNum + yNum;
         when '-' => result := xNum - yNum;
         when '*' => result := xNum * yNum;
         when others => null;
      end case;
      push(result, s);
   end operate;

   ----------------------------------------------------------
   -- Purpose: Identifies next action from c and performs it
   -- Parameters: bigNumS: stack of signed bignums, quit: det. if quit
   -- Precondition: next character is valid digit/op/procedure.
   -- Postcondition: character(s) are stored/processed and marker moves past
   ----------------------------------------------------------
   procedure process(bigNumS: in out BigNumStackPk.Stack; quit: out Character) is
   c: Character; --character to identify digit/op/procedure
   eol: Boolean; --end of line boolean to process look_ahead
   sBigNum: Signed_BigNum; --signed bignum to process get if c is digit
   begin
      look_ahead(c, eol);
      quit := ' ';
      if c in '0'..'9' or c = '_' then
         get(sBigNum);
         push(sBigNum, bigNumS);
      elsif c = '+' or c = '-' or c = '*' then
         get(c);
         operate(c, bigNumS);
      elsif c = 'P' then --performs pop operation
         get(c);
         pop(bigNumS);
      elsif c = 'p' then --performs print operation
         get(c);
         put(top(bigNumS));
         new_line;
      else
         quit := c;
      end if;
   end process;

   bNStack: BigNumStackPk.Stack; --stack of signed bignums for processing
   quit: Character := ' '; --char to det. if quit program
begin
   while quit /= 'q' loop
      find_next;
      process(bNStack, quit);
   end loop;

end rpn_calc;