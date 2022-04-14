-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSACT`;
DELIMITER $$

CREATE PROCEDURE `PROSPECTOSACT`(

	Par_Prospecto       INT(11),
	Par_Cliente         INT(11),
	Par_TipoAct         TINYINT UNSIGNED,

	Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT(11),
	INOUT Par_ErrMen    VARCHAR(400),

	Aud_Empresa         INT(11),
	Aud_Usuario         INT(11),

	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Var_Prospecto           INT(11);
DECLARE Var_Cliente             INT(11);
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_ExpedienteID		BIGINT(20);		-- Numero de Expediente

DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATETIME;
DECLARE Entero_Cero             INT(11);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE Tip_ActualizaCte        	INT(11);		-- Actualizacion Cliente
DECLARE TipoPersona_Prospecto      	CHAR(1);		-- Tipo de Prospecto
DECLARE TipoPersona_Cliente			CHAR(1);		-- Tipo de Cliente
DECLARE TipoInstrumento_Cliente     INT(11);		-- Instrumento Cliente
DECLARE TipoInstrumento_Solicitud   INT(11);		-- Instrumento SolicitudCredito
DECLARE TipoInstrumento_Prospecto   INT(11);		-- Instrumento Prospecto


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Str_SI              := 'S';
SET Str_NO              := 'N';
SET Tip_ActualizaCte    		:= 1;         	-- Tipo de Actualizacion para actualizar No de Cliente
SET TipoPersona_Prospecto 		:= 'P';			-- Tipo de Prospecto
SET TipoPersona_Cliente 		:= 'C';			-- Tipo de Cliente
SET TipoInstrumento_Cliente 	:= 1;			-- Instrumento Cliente
SET TipoInstrumento_Solicitud 	:= 5;			-- Instrumento Solicitud de Credito
SET TipoInstrumento_Prospecto	:= 7;			-- Instrumento Prospecto

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr	= 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PROSPECTOSACT');
		SET Var_Control	= 'SQLEXCEPTION';
	END;

	IF(Par_TipoAct = Tip_ActualizaCte)THEN
		SELECT ProspectoID, 	ClienteID
		  INTO Var_Prospecto, 	Var_Cliente
			FROM PROSPECTOS
				WHERE ProspectoID = Par_Prospecto;

		SET Var_Prospecto   := IFNULL(Var_Prospecto, Entero_Cero);
		SET Var_Cliente     := IFNULL(Var_Cliente, Entero_Cero);

		IF Var_Prospecto = Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Prospecto no Existe';
			SET Var_Control	:= 'prospectoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_Cliente)THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Numero de safilocale.cliente no Existe';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE AVALESPORSOLICI SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE CLIDATSOCIOE SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE CLIENTEARCHIVOS SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE GARANTIAS SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE `HIS-INTEGRAGRUPOSCRE` SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE HISCLIDATSOCIOE SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE HISSOCIODEMOCON SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE HISSOCIODEMODEP SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE HISSOCIODEMOGRAL SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE HISSOCIODEMOVIV SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE INTEGRAGRUPOSCRE SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE PROSPECTOS SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOCIODEMOCONYUG SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOCIODEMODEPEND SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOCIODEMOGRAL SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOCIODEMOVIVIEN SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOLCREPROSPECTO SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		UPDATE SOLICITUDCREDITO SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;


		UPDATE INTEGRAGRUPOSCRE SET
			ClienteID   = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;


		UPDATE CICLOBASECLIPRO SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;


		UPDATE NOMINAEMPLEADOS SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;


		UPDATE NEGAFILICLIENTE SET
			ClienteID = Par_Cliente
			WHERE ProspectoID = Par_Prospecto;

		-- Inicio Documentos en Guarda Valores
		-- Verifco que existe el expediente
		SELECT NumeroExpedienteID
		INTO Var_ExpedienteID
		FROM EXPEDIENTEGRDVALORES
		WHERE ParticipanteID = Par_Prospecto
		  AND TipoPersona = TipoPersona_Prospecto;

		SET Var_ExpedienteID := IFNULL(Var_ExpedienteID, Entero_Cero);

		-- Si el Expediente es
		IF(Var_ExpedienteID > Entero_Cero) THEN

			-- Actualizo Instrumentos de Prospecto a Cliente
			UPDATE DOCUMENTOSGRDVALORES SET
				TipoInstrumento		= TipoInstrumento_Cliente,
				NumeroInstrumento	= Par_Cliente,
				ParticipanteID		= Par_Cliente,
				TipoPersona			= TipoPersona_Cliente
			WHERE NumeroExpedienteID = Var_ExpedienteID
			  AND TipoInstrumento = TipoInstrumento_Prospecto
			  AND NumeroInstrumento = Par_Prospecto
			  AND ParticipanteID = Par_Prospecto
			  AND TipoPersona = TipoPersona_Prospecto;

			-- Actualizo Instrumentos de Prospecto a Cliente
			UPDATE DOCUMENTOSGRDVALORES SET
				ParticipanteID		= Par_Cliente,
				TipoPersona 		= TipoPersona_Cliente
			WHERE NumeroExpedienteID = Var_ExpedienteID
			  AND TipoInstrumento = TipoInstrumento_Solicitud
			  AND ParticipanteID = Par_Prospecto
			  AND TipoPersona = TipoPersona_Prospecto;

			-- Actualizo el Expediente
			UPDATE EXPEDIENTEGRDVALORES SET
				TipoInstrumento		= TipoInstrumento_Cliente,
				ParticipanteID		= Par_Cliente,
				TipoPersona 		= TipoPersona_Cliente
			WHERE NumeroExpedienteID = Var_ExpedienteID;
		END IF;
		-- Fin Guarda Valores

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'safilocale.cliente ligado al Prospecto con exito.';
		SET Var_Control	:= 'clienteID';

	END IF;

END ManejoErrores;

IF(Par_Salida = Str_SI)THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$