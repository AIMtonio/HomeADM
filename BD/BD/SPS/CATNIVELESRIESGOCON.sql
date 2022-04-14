-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATNIVELESRIESGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATNIVELESRIESGOCON`;DELIMITER $$

CREATE PROCEDURE `CATNIVELESRIESGOCON`(
	/* SP Para el catalogo de niveles de riesgo*/
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_TipoPersona			CHAR(1),			-- Tipo de Persona
	Par_EmpresaID			INT(11),  			-- Auditoria
	Aud_Usuario				INT(11),			-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT(11),			-- Auditoria
	Aud_NumTransaccion  	BIGINT(20) 			-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal			INT; 			-- Consulta pricipal
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE TipoPers_Fisica 		CHAR(1);		-- Tipo de Persona Fisica
	DECLARE TipoPers_ActFisica 		CHAR(1);		-- Tipo de Persona Fisica con Act Empresarial
	DECLARE TipoPers_Moral 			CHAR(1);		-- Tipo de Persona Moral
	DECLARE TipoPers_Todas 			CHAR(1);		-- Todos los Tipos de Persona

	-- Asignacion de Constantes
	SET	Con_Principal				:= 1;
	SET Cadena_Vacia				:= '';
	SET TipoPers_Fisica				:= 'F';
	SET TipoPers_ActFisica			:= 'A';
	SET TipoPers_Moral				:= 'M';
	SET TipoPers_Todas				:= 'T';

	IF (Par_NumCon=Con_Principal) THEN
		SET Par_TipoPersona := IFNULL(Par_TipoPersona, TipoPers_Todas);

		IF(Par_TipoPersona != TipoPers_Todas) THEN
			SELECT NivelRiesgoID, Descripcion, Minimo, Maximo, SeEscala,Estatus,TipoPersona
				FROM CATNIVELESRIESGO
					WHERE
						TipoPersona = Par_TipoPersona
							ORDER BY NivelRiesgoID='A', NivelRiesgoID='M',NivelRiesgoID='B';
		  ELSE
			SELECT NivelRiesgoID, Descripcion, Minimo, Maximo, SeEscala,Estatus,TipoPersona
				FROM CATNIVELESRIESGO
				WHERE
					TipoPersona = TipoPers_Fisica
					ORDER BY NivelRiesgoID='A', NivelRiesgoID='M',NivelRiesgoID='B';
		END IF;
	END IF;

END TerminaStore$$