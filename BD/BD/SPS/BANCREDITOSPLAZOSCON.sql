-- BANCREDITOSPLAZOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCREDITOSPLAZOSCON`;
DELIMITER $$


CREATE PROCEDURE `BANCREDITOSPLAZOSCON`(

	Par_FrecCap						CHAR(1),
	Par_NumCuotas					INT(11),
	Par_PeriodCap					INT(11),
	Par_PlazoID						VARCHAR(20),
	Par_Fecha						DATE,
	Par_NumCon						TINYINT UNSIGNED,

	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE	Con_Fecha		 		INT(1);
	DECLARE Var_FecVencimiento		DATE;
	DECLARE Var_NumCuotas			DECIMAL(12,2);
	DECLARE	Entero_Cero				INT(11);
	DECLARE	NumDias					INT(11);
	DECLARE	Fre_Dias				INT(11);

	DECLARE PagoSemanal				CHAR(1);
	DECLARE PagoDecenal    		 	CHAR(1);
	DECLARE PagoCatorcenal			CHAR(1);
	DECLARE PagoQuincenal			CHAR(1);
	DECLARE PagoMensual				CHAR(1);
	DECLARE PagoPeriodo				CHAR(1);
	DECLARE PagoBimestral			CHAR(1);
	DECLARE PagoTrimestral			CHAR(1);
	DECLARE PagoTetrames			CHAR(1);
	DECLARE PagoSemestral			CHAR(1);
	DECLARE PagoAnual				CHAR(1);
	DECLARE PagoFinMes				CHAR(1);
	DECLARE PagoAniver				CHAR(1);
	DECLARE PagoUnico				CHAR(1);
	DECLARE FrecSemanal				INT(11);
	DECLARE FrecDecenal    			INT(11);
	DECLARE FrecCator				INT(11);
	DECLARE FrecQuin				INT(11);
	DECLARE FrecMensual				INT(11);
	DECLARE FrecBimestral			INT(11);
	DECLARE FrecTrimestral			INT(11);
	DECLARE FrecTetrames			INT(11);
	DECLARE FrecSemestral			INT(11);
	DECLARE FrecAnual				INT(11);


	SET Con_Fecha					:= 1;

	SET FrecSemanal					:= 7;
	SET FrecDecenal         		:= 10;
	SET FrecCator					:= 14;
	SET FrecQuin					:= 15;
	SET FrecMensual					:= 30;

	SET FrecBimestral				:= 60;
	SET FrecTrimestral				:= 90;
	SET FrecTetrames				:= 120;
	SET FrecSemestral				:= 180;
	SET FrecAnual					:= 360;
	SET PagoSemanal					:= 'S';
	SET PagoDecenal         		:= 'D';
	SET PagoCatorcenal				:= 'C';
	SET PagoQuincenal				:= 'Q';
	SET PagoMensual					:= 'M';
	SET PagoPeriodo					:= 'P';
	SET PagoBimestral				:= 'B';
	SET PagoTrimestral				:= 'T';
	SET PagoTetrames				:= 'R';
	SET PagoSemestral				:= 'E';
	SET PagoAnual					:= 'A';
	SET PagoUnico					:= 'U';

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

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

		SELECT Var_FecVencimiento AS FechaVencimiento,	IFNULL(ROUND(Var_NumCuotas),0) AS Cuotas;

	END IF;

END TerminaStore$$
