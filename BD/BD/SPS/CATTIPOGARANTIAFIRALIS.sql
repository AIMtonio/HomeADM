-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOGARANTIAFIRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOGARANTIAFIRALIS`;DELIMITER $$

CREATE PROCEDURE `CATTIPOGARANTIAFIRALIS`(
	/*SP para listar las garantias FIRA*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_Descripcion				VARCHAR(45),			# Descripcion de la garantia

	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Lis_Combo			INT(11);
	DECLARE Lis_ComboReporte	INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;				-- Entero Cero
	SET	Lis_Combo				:= 1;				-- Lista del Combo
	SET	Lis_ComboReporte		:= 2;				-- Lista del Combo Reporte

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT
			TipoGarantiaID,			Descripcion
		  FROM CATTIPOGARANTIAFIRA;
	END IF;

	-- Numero de Lista 2.- Usada en reportes
	IF(Par_NumLis = Lis_ComboReporte) THEN
		SELECT
			TipoGarantiaID,			Descripcion
		  FROM CATTIPOGARANTIAFIRA
		 WHERE TipoGarantiaID <> Entero_Cero;
	END IF;

END TerminaStore$$