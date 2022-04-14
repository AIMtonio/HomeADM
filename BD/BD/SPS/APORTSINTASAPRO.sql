-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTSINTASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTSINTASAPRO`;DELIMITER $$

CREATE PROCEDURE `APORTSINTASAPRO`(
# ===============================================================================================
# -- SP QUE PAGA LAS APORTACIONES QUE NO ESTEN DENTRO DE LA CONFIGURACION DEL ESQUEMA DE TASAS --
# ===============================================================================================
    Par_Fecha               DATE,			-- Fecha

    INOUT Par_NumErr        INT(11),		-- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),	-- Descripcion de error
    Par_Salida          	CHAR(1),		-- Indica si espera un SELECT de salida

    Par_EmpresaID           INT(11),		-- Parametro de auditoria
    Aud_Usuario         	INT(11),		-- Parametro de auditoria
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria
    Aud_Sucursal            INT(11),		-- Parametro de auditoria
    Aud_NumTransaccion  	BIGINT(20)		-- Parametro de auditoria
			)
TerminaStore : BEGIN
	-- Declaracion de Constantes
	DECLARE SalidaNO        	CHAR(1);
	DECLARE SalidaSI        	CHAR(1);
	DECLARE DecimalCero     	DECIMAL(12,2);
	DECLARE EnteroCero      	INT(1);
	DECLARE EnteroUno       	INT(3);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE PolAutomatica   	CHAR(1);
	DECLARE PagoAportr       	INT(11);
	DECLARE RefePagoAport    	VARCHAR(50);
	DECLARE MovPagCedCap    	VARCHAR(4);
	DECLARE ConCedCapi      	INT(11);
	DECLARE ConCapital      	INT(11);
	DECLARE NatAbono        	CHAR(1);
	DECLARE NatCargo        	CHAR(1);
	DECLARE AltPolizaNO     	CHAR(1);
	DECLARE MovAhorroSI     	CHAR(1);
	DECLARE MovAhorroNO     	CHAR(1);
	DECLARE MovPagIntExe    	VARCHAR(4);
	DECLARE CuePagIntExe    	VARCHAR(50);
	DECLARE MovPagIntGra    	VARCHAR(4);
	DECLARE CuePagIntGra    	VARCHAR(50);
	DECLARE ConCedProv      	INT(11);
	DECLARE TipoProvision   	VARCHAR(4);
	DECLARE MovPagCedRet    	VARCHAR(4);
	DECLARE CueRetAportr     	VARCHAR(50);
	DECLARE OpeInterna      	CHAR(1);
	DECLARE TipCompra       	CHAR(1);
	DECLARE NombreProceso   	VARCHAR(10);
	DECLARE ConCedISR       	INT(11);
	DECLARE EstPagado       	CHAR(1);
	DECLARE ProcSinTasa     	INT(11);
    DECLARE ProcesoAport     	INT(11);
	DECLARE Var_ProVenMasi  	VARCHAR(100);
    DECLARE	Fecha_Vacia			DATE;
	DECLARE ErrorUno            VARCHAR(400);
	DECLARE ErrorDos            VARCHAR(400);
	DECLARE ErrorTres           VARCHAR(400);
	DECLARE ErrorCuatro         VARCHAR(400);
	DECLARE InstAport            INT(11);
	DECLARE InicioMes           DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Tasa_Fija           CHAR(1);


	-- Declaracion de Variables
	DECLARE Var_NumAportaciones INT(11);			-- Numero de aportaciones
	DECLARE Var_Poliza          BIGINT(20);			-- Poliza
	DECLARE Var_AportacionID    INT(11);			-- ID de la aportacion
	DECLARE Var_CuentaAhoID     BIGINT(20);			-- ID de la cuenta de ahorro
	DECLARE Var_TipoAportID     INT(11);			-- ID del tipo de aportacion
	DECLARE Var_MonedaID        INT(11);			-- ID de la moneda
	DECLARE Var_Monto           DECIMAL(18,2);		-- Monto de la aportacion
	DECLARE Var_InteresGenerado DECIMAL(18,2);		-- Interes generado
	DECLARE Var_InteresRetener  DECIMAL(18,2);		-- Interes a retener
	DECLARE Var_InteresRecibir  DECIMAL(18,2);		-- Interes a recibir
	DECLARE Var_SaldoProvision  DECIMAL(18,2);		-- Saldo provision
	DECLARE Var_ClienteID       INT(11);			-- ID del cliente
	DECLARE Var_SucOrigen       INT(11);			-- Sucursal origen
	DECLARE Var_TasaFV          CHAR(1);			-- Tasa fija/variable
	DECLARE Var_AmortizacionID  INT(11);			-- ID de la amortizacion
	DECLARE Var_ErrorKey        INT(11) DEFAULT 0;	-- Clave de error
	DECLARE Var_InteresPagar    DECIMAL(18,2);		-- Interes a pagar
	DECLARE Var_MovIntere       VARCHAR(4);			-- Movimiento interes
	DECLARE Cue_PagIntere       VARCHAR(50);		-- Pago interes
	DECLARE Var_Instrumento     VARCHAR(15);		-- Instrumento
	DECLARE Var_CuentaStr       VARCHAR(15);		-- Cuenta
	DECLARE Var_MonedaBase      INT(11);			-- Moneda base
	DECLARE Var_TipCamCom       DECIMAL(14,6);		-- Tipo cambio
	DECLARE Var_IntRetMN        DECIMAL(12,2);		-- Interes retener MN
	DECLARE Var_FechaIncio      DATE;				-- Fecha de inicio
	DECLARE Var_FechaVencimi    DATE;				-- Fecha de vencimiento
	DECLARE Var_TasaISR		    DECIMAL(14,2);		-- Tasa de ISR
	DECLARE Var_PagaISR		    CHAR(1);			-- Paga ISR
	DECLARE Var_AportStr        VARCHAR(15);		-- Aportacion
    DECLARE	Var_FechaBatch		DATE;				-- Fecha batch
	DECLARE Var_FecBitaco   	DATETIME;			-- Fecha bitacora
	DECLARE Var_MinutosBit  	INT(11);			-- Minutos bitacora
    DECLARE Var_FechaInicio  	DATE;				-- Fecha de inicio
    DECLARE Var_FechaVencimiento	DATE;			-- Fecha Vencimiento
    DECLARE Var_MontoAport      DECIMAL(14,2);		-- Monto de la aportacion
    DECLARE Var_Tasa			DECIMAL(14,4);		-- Tasa

	-- Declaracion de Cursores
	DECLARE PAGOAPORTCUR CURSOR FOR
	  SELECT    apors.AportacionID,            	apors.CuentaAhoID,     		MAX(apors.TipoAportacionID),      	MAX(apors.MonedaID),        	MAX(apors.Monto),
				MAX(apors.InteresGenerado),  MAX(apors.InteresRetener),  	MAX(apors.InteresRecibir),	MAX(apors.SaldoProvision),	apors.ClienteID,
				MAX(cte.SucursalOrigen),    MAX(apors.TasaFV),          	MAX(apors.AmortizacionID),	MAX(apors.FechaInicio),		MAX(apors.FechaVencimiento),
				MAX(apors.TasaISR),		  	MAX(cte.PagaISR)
			FROM APORTSINTASA apors
				INNER JOIN APORTACIONES ced ON apors.AportacionID = ced.AportacionID AND ced.Estatus = 'N'
				INNER JOIN CLIENTES cte ON  apors.ClienteID = cte.ClienteID
					GROUP BY apors.ClienteID,apors.AportacionID,apors.CuentaAhoID;

	-- Asignacion de Constantes
	SET SalidaNO        := 'N';
	SET SalidaSI        := 'S';
	SET DecimalCero     := 0.0;
	SET EnteroCero      := 0;
	SET EnteroUno      	:= 1;
	SET Cadena_Vacia    := '';
	SET PolAutomatica   := 'A';
	SET PagoAportr      := 902;      		-- Concepto Contable: Pago de Aportacion
	SET RefePagoAport   := 'VENCIMIENTO DE APORTACION';           -- Descripcion Referencia
	SET MovPagCedCap    := '602';        	-- PAGO APORTACION. CAPITAL
	SET ConCedCapi      := 1;           	-- Concepto Contable de Aportacion: Capital
	SET ConCapital      := 1;           	-- Concepto Contable de Ahorro: Capital
	SET NatAbono        := 'A';
	SET NatCargo        := 'C';
	SET AltPolizaNO     := 'N';
	SET MovAhorroSI     := 'S';         	-- Movimiento de Ahorro: SI
	SET MovAhorroNO     := 'N';         	-- Movimiento de Ahorro: NO
	SET MovPagIntExe    := '604';        	-- PAGO APORTACION. INTERES EXCENTO
	SET CuePagIntExe    := 'INTERESES GENERADOS';   -- Descripcion Interes Excento
	SET MovPagIntGra    := '603';       	 -- PAGO APORTACION. INTERES GRAVADO
	SET CuePagIntGra    := 'INTERESES GENERADOS';    -- Descripcion Interes Gravado
	SET ConCedProv      := 5;           	-- Concepto Contable de Aportacion: Provision
	SET TipoProvision   := '100';      		-- Tipo de Movimiento de Aportacion: Provision
	SET MovPagCedRet    := '605';        	-- PAGO APORTACION. RETENCION
	SET CueRetAportr    := 'RETENCION ISR';	-- rDescripcion Retenciuon ISR
	SET OpeInterna      := 'I';         	-- Tipo de Operacion: Interna
	SET TipCompra       := 'C';         	-- Tipo de Operacion: Compra de Divisa
	SET NombreProceso   := 'APORTACION';          --  Descripcion Nombre Proceso
	SET ConCedISR       := 4;           	-- Concepto Contable de Aportacion: Retencion
	SET EstPagado       := 'P';        		-- Estatus de la Aportacion: Pagada
	SET ProcSinTasa     :=  1515;
	SET ProcesoAport     :=  1515;
	SET Var_ProVenMasi  := '/microfin/vencMasivoAportVista.htm';
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET ErrorUno        := 'ERROR DE SQL GENERAL';
	SET ErrorDos        := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET ErrorTres       := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET ErrorCuatro     := 'ERROR VALORES NULOS';
	SET InstAport       := 28;
	SET InicioMes       := CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);   -- Fecha de Inicio del Mes a Trabajar.
	SET Entero_Cero     := 0;
	SET Tasa_Fija       := 'F';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-APORTSINTASAPRO');
			END;

		SET Aud_FechaActual := NOW();
		SET Var_FecBitaco := Aud_FechaActual;

        SELECT MonedaBaseID INTO Var_MonedaBase
		FROM PARAMETROSSIS;

		-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoAport,			Par_Fecha,			Var_FechaBatch,		EnteroUno,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = Var_ProVenMasi) THEN

			TRUNCATE TABLE APORTSINTASA;
			INSERT INTO APORTSINTASA (
					AportacionID,      CuentaAhoID,        TipoAportacionID,             MonedaID,               FechaInicio,
					Monto,                  Plazo,                  Tasa,                   TasaISR,                TasaNeta,
					InteresGenerado,        InteresRetener,         InteresRecibir,         SaldoProvision,         AmortizacionID,
					ClienteID,              TasaFV,					FechaVencimiento)
			SELECT
					aport.AportacionID,            aport.CuentaAhoID,       aport.TipoAportacionID,        aport.MonedaID,          aport.FechaInicio,
					aport.Monto,             aport.Plazo,             aport.Tasa,              aport.TasaISR,           aport.TasaNeta,
					aport.InteresGenerado,   aport.InteresRetener,    aport.InteresRecibir,    aport.SaldoProAcumulado, aport.AmortizacionID,
					aport.ClienteID,         aport.TasaFV,			Amo.FechaVencimiento
				FROM 	TMPAPORTACIONES aport INNER JOIN AMORTIZAAPORT Amo ON   Amo.AportacionID=aport.AportacionID AND Amo.AmortizacionID=aport.AmortizacionID
				WHERE 	aport.NuevaTasa <= DecimalCero;

			SELECT  COUNT(AportacionID) INTO  Var_NumAportaciones    FROM APORTSINTASA;
			SET Var_NumAportaciones  :=  IFNULL(Var_NumAportaciones,EnteroCero);

			IF(Var_NumAportaciones > EnteroCero) THEN
				CALL MAESTROPOLIZASALT(
					Var_Poliza,         Par_EmpresaID,      Par_Fecha,      PolAutomatica,      PagoAportr,
					RefePagoAport,       SalidaNO,           Par_NumErr,     Par_ErrMen,         Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
					LEAVE ManejoErrores;
				END IF;
			ELSE

				SET Par_NumErr  :=  0;
				SET Par_ErrMen  :=  'Pago Aportaciones sin Tasa Realizado Exitosamente.';

				IF(Aud_ProgramaID!=Var_ProVenMasi) THEN
					SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
					SET Aud_FechaActual := NOW();

					CALL BITACORABATCHALT(
						ProcesoAport,      	Par_Fecha,        Var_MinutosBit,    	Par_EmpresaID,    Aud_Usuario,
                        Aud_FechaActual, 	Aud_DireccionIP,  Aud_ProgramaID,		Aud_Sucursal,     Aud_NumTransaccion);
				END IF;

				SET Var_FecBitaco := NOW();
				LEAVE ManejoErrores;

			END IF;


			OPEN PAGOAPORTCUR;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOPAGOAPORTCUR:LOOP
				FETCH PAGOAPORTCUR INTO
				Var_AportacionID,             Var_CuentaAhoID,    Var_TipoAportID,     Var_MonedaID,       Var_Monto,
				Var_InteresGenerado,    Var_InteresRetener, Var_InteresRecibir, Var_SaldoProvision, Var_ClienteID,
				Var_SucOrigen,          Var_TasaFV,         Var_AmortizacionID,	Var_FechaIncio,		Var_FechaVencimi,
				Var_TasaISR,			Var_PagaISR;

				START TRANSACTION;
				ErrorCursor:BEGIN -- Inicia BEGIN Start Transaction
					DECLARE EXIT HANDLER FOR SQLEXCEPTION   SET Var_ErrorKey  = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Var_ErrorKey  = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Var_ErrorKey  = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Var_ErrorKey  = 4;
					DECLARE EXIT HANDLER FOR NOT FOUND SET Var_ErrorKey = 1;

					SET Aud_FechaActual := NOW();
					SET Var_InteresPagar := EnteroCero;

					IF (Var_Monto > EnteroCero) THEN
						CALL CONTAAPORTPRO(
							Var_AportacionID,         Par_EmpresaID,  Par_Fecha,      Var_Monto,          MovPagCedCap,
							PagoAportr,          ConCedCapi,     ConCapital,     NatAbono,           AltPolizaNO,
							MovAhorroSI,        SalidaNO,       Var_Poliza,     Par_NumErr,         Par_ErrMen,
							Var_CuentaAhoID,    Var_ClienteID,  Var_MonedaID,   Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID, Var_SucOrigen,  Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;
					END IF;


					IF (Var_InteresRetener = EnteroCero) THEN
						SET Var_MovIntere := MovPagIntExe;
						SET Cue_PagIntere := CuePagIntExe;
					ELSE
						SET Var_MovIntere := MovPagIntGra;
						SET Cue_PagIntere := CuePagIntGra;
					END IF;

					IF( Var_TasaFV = Tasa_Fija) THEN
						SET Var_InteresPagar := Var_SaldoProvision;
					ELSE
						SET Var_InteresPagar := Var_SaldoProvision;
					END IF;
					-- Pago de Rendimiento
					IF(Var_InteresPagar > EnteroCero) THEN
						CALL CONTAAPORTPRO(
							Var_AportacionID,    Par_EmpresaID,  Par_Fecha,      Var_InteresPagar,   Var_MovIntere,
							PagoAportr,          ConCedProv,     ConCapital,     NatAbono,           AltPolizaNO,
							MovAhorroSI,        SalidaNO,       Var_Poliza,     Par_NumErr,         Par_ErrMen,
							Var_CuentaAhoID,    Var_ClienteID,  Var_MonedaID,   Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID, Var_SucOrigen,  Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						CALL APORTMOVALT(
							Var_AportacionID,     Par_Fecha,          TipoProvision,      Var_InteresPagar,   NatAbono,
							Cue_PagIntere,  Var_MonedaID,       SalidaNO,           Par_NumErr,         Par_ErrMen,
							Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
							Aud_Sucursal,   Aud_NumTransaccion  );

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						SET Var_Instrumento := CONVERT(Var_AportacionID, CHAR);
						SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);

                         -- Se obtiene la fecha de inicio y vencimiento de la amortizacion
                        SET Var_FechaInicio 		:= (SELECT FechaInicio FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
                        SET Var_FechaVencimiento 	:= (SELECT FechaVencimiento FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);

                        -- Se obtiene el Monto de la Aportacion
                        SET Var_MontoAport 	:= (SELECT Monto FROM APORTACIONES WHERE AportaID = Var_AportacionID);
                        SET Var_MontoAport	:= IFNULL(Var_MontoAport,DecimalCero);

						SET Var_Tasa	:=(SELECT TasaFija FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
						SET Var_Tasa	:=IFNULL(Var_Tasa,EnteroCero);

                        -- Registro de informacion para el Calculo del Interes Real para Aportaciones
						CALL CALCULOINTERESREALALT (
							 Var_ClienteID,		Par_Fecha,			InstAport,		   Var_AportacionID,	Var_MontoAport,
							 Var_InteresPagar,	Var_InteresRetener,	Var_Tasa,			Var_FechaInicio,Var_FechaVencimiento,
                             Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,   Aud_DireccionIP,	Aud_ProgramaID,
                             Aud_Sucursal,		Aud_NumTransaccion);

					END IF;
					-- Fin Pago de Rendimiento

					-- Retencion ISR
					IF (Var_InteresRetener > EnteroCero) THEN

						CALL CUENTASAHORROMOVALT(
							Var_CuentaAhoID,    Aud_NumTransaccion, Par_Fecha,          NatCargo,           Var_InteresRetener,
							CueRetAportr,        Var_Instrumento,    MovPagCedRet,       SalidaNO,           Par_NumErr,
							Par_ErrMen,			Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						CALL POLIZASAHORROPRO(
							Var_Poliza,         Par_EmpresaID,      Par_Fecha,          Var_ClienteID,      ConCapital,
							Var_CuentaAhoID,    Var_MonedaID,       Var_InteresRetener, EnteroCero,         CueRetAportr,
							Var_CuentaStr,      SalidaNO,           Par_NumErr,         Par_ErrMen,			Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucOrigen,      Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						IF (Var_MonedaBase != Var_MonedaID) THEN
							SET Var_TipCamCom :=  (SELECT TipCamConInt
										  FROM MONEDAS
										  WHERE MonedaID  = Var_MonedaID);


							SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

							CALL COMVENDIVISAALT(
							  Var_MonedaID,     Aud_NumTransaccion, Par_Fecha,          Var_InteresRetener, Var_TipCamCom,
							  OpeInterna,       TipCompra,          Var_Instrumento,    RefePagoAport,       NombreProceso,
							  Var_Poliza,       Par_EmpresaID,     	Aud_Usuario,      	Aud_FechaActual,    Aud_DireccionIP,
                              Aud_ProgramaID,   Var_SucOrigen,      Aud_NumTransaccion);

						ELSE
							SET Var_IntRetMN := Var_InteresRetener;
						END IF;

						CALL CONTAAPORTPRO(
							Var_AportacionID,    Par_EmpresaID,      Par_Fecha,          Var_IntRetMN,       Cadena_Vacia,
							PagoAportr,          ConCedISR,          EnteroCero,         NatAbono,           AltPolizaNO,
							MovAhorroNO,        SalidaNO,           Var_Poliza,         Par_NumErr,         Par_ErrMen,
							Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,     Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID,     Var_SucOrigen,      Aud_NumTransaccion);

							IF(Par_NumErr != EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;
						END IF;
					-- Fin de Retencion ISR

						-- Se Actualiza la Ultima Amotizacion a Pagada
						UPDATE AMORTIZAAPORT Amo
						  SET 	Amo.Estatus   		= EstPagado,
								EmpresaID       	= Par_EmpresaID,
								Usuario         	= Aud_Usuario,
								FechaActual     	= Aud_FechaActual,
								DireccionIP     	= Aud_DireccionIP,
								ProgramaID      	= Aud_ProgramaID,
								Sucursal        	= Aud_Sucursal,
								NumTransaccion  	= Aud_NumTransaccion
						WHERE	Amo.AportacionID    = Var_AportacionID
						AND 	Amo.Estatus   		!= EstPagado
						AND 	Amo.AmortizacionID	= Var_AmortizacionID;

					  -- Fin de la Actualizacion de la Ultima Amotizacion a Pagada

						UPDATE APORTACIONES
						  SET	Estatus     	= EstPagado,
								EmpresaID     	= Par_EmpresaID,
								UsuarioID     	= Aud_Usuario,
								FechaActual   	= Aud_FechaActual,
								DireccionIP   	= Aud_DireccionIP,
								ProgramaID    	= Aud_ProgramaID,
								Sucursal    	= Aud_Sucursal,
								NumTransaccion	= Aud_NumTransaccion
						WHERE	AportacionID	= Var_AportacionID;

					  /*SE ACTUALIZA EL SALDO PROVISION aportaciones*/
						UPDATE APORTACIONES SET
							SaldoProvision= SaldoProvision - Var_SaldoProvision
						WHERE AportacionID = Var_AportacionID;

					END ErrorCursor;-- Termina BEGIN Start Transaction

					SET Var_AportStr := CONVERT(Var_AportacionID, CHAR);

					IF (Var_ErrorKey = 0) THEN
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 1) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,          Var_AportStr,      ErrorUno,
							  Par_EmpresaID,    Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 2) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,       Var_AportStr,     ErrorDos,
							  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 3) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,      Var_AportStr,      	ErrorTres,
							  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  	Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 4) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								ProcSinTasa,    	Par_Fecha,     	Var_AportStr,     	ErrorCuatro,
								Par_EmpresaID,    	Aud_Usuario,    Aud_FechaActual, 	Aud_DireccionIP,
								Aud_ProgramaID,   	Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 99) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								ProcSinTasa,    	Par_Fecha,      Var_AportStr,     	CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Par_EmpresaID,    	Aud_Usuario,    Aud_FechaActual,  	Aud_DireccionIP,
								Aud_ProgramaID,   	Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

				END LOOP CICLOPAGOAPORTCUR;
			END;
			CLOSE PAGOAPORTCUR;

			/*SE ELIMINAN LAS APORTACIONES QUE NO TIENEN TASA*/
			DELETE FROM TMPAPORTACIONES WHERE NuevaTasa <= DecimalCero;

			IF(Par_NumErr = EnteroCero) THEN
				SET Par_NumErr  :=  EnteroCero;
				SET Par_ErrMen  :=  'Pago Aportaciones sin Tasa Realizado Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo aportaciones*/
			IF(Aud_ProgramaID!=Var_ProVenMasi)THEN
				CALL BITACORABATCHALT(
					ProcesoAport,        Par_Fecha,          Var_MinutosBit,      	Par_EmpresaID,    	Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,  		Aud_Sucursal,     Aud_NumTransaccion);
			END IF;
			SET Var_FecBitaco := NOW();

		END IF;

        SET Par_NumErr  :=  EnteroCero;
		SET Par_ErrMen  :=  'Pago Aportaciones sin Tasa Realizado Exitosamente.';

	END ManejoErrores;
	  IF (Par_Salida = SalidaSI) THEN
		  SELECT  	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
		END IF;

END TerminaStore$$