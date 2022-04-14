-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLAVERELACIONCNVBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLAVERELACIONCNVBLIS`;DELIMITER $$

CREATE PROCEDURE `CLAVERELACIONCNVBLIS`(
	/*  SP PARA LISTAR LAS CLAVES DE RELACIONES */
	Par_NumList			TINYINT UNSIGNED,		-- no. de lista

	Par_EmpresaID		INT(11),				-- Parametros de auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN
	DECLARE Var_TipoInstitucion  INT;		-- Tipo de Institucion
	-- Declaracion de constantes
    DECLARE Lis_ClavesRel	INT(11);

    -- Asignacion de constantes
    SET Lis_ClavesRel 	:= 1;

	IF(Par_NumList = Lis_ClavesRel) THEN
		SELECT 	TipoRegulatorios
		INTO 	Var_TipoInstitucion
		FROM 	PARAMREGULATORIOS
        WHERE 	ParametrosID = 1;


		SELECT 	`ClaveRelacionID`, 		`Descripcion`
		FROM CLAVERELACIONCNVB
        WHERE  TipoInstitID = Var_TipoInstitucion;
    END IF;

END TerminaStore$$