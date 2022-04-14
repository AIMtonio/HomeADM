-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNVALORARCHIVOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNVALORARCHIVOS`;
DELIMITER $$

CREATE FUNCTION `FNVALORARCHIVOS`(
/** ========================================================
 ** --     FUNCION QUE REGRESA LOS CAMPOS DIVIDIDOS 
 ** -- DE LOS ARHCIVOS CARGADOS PARA EL EXPEDIENTE DE SOLICITUD
 ** ======================================================== */
	Par_ArchivoID		INT(11),		-- ID del Archivo a Procesar
	Par_TipoReg      	CHAR(1)			-- Tipo de Registro como Resultado N: Nombre R: Recurso E: Extension

) RETURNS VARCHAR(200) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Registro 	        VARCHAR(200);
	DECLARE Var_Recurso             VARCHAR(200);

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE RegNombre   		CHAR(1);
	DECLARE RegRecurso  		CHAR(1);
	DECLARE RegExtension   		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia 	:= '';
	SET RegNombre 	    := 'N';
	SET RegRecurso 	    := 'R';
	SET RegExtension 	:= 'E';

	SET Var_Recurso := (SELECT Recurso FROM SOLICITUDARCHIVOS WHERE DigSolID = Par_ArchivoID);
	SET Var_Recurso := IFNULL(Var_Recurso,Cadena_Vacia);

	IF(Par_TipoReg = RegNombre ) THEN
		SET Var_Registro := (SELECT(SUBSTRING_INDEX(Var_Recurso,'/',-1)));        
	END IF;

	IF(Par_TipoReg = RegExtension ) THEN
		SET Var_Registro :=  SUBSTRING_INDEX(Var_Recurso,'/',-1);
		SET Var_Registro := CONCAT(".",SUBSTRING_INDEX(Var_Recurso,'.',-1));
	END IF;

	SET Var_Registro = IFNULL(Var_Registro,Cadena_Vacia);
RETURN Var_Registro;
END$$