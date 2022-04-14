-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCLABE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCLABE`;DELIMITER $$

CREATE FUNCTION `FUNCIONCLABE`(
Par_CuentaAhoID		   bigint(12),
Par_SucursalID 		   int(11)

) RETURNS varchar(18) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE Var_NumCta     char(11);
DECLARE Var_CodBan     char(3);
DECLARE Var_CodPla     char(3);
DECLARE Var_CtaCom     char(17);

DECLARE Var_CtaCom1    varchar(10);
DECLARE Var_CtaCom2    varchar(10);
DECLARE Var_CtaCom3    varchar(10);
DECLARE Var_CtaCom4    varchar(10);
DECLARE Var_CtaCom5    varchar(10);
DECLARE Var_CtaCom6    varchar(10);
DECLARE Var_CtaCom7    varchar(10);
DECLARE Var_CtaCom8    varchar(10);
DECLARE Var_CtaCom9    varchar(10);
DECLARE Var_CtaCom10   varchar(10);
DECLARE Var_CtaCom11   varchar(10);
DECLARE Var_CtaCom12   varchar(10);
DECLARE Var_CtaCom13   varchar(10);
DECLARE Var_CtaCom14   varchar(10);
DECLARE Var_CtaCom15   varchar(10);
DECLARE Var_CtaCom16   varchar(10);
DECLARE Var_CtaCom17   varchar(10);
DECLARE resultadoMul1  int(3);
DECLARE resultadoMul2  int(3);
DECLARE resultadoMul3  int(3);
DECLARE resultadoMul4  int(3);
DECLARE resultadoMul5  int(3);
DECLARE resultadoMul6  int(3);
DECLARE resultadoMul7  int(3);
DECLARE resultadoMul8  int(3);
DECLARE resultadoMul9  int(3);
DECLARE resultadoMul10 int(3);
DECLARE resultadoMul11 int(3);
DECLARE resultadoMul12 int(3);
DECLARE resultadoMul13 int(3);
DECLARE resultadoMul14 int(3);
DECLARE resultadoMul15 int(3);
DECLARE resultadoMul16 int(3);
DECLARE resultadoMul17 int(3);
DECLARE resMod1        int(3);
DECLARE resMod2        int(3);
DECLARE resMod3        int(3);
DECLARE resMod4        int(3);
DECLARE resMod5        int(3);
DECLARE resMod6        int(3);
DECLARE resMod7        int(3);
DECLARE resMod8        int(3);
DECLARE resMod9        int(3);
DECLARE resMod10       int(3);
DECLARE resMod11       int(3);
DECLARE resMod12       int(3);
DECLARE resMod13       int(3);
DECLARE resMod14       int(3);
DECLARE resMod15       int(3);
DECLARE resMod16       int(3);
DECLARE resMod17       int(3);
DECLARE resulTotal     int(10);
DECLARE resta          int(3);
DECLARE CLABE          varchar(18);
DECLARE LongitudCLABE  varchar(18);
DECLARE Var_CodIns     varchar(3);


DECLARE DigitoVer      int(1);
DECLARE SumaTotResMod  int(11);
DECLARE Oper3		   int(1);
DECLARE Oper7		   int(1);
DECLARE Oper1		   int(1);
DECLARE Entero_Cero    int;
DECLARE Cadena_Vacia   char(1);
DECLARE TamCod         int(1);
DECLARE TamCodIns      int(1);
DECLARE TamCodPla      int(1);


Set DigitoVer		   := 0;
Set SumaTotResMod	   := 0;
Set Entero_Cero        := 0;
Set Oper3              := 3;
Set Oper7              := 7;
Set Oper1              := 1;
Set Entero_Cero        := 0;
Set Cadena_Vacia	   := '';
Set TamCod             := 2;


if(Par_CuentaAhoID !=Entero_Cero)then
	 set Var_NumCta := LPAD(convert(Par_CuentaAhoID, char(11)),11,0);

	select INS.Folio
       into Var_CodIns
	from INSTITUCIONES INS inner join PARAMETROSSIS PR on INS.InstitucionID = PR.InstitucionID;


	if(ifnull(Var_CodIns,Entero_Cero))=Entero_Cero then
		set CLABE := '1';
		return CLABE;

	end if;


	set TamCodIns := length(Var_CodIns);

	if(TamCodIns<=TamCod) then
		set CLABE := '2';
		return CLABE;

	end if;


	set Var_CodBan := (convert(Var_CodIns,char(3)));

	select PlazaCLABE
       into Var_CodPla
	from PLAZAS PL inner join SUCURSALES SC on PL.PlazaID = SC.PlazaID
	where SC.SucursalID = Par_SucursalID;


	if(ifnull(Var_CodPla,Entero_Cero))=Entero_Cero then
		set CLABE := '3';
		return CLABE;

	end if;


	set TamCodPla := length(Var_CodPla);
	if(TamCodPla<=TamCod)then
		set CLABE := '4';
		return CLABE;

	end if;

set Var_CtaCom := concat(Var_CodBan,Var_CodPla,Var_NumCta);



	set Var_CtaCom1:=substring(Var_CtaCom,1,1);
							set resultadoMul1:=(Var_CtaCom1*oper3);
	set Var_CtaCom2:=substring(Var_CtaCom,2,1);
							set resultadoMul2:=(Var_CtaCom2*oper7);
	set Var_CtaCom3:=substring(Var_CtaCom,3,1);
							set resultadoMul3:=(Var_CtaCom3*oper1);
	set Var_CtaCom4:=substring(Var_CtaCom,4,1);
							set resultadoMul4:=(Var_CtaCom4*oper3);
	set Var_CtaCom5:=substring(Var_CtaCom,5,1);
							set resultadoMul5:=(Var_CtaCom5*oper7);
	set Var_CtaCom6:=substring(Var_CtaCom,6,1);
							set resultadoMul6:=(Var_CtaCom6*oper1);
	set Var_CtaCom7:=substring(Var_CtaCom,7,1);
							set resultadoMul7:=(Var_CtaCom7*oper3);
	set Var_CtaCom8:=substring(Var_CtaCom,8,1);
							set resultadoMul8:=(Var_CtaCom8*oper7);
	set Var_CtaCom9:=substring(Var_CtaCom,9,1);
							set resultadoMul9:=(Var_CtaCom9*oper1);
	set Var_CtaCom10:=substring(Var_CtaCom,10,1);
							set resultadoMul10:=(Var_CtaCom10*oper3);
	set Var_CtaCom11:=substring(Var_CtaCom,11,1);
							set resultadoMul11:=(Var_CtaCom11*oper7);
	set Var_CtaCom12:=substring(Var_CtaCom,12,1);
							set resultadoMul12:=(Var_CtaCom12*oper1);
	set Var_CtaCom13:=substring(Var_CtaCom,13,1);
							set resultadoMul13:=(Var_CtaCom13*oper3);
	set Var_CtaCom14:=substring(Var_CtaCom,14,1);
							set resultadoMul14:=(Var_CtaCom14*oper7);
	set Var_CtaCom15:=substring(Var_CtaCom,15,1);
							set resultadoMul15:=(Var_CtaCom15*oper1);
	set Var_CtaCom16:=substring(Var_CtaCom,16,1);
							set resultadoMul16:=(Var_CtaCom16*oper3);
	set Var_CtaCom17:=substring(Var_CtaCom,17,1);
							set resultadoMul17:=(Var_CtaCom17*oper7);



	set resMod1 = (resultadoMul1%10);
	set resMod2 = (resultadoMul2%10);
	set resMod3 = (resultadoMul3%10);
	set resMod4 = (resultadoMul4%10);
	set resMod5 = (resultadoMul5%10);
	set resMod6 = (resultadoMul6%10);
	set resMod7 = (resultadoMul7%10);
	set resMod8 = (resultadoMul8%10);
	set resMod9 = (resultadoMul9%10);
	set resMod10 = (resultadoMul10%10);
	set resMod11 = (resultadoMul11%10);
	set resMod12 = (resultadoMul12%10);
	set resMod13 = (resultadoMul13%10);
	set resMod14 = (resultadoMul14%10);
	set resMod15 = (resultadoMul15%10);
	set resMod16 = (resultadoMul16%10);
	set resMod17 = (resultadoMul17%10);



	set SumaTotResMod = (resMod1  + resMod2  + resMod3  + resMod4  +
						 resMod5  + resMod6  + resMod7  + resMod8  +
						 resMod9  + resMod10 + resMod11 + resMod12 +
						 resMod13 + resMod14 + resMod15 + resMod16 +
						 resMod17);




	set resulTotal = (SumaTotResMod%10);


	set resta = (10-resulTotal);


	set DigitoVer = (resta%10);

	set CLABE := concat(Var_CtaCom,convert(DigitoVer,char(1)));

end if;

return CLABE;

END$$