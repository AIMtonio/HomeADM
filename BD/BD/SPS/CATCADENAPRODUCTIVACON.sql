-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCADENAPRODUCTIVACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCADENAPRODUCTIVACON`;DELIMITER $$

CREATE PROCEDURE `CATCADENAPRODUCTIVACON`(
	/*SP Consultar las Cadenas Productivas de la SCIA*/
	Par_NumConsulta				TINYINT UNSIGNED,		# Numero de Consulta
	Par_CveCadena				INT(11),				# Clave de la Cadena Productiva

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
	DECLARE Consulta_Principal				INT(11);

	-- Asignacion de Constantes
	SET	Consulta_Principal					:= 1;				-- Consulta Principal

	/*	Numero de Consulta: 1
		Consulta Principal
	*/
	IF(Par_NumConsulta = Consulta_Principal) THEN
		SELECT CveCadena,		NomCadenaProdSCIAN
			FROM CATCADENAPRODUCTIVA
				WHERE
					CveCadena = Par_CveCadena;
	END IF;

END TerminaStore$$