-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USRGUARDAVALORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS USRGUARDAVALORESCON;

DELIMITER $$
CREATE PROCEDURE `USRGUARDAVALORESCON`(
	-- Store Procedure: Que Consulta la configuracion de los Parametros de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),			-- ID de Tabla PARAMGUARDAVALORES
	Par_PuestoFacultado			VARCHAR(10),		-- ID o Clave del Puesto
	Par_UsuarioFacultadoID		INT(11),			-- ID de Usuario
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Con_PuestoFacultado		TINYINT UNSIGNED;	-- Consulta Puesto Facultado
	DECLARE Con_UsuarioFacultado	TINYINT UNSIGNED;	-- Consulta Usuario Facultado

	-- Asignacion de Constantes
	SET Entero_Cero 				:= 0;
	SET Decimal_Cero				:= 0.00;
	SET Fecha_Vacia 				:= '1900-01-01';
	SET Cadena_Vacia				:= '';
	SET Con_PuestoFacultado			:= 1;
	SET Con_UsuarioFacultado		:= 2;

	-- Se realiza la consulta para validar que existan los parametros
	IF( Par_NumConsulta = Con_PuestoFacultado) THEN

		SELECT	IFNULL(COUNT(UsrGuardaValoresID), Entero_Cero) AS UsrGuardaValoresID
		FROM USRGUARDAVALORES
		WHERE PuestoFacultado = Par_PuestoFacultado;

	END IF;

	-- Se realiza la consulta para validar que existan los parametros
	IF( Par_NumConsulta = Con_UsuarioFacultado) THEN

		SELECT	IFNULL(COUNT(UsrGuardaValoresID), Entero_Cero) AS UsrGuardaValoresID
		FROM USRGUARDAVALORES
		WHERE UsuarioFacultadoID = Par_UsuarioFacultadoID;

	END IF;

END TerminaStore$$