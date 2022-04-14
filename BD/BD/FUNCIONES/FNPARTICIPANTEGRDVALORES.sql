DELIMITER ;
DROP FUNCTION IF EXISTS FNPARTICIPANTEGRDVALORES;

DELIMITER $$
CREATE FUNCTION `FNPARTICIPANTEGRDVALORES`(
	-- Descripcion	= Funcion retorna el ID del Participante del expediente o documento en guarda valores
	-- Modulo		= Guarda Valores
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- Cede \n 4.- Inversion
												-- \n5.- Solicitud Credito \n6.- Credito \n7.-Prospecto \n8.- Aportacion
	Par_NumeroInstrumento		BIGINT(20),		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, SolicitudCreditoID, CreditoID, ProspectoID, Aportacion,
	Par_TipoOperacion			TINYINT UNSIGNED	-- Numero de Operacion
) RETURNS BIGINT(20)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_ParticipanteID		BIGINT(20);			-- Numero de Participante
	DECLARE Var_InstrumentoID		BIGINT(20);			-- Numero de Instrumento
	DECLARE Var_Resultado			BIGINT(20);			-- Numero de Resultado

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Decimal_Cero			DECIMAL(12,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de fecha vacia
	DECLARE Ope_Participante		TINYINT UNSIGNED;	-- Numero de Operacion para obtener el ID del participante
	DECLARE Ope_Instrumento			TINYINT UNSIGNED;	-- Numero de Operacion para obtener el ID del Instrumento

	-- Catalogo de Instrumentos
	DECLARE Inst_Cliente			INT(11);			-- Instrumento cliente
	DECLARE Inst_CuentaAho			INT(11);			-- Instrumento Cuenta de Ahorro
	DECLARE Inst_Cede				INT(11);			-- Instrumento CEDE
	DECLARE Inst_Inversion			INT(11);			-- Instrumento Inversion
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Inst_Credito			INT(11);			-- Instrumento Credito
	DECLARE Inst_Prospecto			INT(11);			-- Instrumento Prospecto
	DECLARE Inst_Aportacion			INT(11);			-- Instrumento Aportacion

	-- Asignacion  de Constantes
	SET Entero_Cero			:=0;
	SET	Cadena_Vacia		:= '';
	SET	Decimal_Cero		:= 0.0;
	SET Fecha_Vacia 		:='1900-01-01';
	SET Ope_Participante	:= 1;
	SET Ope_Instrumento		:= 2;

	-- Catalogo de Instrumentos
	SET Inst_Cliente			:= 1;
	SET Inst_CuentaAho			:= 2;
	SET Inst_Cede				:= 3;
	SET Inst_Inversion			:= 4;
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;
	SET Inst_Prospecto			:= 7;
	SET Inst_Aportacion			:= 8;

	-- Operacion para obtener el participante
	IF( Par_TipoOperacion = Ope_Participante ) THEN
		IF( Par_TipoInstrumento = Inst_Cliente ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM CLIENTES
			WHERE ClienteID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_CuentaAho ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM CUENTASAHO
			WHERE CuentaAhoiD = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Cede ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM CEDES
			WHERE CedeID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Inversion ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM INVERSIONES
			WHERE InversionID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_SolicitudCredito) THEN
			SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ProspectoID
					END
			INTO Var_ParticipanteID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Credito ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM CREDITOS
			WHERE CreditoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
			SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ProspectoID
					END
			INTO Var_ParticipanteID
			FROM PROSPECTOS
			WHERE ProspectoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Aportacion ) THEN
			SELECT ClienteID
			INTO Var_ParticipanteID
			FROM APORTACIONES
			WHERE AportacionID = Par_NumeroInstrumento;
		END IF;

		SET Var_Resultado := IFNULL(Var_ParticipanteID, Entero_Cero);

	END IF;

	-- operacion para Obtener el Numero de Instrumento
	IF( Par_TipoOperacion = Ope_Instrumento) THEN
		IF( Par_TipoInstrumento = Inst_Cliente ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM CLIENTES
			WHERE ClienteID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_CuentaAho ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM CUENTASAHO
			WHERE CuentaAhoiD = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Cede ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM CEDES
			WHERE CedeID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Inversion ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM INVERSIONES
			WHERE InversionID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_SolicitudCredito) THEN
			SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero)<> Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ProspectoID
					END
			INTO Var_InstrumentoID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Credito ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM CREDITOS
			WHERE CreditoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
			SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN ClienteID
						 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN ProspectoID
					END
			INTO Var_InstrumentoID
			FROM PROSPECTOS
			WHERE ProspectoID = Par_NumeroInstrumento;
		END IF;

		IF( Par_TipoInstrumento = Inst_Aportacion ) THEN
			SELECT ClienteID
			INTO Var_InstrumentoID
			FROM APORTACIONES
			WHERE AportacionID = Par_NumeroInstrumento;
		END IF;

		SET Var_Resultado := IFNULL(Var_InstrumentoID, Entero_Cero);

	END IF;

	RETURN Var_Resultado;

END$$