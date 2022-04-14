-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTERACIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREDWSPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREDWSPRO`(
	-- SP PARA EL PAGO DEL CREDITO CUANDO EL ENVIO ES A TRAVES DEL WS
)
TerminaStore: BEGIN
	DECLARE Var_Ini					INT(11);
    DECLARE Var_Fin					INT(11);

	DECLARE Var_BloqueoID			INT(11);
    DECLARE Var_CuentaAhoID			BIGINT(12);
    DECLARE Var_MontoBloq			DECIMAL(14,2);
    DECLARE Var_Referencia			VARCHAR(250);
    DECLARE Var_TiposBloqID			INT(11);
	DECLARE Var_Descripcion			VARCHAR(250);
    DECLARE Var_Fecha				DATE;
    DECLARE Var_RemitenteID			INT(11);		-- Identificador del Remitente
	DECLARE Var_Destinatario		VARCHAR(200);	-- Correo a Enviar el Mensaje
    DECLARE Con_Asunto              VARCHAR(150);   -- Descripcion del Asunto
	DECLARE	Con_MensajeEnviar		TEXT;			-- Descripcion del Mensaje a Enviar en el Correo
    DECLARE Var_NumError            INT(11);        -- Numero de Error
    DECLARE Var_ErrMensaje          VARCHAR(400);   -- Mensaje de Error

    DECLARE Desbloqueo				CHAR(1);
    DECLARE Mod_Desb				INT(2);
    DECLARE Var_CreditoID			BIGINT(12);
    DECLARE Var_EmpresaID			INT(2);
    DECLARE Cadena_Vacia			CHAR(1);

    DECLARE Modo_Pago				CHAR(1);
    DECLARE Origen					CHAR(1);
    DECLARE Respaldo				CHAR(1);
    DECLARE Entero_Cero				INT(2);
    DECLARE Decimal_Cero			DECIMAL(14,2);

    DECLARE Entero_Uno              CHAR(1);
    DECLARE Nou						CHAR(1);
    DECLARE	Salida_NO				CHAR(1);
    DECLARE Var_NumErr				INT(11);
	DECLARE Var_ErrMen				VARCHAR(400);

    DECLARE	RemitentePagoCre		VARCHAR(50);
	DECLARE CorreoPagoCre			VARCHAR(50);

    DECLARE Aud_Usuario				INT(11);
	DECLARE Aud_FechaActual			DATETIME;
	DECLARE Aud_DireccionIP			VARCHAR(15);
	DECLARE Aud_ProgramaID			VARCHAR(50);
	DECLARE Aud_Sucursal			INT(11);
	DECLARE Aud_NumTransaccion		BIGINT(20);

    SET Desbloqueo		:= 'D';
    SET Mod_Desb		:= 2;
    SET Cadena_Vacia	:= '';
    SET Nou				:= 'N';
    SET Entero_Cero		:= 0;
    SET Decimal_Cero	:= 0.00;
    SET Modo_Pago		:= 'C';
    SET Origen			:= 'S';
    SET Respaldo		:= 'S';
    SET Entero_Uno      :=  1;
    SET Salida_NO       := 'N';
    SET RemitentePagoCre	:= 'RemitentePagoCredito';
	SET CorreoPagoCre		:= 'CorreoPagoCredito';

    SET Aud_FechaActual	:= NOW();
    SET Var_EmpresaID	:= 1;
	SET Aud_Usuario 	:= 1;
	SET Aud_DireccionIP	:= "127.0.0.1";
	SET Aud_ProgramaID	:= "PAGO DE CREDITO WS";
	SET Aud_Sucursal	:= 1;
	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Var_NumErr = 999;
                SET Var_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREDWSPRO');
            END;

        SET Var_RemitenteID 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = RemitentePagoCre);
		SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);
		SET Var_Destinatario	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = CorreoPagoCre);
		SET Var_Destinatario	:= IFNULL(Var_Destinatario, Cadena_Vacia);

		DROP TEMPORARY TABLE IF EXISTS `TMPCUENTASBLOQ`;

		CREATE TEMPORARY TABLE `TMPCUENTASBLOQ` (
			BloqueoID		INT(11),
			CuentaAhoID		BIGINT(12),
			MontoBloq		DECIMAL(14,2),
            Referencia		VARCHAR(250),
            TiposBloqID		INT(11),
			Descripcion		VARCHAR(250)
		);
		INSERT INTO TMPCUENTASBLOQ(BloqueoID,	CuentaAhoID,	MontoBloq,	Referencia,	TiposBloqID,
								   Descripcion)
		SELECT BloqueoID,	CuentaAhoID,	MontoBloq,	Referencia,	TiposBloqID,
			   Descripcion
		FROM BLOQUEOS
			WHERE Descripcion = 'PAGO DE CREDITO' and FechaDEsbloq = '1900-01-01 00:00:00';

        SELECT FechaSistema
			INTO Var_Fecha
        FROM PARAMETROSSIS LIMIT 1;

		SET Var_Ini	:= 0;
		SET Var_Fin		:= (SELECT COUNT(BloqueoID) FROM TMPCUENTASBLOQ);

		WHILE Var_Ini < Var_Fin DO
            SELECT	BloqueoID,		CuentaAhoID,		MontoBloq,		Referencia,		TiposBloqID,
					Descripcion
            INTO	Var_BloqueoID,	Var_CuentaAhoID,	Var_MontoBloq,	Var_Referencia,	Var_TiposBloqID,
					Var_Descripcion
				FROM TMPCUENTASBLOQ LIMIT Var_Ini,1;

			CALL BLOQUEOSPRO(
				Var_BloqueoID,		Desbloqueo,			Var_CuentaAhoID,	Var_Fecha,			Var_MontoBloq,
                Var_Fecha,			Var_TiposBloqID,	Var_Descripcion,	Var_Referencia,		Cadena_Vacia,
                Cadena_Vacia,		Salida_NO,			Var_NumErr,			Var_ErrMen,			Var_EmpresaID,
                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                Aud_NumTransaccion);

				IF(Var_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

            CALL CUENTASAHOWSMOD(
				Var_CuentaAhoID,	Var_MontoBloq,	Mod_Desb,				Salida_NO,			Var_NumErr,
                Var_ErrMen,			Var_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				IF(Var_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			SET Var_CreditoID	:= (SELECT CreditoID FROM CREDITOS WHERE CuentaID = Var_CuentaAhoID);

            CALL PAGOPREPAGOCREDITOPRO(
				Var_CreditoID,		Var_CuentaAhoID,	Var_MontoBloq,         Entero_Uno,         Var_EmpresaID,
                Salida_NO,			Nou,				Decimal_Cero,          Entero_Cero,        Var_NumErr,
                Var_ErrMen,         Entero_Cero,        Modo_Pago,             Origen,             Respaldo,
                Aud_Usuario,	    Aud_FechaActual,	Aud_DireccionIP,       Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

				IF(Var_NumErr != Entero_Cero) THEN
                    SET Var_NumError    := Var_NumErr;
                    SET Var_ErrMensaje  := (SUBSTRING(Var_ErrMen,1,400));
                    SET Con_Asunto          := CONCAT('ERROR AL REALIZAR EL PAGO DEL CR&Eacute;DITO: ', Var_CreditoID);
                    SET Con_MensajeEnviar   := CONCAT('Ha ocurrido un error al realizar el Pago del Cr&eacute;dito: ',Var_CreditoID, ' - ',Var_ErrMensaje);

                    -- SE REGISTRA EN LA BITACORA EN CASO DE HABER UN ERROR
                    CALL BITAERRORPAGOCREDITOALT(
                        'PAGCREDWSPRO',            Var_NumError,           Var_ErrMensaje,         Var_CreditoID,          Var_MontoBloq,
                        Salida_NO,                 Var_NumErr,             Var_ErrMen,             Var_EmpresaID,          Aud_Usuario,
                        Aud_FechaActual,           Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                    IF(Var_RemitenteID > Entero_Cero) THEN
                        -- SE ENVIA CORREO EN CASO DE HABER UN ERROR
						CALL TARENVIOCORREOALT(
							Var_RemitenteID,	Var_Destinatario,		Con_Asunto, 		Con_MensajeEnviar,			Entero_Cero,
							Par_Fecha,			Fecha_Vacia,			'PAGCREDWSPRO',		Cadena_Vacia, 				Salida_NO,
							Var_NumErr,			Var_ErrMen,				Var_EmpresaID,		Aud_Usuario ,				Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);
					END IF;
				END IF;

    		SET Var_Ini := Var_Ini + 1;
    	END WHILE;
        DROP TEMPORARY TABLE IF EXISTS `TMPCUENTASBLOQ`;
    END ManejoErrores;
END TerminaStore$$
