-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAESTATUSTIMPRODCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAESTATUSTIMPRODCON`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAESTATUSTIMPRODCON`(
-- SP PARA CONSULTAR POR PRODUCTO SI YA FUE TIMBRADO
	Par_ProductoCredID 	INT(11),				-- PRODUCTO
    Par_Anio			INT(11),				-- AÑO EN QUE FUE TIMBRADO
    Par_MesIni			INT(11),				-- MES EN QUE FUE TIMBRADO
    Par_MesFin			INT(11),				-- MES FINAL DEL PERIODO SEL TIMBRADO
    Par_Semestre		INT(11),			-- SEMESTRE 1 O 2
	Par_NumCon			TINYINT UNSIGNED,		-- TIPO DE CONSULTA

	-- PARAMETROS DE AUDITORIA
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)
TerminaStore:BEGIN

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE Con_ConPrincipal 	INT(11);
DECLARE	Var_Sentencia		VARCHAR(10000);



SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Con_ConPrincipal	:= 1;
SET Var_Sentencia		:= "";


IF(Par_NumCon=Con_ConPrincipal) THEN
	SET Var_Sentencia:=CONCAT(Var_Sentencia," SELECT ");
    SET Var_Sentencia := CONCAT(Var_Sentencia,
								CASE Par_MesIni WHEN 1 THEN "Mes1"
												WHEN 2 THEN "Mes2"
												WHEN 3 THEN "Mes3"
												WHEN 4 THEN "Mes4"
												WHEN 5 THEN "Mes5"
												WHEN 6 THEN "Mes6"
												WHEN 7 THEN "Mes7"
												WHEN 8 THEN "Mes8"
												WHEN 9 THEN "Mes9"
												WHEN 10 THEN "Mes10"
												WHEN 11 THEN "Mes11"
												WHEN 12 THEN "Mes12"
									ELSE
                                    CASE Par_Semestre WHEN 1 THEN "Mes6"
													  WHEN 2 THEN "Mes12"
									END
								END);

	SET Var_Sentencia := CONCAT(Var_Sentencia, " AS Timbrado FROM EDOCTAESTATUSTIMPROD WHERE");
	SET Var_Sentencia := CONCAT(Var_Sentencia, " Anio = ",Par_Anio);
	SET Var_Sentencia := CONCAT(Var_Sentencia, " AND ProductoCredID = ",Par_ProductoCredID);
   
    SET Var_Sentencia := CONCAT(Var_Sentencia,";");
   
    SET @Sentencia	= (Var_Sentencia);
	PREPARE TIMBRADOPROD FROM @Sentencia;
	EXECUTE TIMBRADOPROD ;
	DEALLOCATE PREPARE TIMBRADOPROD;
END IF;

END TerminaStore$$
