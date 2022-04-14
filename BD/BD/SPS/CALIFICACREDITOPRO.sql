-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICACREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALIFICACREDITOPRO`;DELIMITER $$

CREATE PROCEDURE `CALIFICACREDITOPRO`(

    Par_Fecha           DATETIME,


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Var_TipoInstitID		INT(11);
DECLARE Var_Llamada 			VARCHAR(400);
DECLARE Var_ProcPersonalizado 	VARCHAR(30);


DECLARE Entero_Cero    		INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE TipoInstSOFIPO      INT(11);
DECLARE ProcesoEPRCSOFIPO   VARCHAR(30);
DECLARE ProcesoEPRCSOCAP    VARCHAR(30);


SET Entero_Cero 		:= 0;
SET Cadena_Vacia		:= '';
SET TipoInstSOFIPO      := 3;
SET ProcesoEPRCSOFIPO   := 'CALIFICACREDITOSOFIPOPRO';
SET ProcesoEPRCSOCAP    := 'CALIFICACREDITOSOCAPPRO';

ManejoErrores:BEGIN


	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM INSTITUCIONES Ins,PARAMETROSSIS Par WHERE Par.InstitucionID = Ins.InstitucionID);
    SET Var_TipoInstitID := IFNULL(Var_TipoInstitID,Entero_Cero);


	IF(Var_TipoInstitID = TipoInstSOFIPO) THEN
		SET Var_ProcPersonalizado := ProcesoEPRCSOFIPO;
	ELSE
		SET Var_ProcPersonalizado :=  ProcesoEPRCSOCAP;
	END IF;


	 SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado,"('",Par_Fecha,"','",Par_EmpresaID,"',
						'",Aud_Usuario,"','",Aud_FechaActual,"','",Aud_DireccionIP,"','",Aud_ProgramaID,"',
                        '",Aud_Sucursal,"','",Aud_NumTransaccion,"');");


	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;

END TerminaStore$$