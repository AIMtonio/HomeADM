-- SP NOMCLASIFCLAVEPRESUPCON

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLASIFCLAVEPRESUPCON;

DELIMITER $$

CREATE  PROCEDURE NOMCLASIFCLAVEPRESUPCON(
	-- SP para  Consultar la Informacion de los Clasificacion de las Claves Presupuestales
	Par_NomClasifClavPresupID	INT(11),			-- Numero o Id de la Tabla del Clasificacion de Claves Presupuestales
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
	DECLARE Con_ClasifClavPresup		INT(11);		-- Variable para la Consulta de Informacion del Clasificacion de claves presupuestales registrado

	-- Asignacion de constantes
	SET	Con_ClasifClavPresup			:= 1;			-- Variable para la Consulta de Informacion del Clasificacion de claves presupuestales registrado

	-- 1. Variable para la Consulta de Informacion del Clasificacion de claves presupuestales registrado
	IF(Par_NumCon = Con_ClasifClavPresup) THEN
		SELECT NomClasifClavPresupID,		Descripcion,		Estatus,			Prioridad,		NomClavePresupID
			FROM NOMCLASIFCLAVEPRESUP
			WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;
	END IF;

END TerminaStore$$
