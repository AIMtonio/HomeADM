-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXPEDIENTEGRDVALORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS EXPEDIENTEGRDVALORESCON;

DELIMITER $$
CREATE PROCEDURE `EXPEDIENTEGRDVALORESCON`(
	-- Store Procedure: De Consulta los Expediente de Guarda Valores
	-- Modulo Guarda Valores
	Par_NumeroExpedienteID		BIGINT(20),		-- ID de tabla EXPEDIENTEGRDVALORES
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7. Prospecto \n8.- Aportaciones
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
	Par_SucursalID				INT(11),		-- ID de Sucursal
	Par_UsuarioAdministrador 	INT(11),		-- 0.- Usuario Sucursal 1 Usuario Admin

	Par_NumeroConsulta			TINYINT UNSIGNED,-- Numero de Consulta

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Est_Activo				CHAR(1);		-- Estatus Activo
	DECLARE Tip_Cliente				CHAR(1);		-- Tipo Cliente
	DECLARE Tip_Prospecto			CHAR(1);		-- Tipo Prospecto
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE UsuarioAdmin 			INT(11);		-- Constante Usuario Administrador
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Catalogo de Instrumentos
	DECLARE Inst_Cliente			INT(11);			-- Instrumento cliente
	DECLARE Inst_Prospecto			INT(11);			-- Instrumento Prospecto

	DECLARE Consulta_Principal		TINYINT UNSIGNED; -- Consulta Num. 1.- Consulta Principal
	DECLARE Consulta_Foranea 		TINYINT UNSIGNED; -- Consulta Num. 2.- Consulta Expediente por participante y sucursal
	DECLARE Consulta_Validacion 	TINYINT UNSIGNED; -- Consulta Num. 3.- Validacion de consulta de Expediente

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET Est_Activo			:= 'A';
	SET Tip_Cliente			:= 'C';
	SET Tip_Prospecto		:= 'P';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Consulta_Principal	:= 1;
	SET Consulta_Foranea	:= 2;
	SET Consulta_Validacion	:= 3;
	SET UsuarioAdmin		:= 1;

	-- Catalogo de Instrumentos
	SET Inst_Cliente			:= 1;
	SET Inst_Prospecto			:= 7;


	-- Consulta Num. 1.- Consulta Principal
	IF( Par_NumeroConsulta = Consulta_Principal ) THEN

		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN
			SELECT 	NumeroExpedienteID,		TipoInstrumento,	SucursalID,		FechaRegistro,
					HoraRegistro,			ParticipanteID,		TipoPersona,	UsuarioRegistroID,
					Estatus,				NumeroInstrumento
			FROM EXPEDIENTEGRDVALORES
			WHERE NumeroExpedienteID = Par_NumeroExpedienteID
			  AND SucursalID = Par_SucursalID;
		ELSE
			SELECT 	NumeroExpedienteID,		TipoInstrumento,	SucursalID,		FechaRegistro,
					HoraRegistro,			ParticipanteID,		TipoPersona,	UsuarioRegistroID,
					Estatus,				NumeroInstrumento
			FROM EXPEDIENTEGRDVALORES
			WHERE NumeroExpedienteID = Par_NumeroExpedienteID;
		END IF;
	END IF;

	-- Consulta Num. 2.- Consulta Expediente por participante y sucursal
	IF( Par_NumeroConsulta = Consulta_Foranea ) THEN
		IF(Par_UsuarioAdministrador <> UsuarioAdmin) THEN

			IF( Par_TipoInstrumento = Inst_Cliente ) THEN
				SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
				FROM EXPEDIENTEGRDVALORES
				WHERE SucursalID = Par_SucursalID
				  AND ParticipanteID = Par_NumeroInstrumento
				  AND TipoPersona = Tip_Cliente;
			END IF;

			IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
				SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
				FROM EXPEDIENTEGRDVALORES
				WHERE SucursalID = Par_SucursalID
				  AND ParticipanteID = Par_NumeroInstrumento
				  AND TipoPersona = Tip_Prospecto;
			END IF;

		ELSE

			IF( Par_TipoInstrumento = Inst_Cliente ) THEN
				SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
				FROM EXPEDIENTEGRDVALORES
				WHERE ParticipanteID = Par_NumeroInstrumento
				  AND TipoPersona = Tip_Cliente;
			END IF;

			IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
				SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
				FROM EXPEDIENTEGRDVALORES
				WHERE ParticipanteID = Par_NumeroInstrumento
				  AND TipoPersona = Tip_Prospecto;
			END IF;
		END IF;
	END IF;

	-- Consulta Num. 3.- Validacion de consulta de Expediente
	IF( Par_NumeroConsulta = Consulta_Validacion ) THEN

		IF( Par_TipoInstrumento = Inst_Cliente ) THEN
			SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
			FROM EXPEDIENTEGRDVALORES
			WHERE ParticipanteID = Par_NumeroInstrumento
			  AND TipoPersona = Tip_Cliente;
		END IF;

		IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
			SELECT 	IFNULL(COUNT(NumeroExpedienteID), Entero_Cero) AS NumeroExpedienteID,		Entero_Cero AS ParticipanteID
			FROM EXPEDIENTEGRDVALORES
			WHERE ParticipanteID = Par_NumeroInstrumento
			  AND TipoPersona = Tip_Prospecto;
		END IF;

	END IF;

END TerminaStore$$