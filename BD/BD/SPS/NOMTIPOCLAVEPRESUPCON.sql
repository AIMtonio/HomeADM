-- SP NOMTIPOCLAVEPRESUPCON

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMTIPOCLAVEPRESUPCON;

DELIMITER $$

CREATE  PROCEDURE NOMTIPOCLAVEPRESUPCON(
	-- SP para  Consultar la Informacion de los tipos de Claves Presupuestales
	Par_NomTipoClavePresupID	INT(11),			-- Numero o Id del tipo Clave Presupuestal
	Par_NumCon					TINYINT UNSIGNED,	-- Numero de consulta de Consulta

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- ID de la Empresa
	Aud_Usuario					INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual				DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP				VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID				VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal				INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Numero de Transaccion
)TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Con_TipoClavPresup		INT(11);		-- Variable para la Consulta de Informacion del tipos de claves presupuestales registrado

	-- Asignacion de constantes
	SET	Con_TipoClavPresup			:= 1;			-- Variable para la Consulta de Informacion del tipos de claves presupuestales registrado

	-- 1.-Variable para la Consulta de Informacion del tipos de claves presupuestales registrado
	IF(Par_NumCon = Con_TipoClavPresup) THEN
		SELECT TIPOCLAV.NomTipoClavePresupID,		TIPOCLAV.Descripcion,		TIPOCLAV.ReqClave,		CLAV.NomClavePresupID
			FROM NOMTIPOCLAVEPRESUP TIPOCLAV
			LEFT JOIN NOMCLAVEPRESUP CLAV ON CLAV.NomTipoClavePresupID = TIPOCLAV.NomTipoClavePresupID
			WHERE TIPOCLAV.NomTipoClavePresupID = Par_NomTipoClavePresupID;
	END IF;

END TerminaStore$$
