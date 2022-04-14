DELIMITER ;
DROP FUNCTION IF EXISTS FNTIPOPARTICIPANTEGRDVALORES;

DELIMITER $$
CREATE FUNCTION `FNTIPOPARTICIPANTEGRDVALORES`(
	-- Descripcion	= Funcion retorna el tipo del Participante del expediente o documento en guarda valores
	-- Modulo		= Guarda Valores
	Par_TipoInstrumento			INT(11),		-- Tipo de Intrumento \n1.- Cliente \n2.- Cuenta Ahorro \n3.- CEDE \n 4.- INVERSION
												-- \n5.- Solicitud Credito \n6.- Credito \n7.- Prospecto \n8.- Aportacion
	Par_NumeroInstrumento		BIGINT(20)		-- ID del Instrumento: ClienteID, CuentaAhoID, CedeID, InversionID, CreditoID, SolicitudCreditoID, ProspectoID, AportacionID
) RETURNS CHAR(1)
	DETERMINISTIC
BEGIN

	-- Declaraion de Variables
	DECLARE Var_TipoParticipante	CHAR(1);			-- Tipo de Participante

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Decimal_Cero			DECIMAL(12,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de fecha vacia

	DECLARE Con_Cliente				CHAR(1);			-- Constante de Cliente
	DECLARE Con_Prospecto			CHAR(1);			-- Constante de Prospecto

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
	SET Entero_Cero		:=0;
	SET	Cadena_Vacia	:= '';
	SET	Decimal_Cero	:= 0.0;
	SET Fecha_Vacia 	:='1900-01-01';

	SET Con_Cliente		:= 'C';
	SET Con_Prospecto	:= 'P';

	-- Catalogo de Instrumentos
	SET Inst_Cliente			:= 1;
	SET Inst_CuentaAho			:= 2;
	SET Inst_Cede				:= 3;
	SET Inst_Inversion			:= 4;
	SET Inst_SolicitudCredito	:= 5;
	SET Inst_Credito			:= 6;
	SET Inst_Prospecto			:= 7;
	SET Inst_Aportacion			:= 8;

	SET Var_TipoParticipante := Con_Cliente;

	IF( Par_TipoInstrumento IN (Inst_Cliente, Inst_CuentaAho, Inst_Cede, Inst_Inversion, Inst_Credito, Inst_Aportacion) ) THEN
		SET Var_TipoParticipante := Con_Cliente;
	END IF;

	IF( Par_TipoInstrumento = Inst_SolicitudCredito ) THEN
		SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN Con_Cliente
					 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN Con_Cliente
					 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN Con_Prospecto
				END
		INTO Var_TipoParticipante
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_NumeroInstrumento;
	END IF;

	IF( Par_TipoInstrumento = Inst_Prospecto ) THEN
		SELECT	CASE WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN Con_Cliente
					 WHEN IFNULL(ClienteID, Entero_Cero) <> Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) =  Entero_Cero THEN Con_Cliente
					 WHEN IFNULL(ClienteID, Entero_Cero) =  Entero_Cero AND IFNULL(ProspectoID, Entero_Cero) <> Entero_Cero THEN Con_Prospecto
				END
		INTO Var_TipoParticipante
		FROM PROSPECTOS
		WHERE ProspectoID = Par_NumeroInstrumento;
	END IF;

	RETURN Var_TipoParticipante;

END$$