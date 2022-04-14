-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTABLELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTABLELIS`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTABLELIS`(
-- -----------------------------------------------------------------
-- 			SP PARA OBTENER LA LISTA DE POLIZA CONTABLE
-- -----------------------------------------------------------------
	Par_Concepto		VARCHAR(150),		-- Parametro de concepto
	Par_NumLis			TINYINT UNSIGNED,	-- Parametro de numero de lista

	Par_EmpresaID      	INT(11),			-- Parametro de auditoria de empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria de usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria de fecha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria de Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria de ID de Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria de Sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria de Numero de Transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);		-- Constante de cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Constante de Fecha Vacia
	DECLARE	Lis_Principal	INT(11);		-- Constante de Lista Principal
	DECLARE Var_Manual    	VARCHAR(10);	-- Constante de var manual

	-- Asignaciond e constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Lis_Principal	:= 1;
	SET	Var_Manual		:= 'M';


	IF(Par_NumLis = Lis_Principal) THEN
		(SELECT 	PolizaID,	Fecha,	Concepto
			FROM POLIZACONTABLE
			WHERE	Concepto  LIKE CONCAT("%",Par_Concepto, "%")
			  AND	Tipo	= Var_Manual
			LIMIT 0, 15)
		UNION ALL
		(SELECT 	PolizaID,	Fecha,	Concepto
			FROM  `HIS-POLIZACONTA`
			WHERE	Concepto  LIKE CONCAT("%",Par_Concepto, "%")
			  AND	Tipo	= Var_Manual
			LIMIT 0, 15);
	END IF;

END TerminaStore$$