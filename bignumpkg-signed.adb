-- Name: Chris Rand
-- Date: 4/6/2018
-- Course: ITEC 320 Procedural Analysis and Design

-- Implementation of Signed Bignums data type, which supports
-- arithmetic with VERY LARGE natural values AND represents
-- the range pos 0..49 and neg 0..49 (50 digits 49999......)

with Ada.Text_IO; use Ada.Text_IO;

package body BigNumPkg.Signed is
   negConstant: Constant Signed_Bignum := (0 => 5, others => 0); --rep. neg 0
   posZero: Constant Signed_Bignum := (others => 0); --rep. pos 0
   ninesComp: Constant BigNum := (others => 9); --bignum for ninesC function

   ----------------------------------------------------------
   -- Purpose: Converts signed bignum to string without leading 0s
   -- Parameters: X: signed bignum to convert
   -- Precondition: X is a valid signed bignum
   -- Postcondition: returns the string representation of X
   ----------------------------------------------------------
   function toString(X: Signed_BigNum) return String is
      negatedNum: Signed_BigNum := X; --negated X for printing X as "-X"
   begin
      if X(0) >= 5 then
         negatedNum(0) := negatedNum(0) - 5;
         return "-" & toString(BigNum(negatedNum));
      else
         return toString(BigNum(X));
      end if;
   end toString;

   ----------------------------------------------------------
   -- Purpose: Calculates the nines compliment of X
   -- Parameters: X: signed bignum to convert
   -- Precondition: X is a valid signed bignum
   -- Postcondition: returns the nines compliment of X
   ----------------------------------------------------------
   function ninesC(X: Signed_BigNum) return BigNum is
      nC: BigNum := ninesComp; --holds value of nines compliment constant
   begin
	for i in 0..Size-1 loop
	   nC(i) := nC(i) - X(i);
	end loop;
	return nC;
   end ninesC;

   ----------------------------------------------------------
   -- Purpose: Determines if X is less than Y
   -- Parameters: X,Y: signed bignums to compare
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns boolean of < truth value
   ----------------------------------------------------------
   function "<"  (X, Y : Signed_BigNum) return Boolean is
   begin
      if X(0) < 5 and Y(0) < 5 then
	   if X = posZero and Y = posZero then
		return false;
	   else
		return (BigNum(X) < BigNum(Y));
	   end if;
      elsif X(0) >= 5 and Y(0) >= 5 then
	   if X = negConstant and Y = negConstant then
		return false;
	   else
		return (BigNum(X) > BigNum(Y));
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   if X = posZero and Y = negConstant then --neg 0 = pos 0
		return false;
	   else
		return false;
	   end if;
      else
	   if X = negConstant and Y = posZero then --neg 0 = pos 0
		return false;
	   else
		return true;
     	   end if;
	end if;
   end "<";

   ----------------------------------------------------------
   -- Purpose: Determines if X is greater than Y
   -- Parameters: X,Y: signed bignums to compare
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns boolean of > truth value
   ----------------------------------------------------------
   function ">"  (X, Y : Signed_BigNum) return Boolean is
   begin
      if X(0) < 5 and Y(0) < 5 then
	   if X = posZero and Y = posZero then
		return false;
	   else
		return (BigNum(X) > BigNum(Y));
     	   end if;
	elsif X(0) >= 5 and Y(0) >= 5 then
     	   if X = negConstant and Y = negConstant then
		return false;
	   else
		return (BigNum(X) < BigNum(Y));
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   if X = posZero and Y = negConstant then --neg 0 = pos 0
		return false;
	   else
		return true;
         end if;
      else
     	   return false;
	end if;
   end ">";

   ----------------------------------------------------------
   -- Purpose: Determines if X is less than/equal to Y
   -- Parameters: X,Y: signed bignums to compare
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns boolean of <= truth value
   ----------------------------------------------------------
   function "<=" (X, Y : Signed_BigNum) return Boolean is
   begin
      if X(0) < 5 and Y(0) < 5 then
	   if X = posZero and Y = posZero then
		return true;
	   else
		return (BigNum(X) <= BigNum(Y));
	   end if;
	elsif X(0) >= 5 and Y(0) >= 5 then
	   if X = negConstant and Y = negConstant then
		return true;
	   else
		return (X < Y or X = Y);
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   if X = posZero and Y = negConstant then --neg 0 = pos 0
		return true;
	   else
		return false;
	   end if;
      else
	   if X = negConstant and Y = posZero then --neg 0 = pos 0
		return true;
	   else
		return true;
	   end if;
	end if;
   end "<=";

   ----------------------------------------------------------
   -- Purpose: Determines if X is greater than/equal to Y
   -- Parameters: X,Y: signed bignums to compare
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns boolean of >= truth value
   ----------------------------------------------------------
   function ">=" (X, Y : Signed_BigNum) return Boolean is
   begin
      if X(0) < 5 and Y(0) < 5 then
	   if X = posZero and Y = posZero then
		return true;
	   else
		return (BigNum(X) >= BigNum(Y));
	   end if;
	elsif X(0) >= 5 and Y(0) >= 5 then
	   if X = negConstant and Y = negConstant then
		return true;
	   else
		return (BigNum(X) <= BigNum(Y));
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   if X = posZero and Y = negConstant then
		return true;
	   else
		return true;
	   end if;
      else
	   if X = negConstant and Y = posZero then
		return true;
	   else
		return false;
	   end if;
	end if;
   end ">=";

   ----------------------------------------------------------
   -- Purpose: Negates X
   -- Parameters: X: signed bignum to negate
   -- Precondition: X is valid signed bignum
   -- Postcondition: returns the negated value of X
   ----------------------------------------------------------
   function negate (X : Signed_BigNum) return Signed_BigNum is
   negatedNum: Signed_BigNum; --holds negated value of X
   begin
      if X(0) < 5 then
   	   negatedNum := Signed_BigNum(BigNum(X) + BigNum(negConstant));
	else
   	   negatedNum := X;
	   negatedNum(0) := negatedNum(0) - 5;
	end if;
      return negatedNum;
   end negate;

   ----------------------------------------------------------
   -- Purpose: Calculates absolute value of X
   -- Parameters: X: signed bignum to get absolute val
   -- Precondition: X is valid signed bignum
   -- Postcondition: returns the absolute value of X
   ----------------------------------------------------------
   function abs_val (X : Signed_BigNum) return Signed_BigNum is
   absNum: Signed_BigNum := X; --holds absolute value of X
   begin
      if X(0) >= 5 then
         absNum(0) := absNum(0) - 5;
      end if;
      return absNum;
   end abs_val;

   ----------------------------------------------------------
   -- Purpose: Adds two signed bignums
   -- Parameters: X,Y: signed bignums to add
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns the sum of X,Y or overflows
   ----------------------------------------------------------
   function "+" (X, Y : Signed_BigNum) return Signed_BigNum is
   sum: Signed_BigNum; --holds the sum of X and Y
   begin
      if X(0) < 5 and Y(0) < 5 then
	   sum := Signed_BigNum(BigNum(X) + BigNum(Y));
	   if sum(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
   	   sum := X - negate(Y);
	elsif X(0) >= 5 and Y(0) < 5 then
	   sum := Y - negate(X);
	else
	   sum := Signed_BigNum(BigNum(abs_val(X) + abs_val(Y))
		+ BigNum(negConstant));
	end if;
      return sum;
   end "+";

   ----------------------------------------------------------
   -- Purpose: Subtracts two signed bignums
   -- Parameters: X,Y: signed bignums to subtract
   -- Precondition: X,Y are valid bignums
   -- Postcondition: returns the result of X - Y
   ----------------------------------------------------------
   function "-" (X, Y : Signed_BigNum) return Signed_BigNum is
   sum: Signed_BigNum; --result of X - Y
   bigSum: BigNum; --bignum sum to pass to plus_ov
   overflow: Boolean; --whether operation overflows
   xNeg: Signed_BigNum := negate(X); --negated x for neg - neg cases
   yNeg: Signed_BigNum := negate(Y); --negated y for neg - neg cases
   begin
	if X(0) < 5 and Y(0) < 5 then
	   plus_ov(BigNum(X),ninesC(Y),bigSum,overflow);
   	   if overflow = true then
		sum := Signed_BigNum(One) + Signed_BigNum(bigSum);
	   else
		sum := negate(Signed_BigNum(ninesC(Signed_BigNum(bigSum))));
         end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   sum := X + abs_val(Y);
	   if sum(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	elsif X(0) >= 5 and Y(0) < 5 then
	   sum := negate(abs_val(X) + abs_val(Y));
	else
	   if xNeg > yNeg then
	      sum := xNeg - yNeg;
	   elsif xNeg < yNeg then
	      sum := yNeg - xNeg;
	   else
		sum := posZero;
	   end if;
	end if;
      return sum;
   end "-";

   ----------------------------------------------------------
   -- Purpose: Multiplies two signed bignums
   -- Parameters: X,Y: signed bignums to multiply
   -- Precondition: X,Y are valid signed bignums
   -- Postcondition: returns the product of X and Y
   ----------------------------------------------------------
   function "*" (X, Y : Signed_BigNum) return Signed_BigNum is
   product: Signed_BigNum; --holds the product of X and Y
   xNeg: BigNum := BigNum(X); --negated value of X for neg * neg
   yNeg: BigNum := BigNum(Y); --negated value of Y for neg * neg
   begin
	if X(0) < 5  and Y(0) < 5 then
   	   product := Signed_BigNum(BigNum(X) * BigNum(Y));
	   if product(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	elsif X(0) < 5 and Y(0) >= 5 then
	   yNeg(0) := yNeg(0) - 5;
	   product := Signed_BigNum(BigNum(X) * BigNum(yNeg));
	   if product(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	   product := Signed_BigNum(BigNum(product) + BigNum(negConstant));
	elsif X(0) >= 5 and Y(0) < 5 then
	   xNeg(0) := xNeg(0) - 5;
	   product := Signed_BigNum(BigNum(xNeg) * BigNum(Y));
	   if product(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	   product := Signed_BigNum(BigNum(product) + BigNum(negConstant));
	else
	   xNeg(0) := xNeg(0) - 5;
	   yNeg(0) := yNeg(0) - 5;
	   product := Signed_BigNum(BigNum(xNeg) * BigNum(yNeg));
	   if product(0) >= 5 then
		raise Signed_BigNumOverflow;
	   end if;
	end if;
      return product;
   end "*";

   ----------------------------------------------------------
   -- Purpose: Outputs the passed signed bignum with specified width
   -- Parameters: Item: signed bignum to print, Width: amount of digits
   -- Precondition: valid signed bignum and width is less than max size
   -- Postcondition: Prints the signed bignum w/ width digits
   ----------------------------------------------------------
   procedure Put (Item : Signed_BigNum; Width : Natural := 1) is
   fixedNum: Signed_BigNum := Item; --nonconstant Item for neg cases (5..9)
   begin
      if Item(0) >= 5 and Item /= negConstant then
	   fixedNum(0) := fixedNum(0) - 5;
	   put("-");
	   Put(BigNum(fixedNum), Width);
	elsif Item = negConstant then
	   fixedNum(0) := fixedNum(0) - 5;
	   Put(BigNum(fixedNum), Width);
	else
	   Put(BigNum(fixedNum), Width);
	end if;
   end Put;

   ----------------------------------------------------------
   -- Purpose: Gets the next signed bignum from input
   -- Parameters: Item: store for the signed bignum in input
   -- Precondition: next input is valid signed bignum
   -- Postcondition: Outputs input in Item param
   ----------------------------------------------------------
   procedure Get (Item : out Signed_BigNum) is
   EOL: Boolean; --identifies end of line
   c: Character; --character to check if pos/neg
   b: BigNum; --bignum for bignum addition of neg constant
   begin
      look_ahead(c, EOL);
      if c = '_' then
	   get(c);
         get(b);
	   Item := Signed_BigNum(b + BigNum(negConstant));
      else
	   get(b);
	   Item := Signed_BigNum(b);
      end if;
   end Get;
end BigNumPkg.Signed;