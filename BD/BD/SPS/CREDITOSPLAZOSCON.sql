-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPLAZOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPLAZOSCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPLAZOSCON`(
	Par_FrecCap				CHAR(1),
	Par_NumCuotas			INT,
	Par_PeriodCap			INT,
	Par_PlazoID				VARCHAR(20),
	Par_Fecha				DATE,
	Par_NumCon				TINYINT UNSIGNED,
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN



DECLARE Var_FecVencimiento	DATE;
DECLARE Var_FechaIni		DATE;
DECLARE Var_NumCuotas		DECIMAL(12,2);




DECLARE		Cadena_Vacia		CHAR(1);
DECLARE		Entero_Cero			INT;
DECLARE		Float_Cero			FLOAT;
DECLARE		Decimal_Cero		DECIMAL(12,2);
DECLARE		SalidaSI			CHAR(1);
DECLARE		SalidaNO		 	CHAR(1);
DECLARE		Con_Principal	 	INT;
DECLARE		Con_Foranea		 	INT;
DECLARE		Con_Fecha		 	INT;
DECLARE 	Con_FechaVCuotas	INT;
DECLARE		NumDias				INT;
DECLARE		Fre_Dias			INT;


DECLARE PagoSemanal		CHAR(1);
DECLARE PagoDecenal     CHAR(1);
DECLARE PagoCatorcenal	CHAR(1);
DECLARE PagoQuincenal	CHAR(1);
DECLARE PagoMensual		CHAR(1);
DECLARE PagoPeriodo		CHAR(1);
DECLARE PagoBimestral	CHAR(1);
DECLARE PagoTrimestral	CHAR(1);
DECLARE PagoTetrames	CHAR(1);
DECLARE PagoSemestral	CHAR(1);
DECLARE PagoAnual		CHAR(1);
DECLARE PagoFinMes		CHAR(1);
DECLARE PagoAniver		CHAR(1);
DECLARE PagoUnico		CHAR(1);
DECLARE FrecSemanal		INT;
DECLARE FrecDecenal     INT;
DECLARE FrecCator		INT;
DECLARE FrecQuin		INT;
DECLARE FrecMensual		INT;
DECLARE FrecBimestral	INT;
DECLARE FrecTrimestral	INT;
DECLARE FrecTetrames	INT;
DECLARE FrecSemestral	INT;
DECLARE FrecAnual		INT;



SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET	Float_Cero		:= 0.0;
SET	Decimal_Cero	:= 0.0;
SET	SalidaSI		:= 'S';
SET	SalidaNO		:= 'N';
SET	Con_Principal	:= 1;
SET	Con_Foranea		:= 2;
SET Con_Fecha		:= 3;
SET Con_FechaVCuotas:= 4;


SET FrecSemanal			:= 7;
SET FrecDecenal         := 10;
SET FrecCator			:= 14;
SET FrecQuin			:= 15;
SET FrecMensual			:= 30;

SET FrecBimestral		:= 60;
SET FrecTrimestral		:= 90;
SET FrecTetrames		:= 120;
SET FrecSemestral		:= 180;
SET FrecAnual			:= 360;
SET PagoSemanal			:= 'S';
SET PagoDecenal         := 'D';
SET PagoCatorcenal		:= 'C';
SET PagoQuincenal		:= 'Q';
SET PagoMensual			:= 'M';
SET PagoPeriodo			:= 'P';
SET PagoBimestral		:= 'B';
SET PagoTrimestral		:= 'T';
SET PagoTetrames		:= 'R';
SET PagoSemestral		:= 'E';
SET PagoAnual			:= 'A';
SET PagoUnico			:= 'U';

SET Aud_FechaActual := CURRENT_TIMESTAMP();

IF(Par_NumCon = Con_Principal) THEN
	SELECT PlazoID,	Dias,	Descripcion
	FROM CREDITOSPLAZOS
	WHERE PlazoID = Par_PlazoID;
END IF;



IF(Par_NumCon = Con_Fecha) THEN

	CASE Par_FrecCap
		WHEN PagoQuincenal	THEN SET Fre_Dias	:=  FrecQuin;
		WHEN PagoCatorcenal THEN SET Fre_Dias	:=  FrecCator;
		WHEN PagoSemanal 	THEN SET Fre_Dias	:=  FrecSemanal;
        WHEN PagoDecenal 	THEN SET Fre_Dias	:=  FrecDecenal;
		WHEN PagoMensual 	THEN SET Fre_Dias	:=  FrecMensual;
		WHEN PagoBimestral 	THEN SET Fre_Dias	:=  FrecBimestral;
		WHEN PagoTrimestral THEN SET Fre_Dias	:=  FrecTrimestral;
		WHEN PagoTetrames 	THEN SET Fre_Dias	:=  FrecTetrames;
		WHEN PagoSemestral 	THEN SET Fre_Dias	:=  FrecSemestral;
		WHEN PagoAnual 		THEN SET Fre_Dias	:=  FrecAnual;
		WHEN PagoPeriodo 	THEN SET Fre_Dias	:=  Par_PeriodCap;
		WHEN PagoUnico 		THEN SET Fre_Dias	:=  Par_PeriodCap;
		ELSE SET Fre_Dias	:=  Entero_Cero;
	END CASE;

	SET NumDias := (SELECT Dias
					FROM CREDITOSPLAZOS
					WHERE PlazoID = Par_PlazoID);

	SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL NumDias DAY));

	IF(Par_FrecCap = PagoUnico) THEN
		SET Var_NumCuotas := 1;
	ELSE
		IF(Par_FrecCap = PagoPeriodo   )THEN
			SET Fre_Dias := NumDias;
		END IF;
		SET Var_NumCuotas := (CASE WHEN Fre_Dias = Entero_Cero THEN Entero_Cero ELSE (NumDias/ Fre_Dias) END);
	END IF;

	SELECT Var_FecVencimiento,	IFNULL(ROUND(Var_NumCuotas),0);

END IF;

IF(Par_NumCon = Con_FechaVCuotas) THEN
	CASE Par_FrecCap
		WHEN PagoQuincenal	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*FrecQuin DAY));
		WHEN PagoCatorcenal THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*FrecCator DAY));
		WHEN PagoSemanal 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*FrecSemanal DAY));
        WHEN PagoDecenal 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*FrecDecenal DAY));
		WHEN PagoMensual 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas MONTH));
		WHEN PagoBimestral 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*2 MONTH));
		WHEN PagoTrimestral THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*3 MONTH));
		WHEN PagoTetrames 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*4 MONTH));
		WHEN PagoSemestral 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*6 MONTH));
		WHEN PagoAnual 		THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas YEAR));
		WHEN PagoPeriodo 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*Par_PeriodCap DAY));
		WHEN PagoUnico	 	THEN SET Var_FecVencimiento := (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*Par_PeriodCap DAY));
		ELSE SET Var_FecVencimiento	:=  (SELECT DATE_ADD(Par_Fecha, INTERVAL Par_NumCuotas*Par_PeriodCap DAY));
	END CASE;
	SELECT Var_FecVencimiento;
END IF;

END TerminaStore$$