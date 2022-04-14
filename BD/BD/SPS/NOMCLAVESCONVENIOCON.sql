-- SP NOMCLAVESCONVENIOCON

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVESCONVENIOCON;

DELIMITER $$

CREATE PROCEDURE NOMCLAVESCONVENIOCON(
	-- SP para  Consulta de los Claves Presupuestales Por institucion de nomina
	Par_NomClaveConvenioID		INT(11),			-- Id de la Tabla del Claves Presupuestales por Convenios de Nomina.
	Par_InstitNominaID			INT(11),			-- ID o Numero de Institucion de Nomina
	Par_ConvenioNominaID		BIGINT(20),			-- Id o numero de  Convenio
	Par_NumCon					TINYINT UNSIGNED,	-- Numero de consulta

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
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Con_ClavPresupConv		INT(11);		-- Variable para la Consulta de los claves presupuestales registrado por convenio de nomina

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Asignacion de Cadena Vacia
	SET	Con_ClavPresupConv		:= 1;				-- Variable para la Consulta de los claves presupuestales registrado por convenio de nomina

	-- 1.-Variable para la Consulta de los claves presupuestales registrado por convenio de nomina
	IF(Par_NumCon = Con_ClavPresupConv) THEN
		SELECT NomClaveConvenioID,		InstitNominaID,		ConvenioNominaID,		NomClavePresupID
			FROM NOMCLAVESCONVENIO
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID;
	END IF;
END TerminaStore$$

