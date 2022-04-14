-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETCREPRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADETCREPRO`(

	Par_AnioMes     INT(11),
    Par_SucursalID  	INT(11),
    Par_FecIniMes   	DATE,
    Par_FecFinMes   	DATE

)

TerminaStore: BEGIN


DECLARE Var_CliProEsp   		INT;
DECLARE Var_Llamada 			VARCHAR(400);
DECLARE Var_ProcPersonalizado 		VARCHAR(200);


DECLARE Entero_Cero    		INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE DetalleCreEdoCta 	INT;
DECLARE Con_CliProcEspe     	VARCHAR(20);
DECLARE NumClienteSofi		INT;
DECLARE NumClienteCred		INT(11);			-- Numero de Cliente para Crediclub Proceso Especifico:24

SET Entero_Cero 		:= 0;
SET Cadena_Vacia		:= '';
SET DetalleCreEdoCta		:= 6;
SET Con_CliProcEspe     	:= 'CliProcEspecifico';
SET NumClienteSofi		:= 15;
SET NumClienteCred		:= 24;					-- Numero de Cliente para Crediclub Procesos Especifico:24

ManejoErrores:BEGIN


	SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

	SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);


	IF(Var_CliProEsp = NumClienteSofi) THEN
		SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DetalleCreEdoCta AND CliProEspID = Var_CliProEsp);
	ELSEIF (Var_CliProEsp = NumClienteCred) THEN
			SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DetalleCreEdoCta AND CliProEspID = Var_CliProEsp);
	ELSE
		SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DetalleCreEdoCta AND CliProEspID = Entero_Cero);
	END IF;


	SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado,' (',Par_AnioMes,',',Par_SucursalID,',',"'",Par_FecIniMes,"'",",","'",Par_FecFinMes,"'",");");


	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$