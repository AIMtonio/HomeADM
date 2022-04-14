-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREAUTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREAUTPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOCREAUTPRO`(
	-- SP QUE REALIZA LA COBRANZA DE CREDITOS AUTOMATICOS
    Par_Fecha           	DATE,			-- Fecha de Aplicacion
    Par_Salida				CHAR(1),		-- Par_Salida
	INOUT	Par_NumErr		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

    -- Parametros de Auditoria
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_FecActual   	DATETIME;
DECLARE Var_Empresa     	INT;
DECLARE Var_TotalAde    	DECIMAL(14,2);
DECLARE Var_MontoPag    	DECIMAL(14,2);
DECLARE Var_CueClienID  	BIGINT;
DECLARE Var_Cue_Saldo		DECIMAL(12,2);
DECLARE Var_CueMoneda  	 	INT;
DECLARE Var_CueEstatus  	CHAR(1);
DECLARE Var_NumRegistros	INT(11);
DECLARE Var_Contador		INT(11);
DECLARE Var_CreditoID		BIGINT(12);
DECLARE Var_CuentaAhoID		BIGINT(12);
DECLARE Var_MontoPago		DECIMAL(12,2);
DECLARE	Var_MonedaID		INT(11);
DECLARE Var_Poliza 			BIGINT(20);		-- Numero de Poliza
DECLARE Var_PagoAplica      DECIMAL(14,2);
DECLARE Par_Consecutivo	 	BIGINT(20);
DECLARE Var_CreditoStr		VARCHAR(30);	-- Numero de Credito
DECLARE Error_Key			INT(11);		-- Numero de Error
DECLARE Var_RemitenteID		INT(11);		-- Identificador del Remitente
DECLARE Var_Destinatario	VARCHAR(200);	-- Correo a Enviar el Mensaje
DECLARE	Con_Asunto			VARCHAR(150);	-- Descripcion del Asunto
DECLARE	Con_MensajeEnviar	TEXT;			-- Descripcion del Mensaje a Enviar en el Correo
DECLARE	Var_NumErr			INT(11);		-- Numero de Error
DECLARE	Var_ErrMen			VARCHAR(400);	-- Mensaje de Error

DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero    	 	INT;
DECLARE Decimal_Cero   		DECIMAL(12,2);
DECLARE EstatusVigente  	CHAR(1);
DECLARE EstatusAtraso   	CHAR(1);
DECLARE EstatusVencido  	CHAR(1);

DECLARE Si_Prorratea    	CHAR(1);
DECLARE Con_CredPorPag  	INT;
DECLARE Con_CredGrupo   	INT;
DECLARE Con_CredPorPagCom	INT(11);
DECLARE ForCobroProg		CHAR(1);
DECLARE Prorratea_SI		CHAR(1);
DECLARE Prorratea_NO		CHAR(1);
DECLARE TipoPoliza			CHAR(1);		-- Tipo Poliza   A:Automatica
DECLARE Con_PagoCred    	INT(11);
DECLARE Desc_PagoCred		VARCHAR(50);
DECLARE SalidaNO			CHAR(1);
DECLARE AltaPoliza_NO		CHAR(1);		-- Constante: Alta de Poliza = NO
DECLARE PrePago_NO          CHAR(1);
DECLARE Finiquito_NO		CHAR(1);
DECLARE CargoCuenta			CHAR(1); -- Indica que se trata de un pago con cargo a cuenta
DECLARE Con_Origen			CHAR(1);
DECLARE Pro_CobCreAut		INT(11);
DECLARE Des_ErrorGral		VARCHAR(100);
DECLARE Des_ErrorLlavDup	VARCHAR(100);
DECLARE Des_ErrorCallSP		VARCHAR(100);
DECLARE Des_ErrorValNulos	VARCHAR(100);
DECLARE RespaldaCredSI		CHAR(1);
DECLARE	RemitentePagoCre	VARCHAR(50);
DECLARE CorreoPagoCre		VARCHAR(50);

SET Cadena_Vacia    	:= '';        		-- Constante Cadena Vacia
SET Fecha_Vacia     	:= '1900-01-01';	-- Constante Fecha Vacia
SET Entero_Cero     	:= 0;               -- Constante Entero Cero
SET Decimal_Cero      	:= 0.00;			-- Constante Decimal Cero
SET EstatusVigente  	:= 'V';            	-- Estatus Vigente
SET EstatusAtraso   	:= 'A';          	-- Estatus Atrasado
SET EstatusVencido  	:= 'B';            	-- Estatus Vencido
SET Si_Prorratea    	:= 'S';
SET Con_CredPorPag 	 	:= 1;
SET Con_CredGrupo   	:= 2;
SET Con_CredPorPagCom	:= 3;
SET ForCobroProg		:= 'P'; 	-- Forma de Cobro de la comision P:Programado
SET Prorratea_SI		:= 'S';		-- Prorratea SI
SET Prorratea_NO		:= 'N';
SET TipoPoliza			:= 'A';		-- Poliza Automatica
SET Con_PagoCred		:= 54;		-- Concepto Pago de Credito
SET Desc_PagoCred    	:= 'PAGO DE CREDITO';	-- Descripcion del Concepto, Pago de Credito
SET SalidaNO			:= 'N';		-- Constante SALIDA:NO
SET AltaPoliza_NO		:= 'N';				-- Alta del Encabezado de la Poliza: NO
SET PrePago_NO         	:= 'N';             -- El Tipo de Pago No es PrePago
SET Finiquito_NO		:= 'N';
SET CargoCuenta			:= 'C';		-- Cargo a Cuenta
SET Con_Origen			:= 'K';		-- Cobranza de Origen creditos automaticos
SET Pro_CobCreAut		:= 212;		-- Proceso Batch para realizar el cobro de creditos automaticos
SET Des_ErrorGral		:= 'ERROR DE SQL GENERAL';
SET Des_ErrorLlavDup	:= 'ERROR EN ALTA, LLAVE DUPLICADA';
SET Des_ErrorCallSP		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
SET Des_ErrorValNulos	:= 'ERROR VALORES NULOS';
SET Aud_ProgramaID		:= 'PAGOCREAUTPRO';
SET RespaldaCredSI		:= 'S';
SET RemitentePagoCre	:= 'RemitentePagoCredito';
SET CorreoPagoCre		:= 'CorreoPagoCredito';

SELECT FechaSistema, EmpresaDefault	 INTO Var_FecActual,	Var_Empresa
	FROM PARAMETROSSIS;


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREAUTPRO');
		END;

	SET Var_RemitenteID 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = RemitentePagoCre);
	SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);
	SET Var_Destinatario	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = CorreoPagoCre);
	SET Var_Destinatario	:= IFNULL(Var_Destinatario, Cadena_Vacia);

	-- SE CREA LA TABLA CON LOS CREDITOS QUE PRESENTAN ADEUDOS AL DIA DE HOY
	DROP TABLE IF EXISTS CREDITOSCOBRAUT;
	CREATE TABLE CREDITOSCOBRAUT (
		Consecutivo		INT		(11)	NOT NULL,
		CreditoID 		BIGINT 	(12)  	NOT NULL COMMENT 'Credito ID',
		Ciclo			INT    	(11)    NOT NULL COMMENT 'Ciclo',
		GrupoID			INT		(11)	NOT NULL COMMENT 'Grupo ID',
		CuentaAhoID		BIGINT	(12)	NOT NULL COMMENT 'CuentaAho ID',
		Exigible		DECIMAL (18,2)	NOT NULL COMMENT 'Exigible',
		Moneda			INT		(11)	NOT NULL COMMENT 'Moneda',
		ProrrateaPago	CHAR	(1)		NOT NULL COMMENT 'Prorratea SI o NO',
		PRIMARY KEY (`Consecutivo`)

	   ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar Para la Cobranza';


	-- SE INSERTAN LOS REGISTROS A LA TABLA
	INSERT INTO CREDITOSCOBRAUT(
		Consecutivo,	CreditoID,		GrupoID,		Ciclo,		CuentaAhoID,
		Exigible,		Moneda,			ProrrateaPago)

	 SELECT	@s:=@s+1 AS Consecutivo,	Amo.CreditoID, 	MAX(IFNULL(Cre.GrupoID, Entero_Cero)),
			MAX(IFNULL(Cre.CicloGrupo, Entero_Cero)),	MAX(Amo.CuentaID),						FUNCIONEXIGIBLE(Amo.CreditoID),
			MAX(Cre.MonedaID), 			MAX(IFNULL(Integ.ProrrateaPago,Prorratea_NO)) AS ProrrateaPago
	FROM AMORTICREDITO Amo
		INNER JOIN CUENTASAHO Cue
			ON Amo.CuentaID	= Cue.CuentaAhoID
		INNER JOIN CREDITOS Cre
			ON Amo.CreditoID = Cre.CreditoID
		LEFT JOIN  INTEGRAGRUPOSCRE Integ
			ON Cre.GrupoID = Integ.GrupoID,
		(SELECT @s:= Entero_Cero) AS S
	WHERE Amo.FechaExigible <= DATE(Var_FecActual)
		AND (Amo.Estatus = EstatusVigente OR Amo.Estatus = EstatusAtraso OR	Amo.Estatus = EstatusVencido	)
		AND Amo.CuentaID = Cue.CuentaAhoID
		AND Cue.SaldoDispon	> Decimal_Cero
		AND Amo.CreditoID = Cre.CreditoID
        AND Cre.EsAutomatico = 'S'
        AND Cre.TipoAutomatico = 'I'
	GROUP BY Amo.CreditoID,Amo.FechaExigible
	ORDER BY Consecutivo, Amo.FechaExigible;



	SET	Var_NumRegistros	:= (SELECT COUNT(*) FROM CREDITOSCOBRAUT);
	SET	Var_Contador		:=	1;

   -- SE CREA EL ENCABEZADO DE LA POLIZA
	IF (Var_NumRegistros > Entero_Cero) THEN
		CALL MAESTROPOLIZASALT(
			Var_Poliza,			Par_EmpresaID,      Par_Fecha,     	TipoPoliza,			Con_PagoCred,
			Desc_PagoCred,		Par_Salida,       	Par_NumErr,		Par_ErrMen,			Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion);
	END IF;


     -- CICLO PARA RECORRER LA TABLA Y REALIZAR EL PAGO DE LOS CREDITOS
    WHILE(Var_Contador <= Var_NumRegistros) DO
		-- SE OBTIENEN LOS DATOS DE MANERA INDIVIDUAL
		SELECT CreditoID,		CuentaAhoID,		Exigible,			Moneda
        INTO Var_CreditoID,    	Var_CuentaAhoID,    Var_MontoPago,  	Var_MonedaID
        FROM CREDITOSCOBRAUT
        WHERE Consecutivo = Var_Contador;

        START TRANSACTION;
			Transaccion: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


				SET Error_Key		:= Entero_Cero;

				SET Var_PagoAplica  := IFNULL(Var_PagoAplica, Decimal_Cero);
                SET Var_CreditoID 	:= IFNULL(Var_CreditoID, Entero_Cero);
                SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
                SET Var_MontoPago	:= IFNULL(Var_MontoPago, Decimal_Cero);
                SET Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);

				-- SE REALIZA EL PAGO DEL CREDITO
				CALL PAGOCREDITOPRO(
						Var_CreditoID,    	Var_CuentaAhoID,    Var_MontoPago,  	Var_MonedaID,       PrePago_NO,
						Finiquito_NO,       Par_EmpresaID,      Par_Salida,       	AltaPoliza_NO,		Var_PagoAplica,
						Var_Poliza,       	Par_NumErr,         Par_ErrMen,     	Par_Consecutivo,	CargoCuenta,
						Con_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Error_Key := 99;
					SET Var_Contador := Var_Contador + 1;
					LEAVE Transaccion;
				END IF;

				SET Var_Contador := Var_Contador + 1; -- Incrementa el contador
		END;

        SET Var_CreditoStr = CONCAT(CONVERT(Var_CreditoID, CHAR)) ;
			IF Error_Key = 0 THEN
				COMMIT;
			END IF;
			IF Error_Key = 1 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_CobCreAut,	Par_Fecha,			Var_CreditoStr,		Des_ErrorGral,		Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 2 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_CobCreAut,	Par_Fecha,			Var_CreditoStr,		Des_ErrorLlavDup,		Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 3 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_CobCreAut,	Par_Fecha,			Var_CreditoStr,			Des_ErrorCallSP,	Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 4 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_CobCreAut,	Par_Fecha,			Var_CreditoStr,		Des_ErrorValNulos,			Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
            IF Error_Key = 99 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_CobCreAut,	Par_Fecha,			Var_CreditoStr,		CONCAT(Par_NumErr,': ', Par_ErrMen),			Par_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);

					SET Var_NumErr 	:= Par_NumErr;
					SET Var_ErrMen	:= (SUBSTRING(Par_ErrMen,1,400));
					SET Con_Asunto 			:= CONCAT('ERROR AL REALIZAR EL PAGO DEL CR&Eacute;DITO: ', Var_CreditoID);
					SET Con_MensajeEnviar	:= CONCAT('Ha ocurrido un error al realizar el Pago del Cr&eacute;dito: ',Var_CreditoID, ' - ',Var_ErrMen);

					-- SE REGISTRA EN LA BITACORA EN CASO DE HABER UN ERROR
					CALL BITAERRORPAGOCREDITOALT(
                        'PAGOCREAUTPRO',            Var_NumErr,             Var_ErrMen,				Var_CreditoID,          Var_MontoPago,
                        SalidaNO,                  	Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
                        Aud_FechaActual,            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

					IF(Var_RemitenteID > Entero_Cero) THEN
						-- SE ENVIA CORREO EN CASO DE HABER UN ERROR
						CALL TARENVIOCORREOALT(
							Var_RemitenteID,	Var_Destinatario,		Con_Asunto, 		Con_MensajeEnviar,			Entero_Cero,
							Par_Fecha,			Fecha_Vacia,			'PAGOCREAUTPRO',	Cadena_Vacia, 				SalidaNO,
							Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario ,				Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);
					END IF;

				COMMIT;
			END IF;
    END WHILE;

END ManejoErrores;

END TerminaStore$$