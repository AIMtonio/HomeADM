-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGENERALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMGENERALESCON`;DELIMITER $$

CREATE PROCEDURE `PARAMGENERALESCON`(
	Par_NumConsulta			INT(11),
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStored : BEGIN


DECLARE ConHabilitaFechaDisp 	INT(10);
DECLARE ConDetLaboralCteConyug	INT(10);
DECLARE ConRutaKtrPLD			INT(1);



DECLARE Var_Valor				VARCHAR(100);



SET ConHabilitaFechaDisp 		:= 1;
SET ConDetLaboralCteConyug		:= 2;
SET ConRutaKtrPLD				:= 3;


IF (Par_NumConsulta= ConHabilitaFechaDisp) THEN
	SET  Var_Valor :="HabilitaFechaDisp";
	SELECT LlaveParametro,ValorParametro
		FROM PARAMGENERALES WHERE LlaveParametro = Var_Valor;

END IF;


IF (Par_NumConsulta= ConDetLaboralCteConyug) THEN
	SET  Var_Valor := "DetLaboralCteConyug";
	SELECT LlaveParametro,ValorParametro
		FROM PARAMGENERALES WHERE LlaveParametro = Var_Valor;

END IF;

IF (Par_NumConsulta= ConRutaKtrPLD) THEN
	SET  Var_Valor := "RutaCorreosPLD";
	SELECT LlaveParametro,ValorParametro
		FROM PARAMGENERALES WHERE LlaveParametro = Var_Valor;

END IF;

END TerminaStored$$