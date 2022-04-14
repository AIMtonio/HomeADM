-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USRGUARDAVALORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS USRGUARDAVALORESLIS;

DELIMITER $$
CREATE PROCEDURE `USRGUARDAVALORESLIS`(
	-- Store Procedure: Que Consulta la configuracion de los Parametros de Guarda Valores
	-- Modulo Guarda Valores
	Par_UsrGuardaValoresID		INT(11),			-- ID de Tabla
	Par_ParamGuardaValoresID	INT(11),			-- Numero de Parametro Guarda Valores
	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Lis_Principal		TINYINT UNSIGNED;	-- Consulta Principal

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Lis_Principal			:= 1;

	-- Se realiza la consulta principal
	IF( Par_NumLista = Lis_Principal ) THEN

		DROP TABLE IF EXISTS TMP_USRGUARDAVALORES;
		CREATE TEMPORARY TABLE TMP_USRGUARDAVALORES(
			UsrGuardaValoresID			INT(11),
			ParamGuardaValoresID		INT(11),
			PuestoFacultado				VARCHAR(10),
			NombrePuestoFacultado		VARCHAR(300),
			UsuarioFacultadoID			INT(11),
			NombreUsuarioFacultado		VARCHAR(300),
			KEY `IDX_USRGUARDAVALORES_2` (`PuestoFacultado`),
			KEY `IDX_USRGUARDAVALORES_3` (`UsuarioFacultadoID`));

		INSERT INTO TMP_USRGUARDAVALORES
		SELECT UsrGuardaValoresID,	ParamGuardaValoresID,	PuestoFacultado,
			   Cadena_Vacia, 		UsuarioFacultadoID,		Cadena_Vacia
		FROM USRGUARDAVALORES
		WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID;

		UPDATE TMP_USRGUARDAVALORES tmp, PUESTOS pue SET
			tmp.NombrePuestoFacultado = pue.Descripcion
		WHERE tmp.PuestoFacultado = pue.ClavePuestoID ;

		UPDATE TMP_USRGUARDAVALORES tmp, USUARIOS usr SET
			tmp.NombreUsuarioFacultado = usr.NombreCompleto
		WHERE tmp.UsuarioFacultadoID = usr.UsuarioID ;

		SELECT	UsrGuardaValoresID,		ParamGuardaValoresID,	PuestoFacultado,
				NombrePuestoFacultado,	UsuarioFacultadoID,		NombreUsuarioFacultado
		FROM TMP_USRGUARDAVALORES;

		DROP TABLE IF EXISTS TMP_USRGUARDAVALORES;

	END IF;

END TerminaStore$$