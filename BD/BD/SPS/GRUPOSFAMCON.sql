-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSFAMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSFAMCON`;DELIMITER $$

CREATE PROCEDURE `GRUPOSFAMCON`(
/* SP DE CONSULTA DE GRUPOS FAMILIARES */
	Par_ClienteID				BIGINT(12),		-- ID del Cliente a quien le pertenece el grupo.
	Par_FamClienteID			INT(11),		-- ID del Cliente Familiar.
	Par_TipoConsulta			TINYINT,		-- Núm. de Consulta.
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Str_SI			CHAR(1);
DECLARE	Str_NO			CHAR(1);
DECLARE Con_Existencia	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	Str_SI				:= 'S';				-- Salida Si
SET	Str_NO				:= 'N'; 			-- Salida No
SET Con_Existencia		:= 1;				-- Tipo de Consulta la existencia de un integrante en otro grupo.
SET Aud_FechaActual 	:= NOW();

IF(IFNULL(Par_TipoConsulta, Entero_Cero)) = Con_Existencia THEN
	IF EXISTS(SELECT * FROM GRUPOSFAM WHERE ClienteID != Par_ClienteID AND FamClienteID = Par_FamClienteID)THEN
		SELECT
			Str_SI AS Existe,
			CONCAT('El ',FNGENERALOCALE('safilocale.cliente'),' ',G.FamClienteID,' ',UPPER(CF.NombreCompleto) , ' se Encuentra Asignado al Grupo Familiar del ',FNGENERALOCALE('safilocale.cliente'),' ',CT.ClienteID,' ',UPPER(CT.NombreCompleto),'.\n¿Desea continuar?') AS Mensaje
		FROM GRUPOSFAM G
			INNER JOIN CLIENTES CT ON (G.ClienteID=CT.ClienteID)
			INNER JOIN CLIENTES CF ON (G.FamClienteID=CF.ClienteID)
		WHERE G.ClienteID != Par_ClienteID
			AND G.FamClienteID = Par_FamClienteID
			LIMIT 1;
	ELSE
		SELECT Str_NO AS Existe, Cadena_Vacia AS Mensaje;
	END IF;
END IF;

END TerminaStore$$