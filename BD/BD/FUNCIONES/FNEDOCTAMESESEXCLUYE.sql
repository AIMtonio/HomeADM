-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEDOCTAMESESEXCLUYE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEDOCTAMESESEXCLUYE`;
DELIMITER $$


CREATE FUNCTION `FNEDOCTAMESESEXCLUYE`(
-- FUNSION PARA EXCLUIR EL CALCULO DE DATOS DE LOS MESES YA TIMBRADOS
    Par_ProductoCredID      INT(11),	-- PRODUCTO DE CREDITO
    Par_Anio		      	INT(11),	-- ANIO
    Par_MesIni				INT(11),	-- Mes de inicio
    Par_MesFin           	INT(11)		-- Mes Fin

) RETURNS varchar(150)
    DETERMINISTIC
BEGIN
    
    -- DELCARACION DE VARIABLES
    DECLARE MesesExcluir	VARCHAR(150);
	
    -- DECLARCION DE CONSTANTES
    DECLARE ConsSI			CHAR(1);
    DECLARE Cadena_Vacia	CHAR(1);
	
    -- ASIGNACION DE CONSTANTES
    
    SET Cadena_Vacia 		:= "";
    SET ConsSI 				:= "S";
    SET MesesExcluir 		:= Cadena_Vacia;
    
    
  SELECT CONCAT(	CASE WHEN Mes1 = ConsSI AND Par_MesIni <= 1 AND Par_MesFin >= 1 THEN '1,' ELSE Cadena_Vacia END,
					CASE WHEN Mes2 = ConsSI AND Par_MesIni <= 2 AND Par_MesFin >= 2  THEN '2,' ELSE Cadena_Vacia END,
					CASE WHEN Mes3 = ConsSI AND Par_MesIni <= 3 AND Par_MesFin >= 3  THEN '3,' ELSE Cadena_Vacia END,
					CASE WHEN Mes4 = ConsSI AND Par_MesIni <= 4 AND Par_MesFin >= 4  THEN '4,' ELSE Cadena_Vacia END,
					CASE WHEN Mes5 = ConsSI AND Par_MesIni <= 5 AND Par_MesFin >= 5  THEN '5,' ELSE Cadena_Vacia END,
					CASE WHEN Mes5 = ConsSI AND Par_MesIni <= 6 AND Par_MesFin >= 6  THEN '6,' ELSE Cadena_Vacia END,
					CASE WHEN Mes7 = ConsSI AND Par_MesIni <= 7 AND Par_MesFin >= 7  THEN '7,' ELSE Cadena_Vacia END,
					CASE WHEN Mes8 = ConsSI AND Par_MesIni <= 8 AND Par_MesFin >= 8  THEN '8,' ELSE Cadena_Vacia END,
					CASE WHEN Mes9 = ConsSI AND Par_MesIni <= 9 AND Par_MesFin >= 9  THEN '9,' ELSE Cadena_Vacia END,
					CASE WHEN Mes10 = ConsSI AND Par_MesIni <= 10 AND Par_MesFin >= 10  THEN '10,' ELSE Cadena_Vacia END,
					CASE WHEN Mes11 = ConsSI AND Par_MesIni <= 11 AND Par_MesFin >= 11  THEN '11,' ELSE Cadena_Vacia END,
					CASE WHEN Mes12 = ConsSI AND Par_MesIni <= 12 AND Par_MesFin >= 12  THEN '12' ELSE Cadena_Vacia END
					)
			INTO MesesExcluir
		FROM  EDOCTAESTATUSTIMPROD
		WHERE Anio = Par_Anio
		AND ProductoCredID = Par_ProductoCredID;

	SET MesesExcluir := substr(MesesExcluir,1,length(MesesExcluir)-1);
    
    
    
    RETURN MesesExcluir;
END$$