-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESSINTASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESSINTASAPRO`;DELIMITER $$

CREATE PROCEDURE `CEDESSINTASAPRO`(
# ========================================================================================
# -- SP QUE PAGA LOS CEDES QUE NO ESTEN DENTRO DE LA CONFIGURACION DEL ESQUEMA DE TASAS --
# ========================================================================================
    Par_Fecha               DATE,			-- Fecha

    INOUT Par_NumErr        INT(11),		-- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),	-- Descripcion de error
    Par_Salida          	CHAR(1),		-- Indica si espera un SELECT de salida

    Par_EmpresaID           INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion  	BIGINT(20)
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
	DECLARE PagoCeder       	INT(11);
	DECLARE RefePagoCede    	VARCHAR(50);
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
	DECLARE CueRetCeder     	VARCHAR(50);
	DECLARE OpeInterna      	CHAR(1);
	DECLARE TipCompra       	CHAR(1);
	DECLARE NombreProceso   	VARCHAR(10);
	DECLARE ConCedISR       	INT(11);
	DECLARE EstPagado       	CHAR(1);
	DECLARE ProcSinTasa     	INT(11);
    DECLARE ProcesoCede     	INT(11);
	DECLARE Var_ProVenMasi  	VARCHAR(100);
    DECLARE	Fecha_Vacia			DATE;
	DECLARE ErrorUno            VARCHAR(400);
	DECLARE ErrorDos            VARCHAR(400);
	DECLARE ErrorTres           VARCHAR(400);
	DECLARE ErrorCuatro         VARCHAR(400);
	DECLARE InstCede            INT(11);
	DECLARE InicioMes           DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Tasa_Fija           CHAR(1);


	-- Declaracion de Variables
	DECLARE Var_NumCedes        INT(11);
	DECLARE Var_Poliza          BIGINT(20);
	DECLARE Var_CedeID          INT(11);
	DECLARE Var_CuentaAhoID     BIGINT(20);
	DECLARE Var_TipoCedeID      INT(11);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_Monto           DECIMAL(18,2);
	DECLARE Var_InteresGenerado DECIMAL(18,2);
	DECLARE Var_InteresRetener  DECIMAL(18,2);
	DECLARE Var_InteresRecibir  DECIMAL(18,2);
	DECLARE Var_SaldoProvision  DECIMAL(18,2);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_SucOrigen       INT(11);
	DECLARE Var_TasaFV          CHAR(1);
	DECLARE Var_AmortizacionID  INT(11);
	DECLARE Var_ErrorKey        INT(11) DEFAULT 0;
	DECLARE Var_InteresPagar    DECIMAL(18,2);
	DECLARE Var_MovIntere       VARCHAR(4);
	DECLARE Cue_PagIntere       VARCHAR(50);
	DECLARE Var_Instrumento     VARCHAR(15);
	DECLARE Var_CuentaStr       VARCHAR(15);
	DECLARE Var_MonedaBase      INT(11);
	DECLARE Var_TipCamCom       DECIMAL(14,6);
	DECLARE Var_IntRetMN        DECIMAL(12,2);
	DECLARE Var_FechaIncio      DATE;
	DECLARE Var_FechaVencimi    DATE;
	DECLARE Var_TasaISR		    DECIMAL(14,2);
	DECLARE Var_PagaISR		    CHAR(1);
	DECLARE Var_CedeStr         VARCHAR(15);
    DECLARE	Var_FechaBatch		DATE;
	DECLARE Var_FecBitaco   	DATETIME;
	DECLARE Var_MinutosBit  	INT(11);
    DECLARE Var_FechaInicio  	DATE;
    DECLARE Var_FechaVencimiento	DATE;
    DECLARE Var_MontoCede       DECIMAL(14,2);
    DECLARE Var_Tasa			DECIMAL(14,4);

	-- Declaracion de Cursores
	DECLARE PAGOCEDECUR CURSOR FOR
	  SELECT    cede.CedeID,            	cede.CuentaAhoID,     		MAX(cede.TipoCedeID),      	MAX(cede.MonedaID),        	MAX(cede.Monto),
				MAX(cede.InteresGenerado),  MAX(cede.InteresRetener),  	MAX(cede.InteresRecibir),	MAX(cede.SaldoProvision),	cede.ClienteID,
				MAX(cte.SucursalOrigen),    MAX(cede.TasaFV),          	MAX(cede.AmortizacionID),	MAX(cede.FechaInicio),		MAX(cede.FechaVencimiento),
				MAX(cede.TasaISR),		  	MAX(cte.PagaISR)
			FROM CEDESINTASA cede
				INNER JOIN CEDES ced ON cede.CedeID = ced.CedeID AND ced.Estatus = 'N'
				INNER JOIN CLIENTES cte ON  cede.ClienteID = cte.ClienteID
					GROUP BY cede.ClienteID,cede.CedeID,cede.CuentaAhoID;

	-- Asignacion de Constantes
	SET SalidaNO        := 'N';
	SET SalidaSI        := 'S';
	SET DecimalCero     := 0.0;
	SET EnteroCero      := 0;
	SET EnteroUno      	:= 1;
	SET Cadena_Vacia    := '';
	SET PolAutomatica   := 'A';
	SET PagoCeder       := 902;      		-- Concepto Contable: Pago de CEDE
	SET RefePagoCede    := 'VENCIMIENTO DE CEDE';           -- Descripcion Referencia
	SET MovPagCedCap    := '502';        	-- PAGO CEDE. CAPITAL
	SET ConCedCapi      := 1;           	-- Concepto Contable de CEDE: Capital
	SET ConCapital      := 1;           	-- Concepto Contable de Ahorro: Capital
	SET NatAbono        := 'A';
	SET NatCargo        := 'C';
	SET AltPolizaNO     := 'N';
	SET MovAhorroSI     := 'S';         	-- Movimiento de Ahorro: SI
	SET MovAhorroNO     := 'N';         	-- Movimiento de Ahorro: NO
	SET MovPagIntExe    := '504';        	-- PAGO CEDE. INTERES EXCENTO
	SET CuePagIntExe    := 'INTERESES GENERADOS';   -- Descripcion Interes Excento
	SET MovPagIntGra    := '503';       	 -- PAGO CEDE. INTERES GRAVADO
	SET CuePagIntGra    := 'INTERESES GENERADOS';    -- Descripcion Interes Gravado
	SET ConCedProv      := 5;           	-- Concepto Contable de CEDE: Provision
	SET TipoProvision   := '100';      		-- Tipo de Movimiento de CEDE: Provision
	SET MovPagCedRet    := '505';        	-- PAGO CEDE. RETENCION
	SET CueRetCeder     := 'RETENCION ISR';	-- rDescripcion Retenciuon ISR
	SET OpeInterna      := 'I';         	-- Tipo de Operacion: Interna
	SET TipCompra       := 'C';         	-- Tipo de Operacion: Compra de Divisa
	SET NombreProceso   := 'CEDE';          --  Descripcion Nombre Proceso
	SET ConCedISR       := 4;           	-- Concepto Contable de CEDE: Retencion
	SET EstPagado       := 'P';        		-- Estatus de la CEDE: Pagada
	SET ProcSinTasa     :=  1315;
	SET ProcesoCede     :=  1315;
	SET Var_ProVenMasi  := '/microfin/cedesVencimientoMasivo.htm';
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET ErrorUno        := 'ERROR DE SQL GENERAL';
	SET ErrorDos        := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET ErrorTres       := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET ErrorCuatro     := 'ERROR VALORES NULOS';
	SET InstCede        := 28;
	SET InicioMes       := CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);   -- Fecha de Inicio del Mes a Trabajar.
	SET Entero_Cero     := 0;
	SET Tasa_Fija       := 'F';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-CEDESSINTASAPRO');
			END;

		SET Aud_FechaActual := NOW();
		SET Var_FecBitaco := Aud_FechaActual;

        SELECT MonedaBaseID INTO Var_MonedaBase
		FROM PARAMETROSSIS;

		-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoCede,			Par_Fecha,			Var_FechaBatch,		EnteroUno,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = Var_ProVenMasi) THEN

			TRUNCATE TABLE CEDESINTASA;
			INSERT INTO CEDESINTASA (
					CedeID,                 CuentaAhoID,            TipoCedeID,             MonedaID,               FechaInicio,
					Monto,                  Plazo,                  Tasa,                   TasaISR,                TasaNeta,
					InteresGenerado,        InteresRetener,         InteresRecibir,         SaldoProvision,         AmortizacionID,
					ClienteID,              TasaFV,					FechaVencimiento)
			SELECT
					cede.CedeID,            cede.CuentaAhoID,       cede.TipoCedeID,        cede.MonedaID,          cede.FechaInicio,
					cede.Monto,             cede.Plazo,             cede.Tasa,              cede.TasaISR,           cede.TasaNeta,
					cede.InteresGenerado,   cede.InteresRetener,    cede.InteresRecibir,    cede.SaldoProAcumulado, cede.AmortizacionID,
					cede.ClienteID,         cede.TasaFV,			Amo.FechaVencimiento
				FROM 	TEMPCEDES cede INNER JOIN AMORTIZACEDES Amo ON   Amo.CedeID=cede.CedeID AND Amo.AmortizacionID=cede.AmortizacionID
				WHERE 	cede.NuevaTasa <= DecimalCero;

			SELECT  COUNT(CedeID) INTO  Var_NumCedes    FROM CEDESINTASA;
			SET Var_NumCedes  :=  IFNULL(Var_NumCedes,EnteroCero);

			IF(Var_NumCedes > EnteroCero) THEN
				CALL MAESTROPOLIZASALT(
					Var_Poliza,         Par_EmpresaID,      Par_Fecha,      PolAutomatica,      PagoCeder,
					RefePagoCede,       SalidaNO,           Par_NumErr,     Par_ErrMen,         Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
					LEAVE ManejoErrores;
				END IF;
			ELSE

				SET Par_NumErr  :=  0;
				SET Par_ErrMen  :=  'Pago CEDES sin Tasa Realizado Exitosamente.';

				IF(Aud_ProgramaID!=Var_ProVenMasi) THEN
					SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
					SET Aud_FechaActual := NOW();

					CALL BITACORABATCHALT(
						ProcesoCede,      	Par_Fecha,        Var_MinutosBit,    	Par_EmpresaID,    Aud_Usuario,
                        Aud_FechaActual, 	Aud_DireccionIP,  Aud_ProgramaID,		Aud_Sucursal,     Aud_NumTransaccion);
				END IF;

				SET Var_FecBitaco := NOW();
				LEAVE ManejoErrores;

			END IF;


			OPEN PAGOCEDECUR;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOPAGOCEDECUR:LOOP
				FETCH PAGOCEDECUR INTO
				Var_CedeID,             Var_CuentaAhoID,    Var_TipoCedeID,     Var_MonedaID,       Var_Monto,
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
						CALL CONTACEDESPRO(
							Var_CedeID,         Par_EmpresaID,  Par_Fecha,      Var_Monto,          MovPagCedCap,
							PagoCeder,          ConCedCapi,     ConCapital,     NatAbono,           AltPolizaNO,
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
						CALL CONTACEDESPRO(
							Var_CedeID,         Par_EmpresaID,  Par_Fecha,      Var_InteresPagar,   Var_MovIntere,
							PagoCeder,          ConCedProv,     ConCapital,     NatAbono,           AltPolizaNO,
							MovAhorroSI,        SalidaNO,       Var_Poliza,     Par_NumErr,         Par_ErrMen,
							Var_CuentaAhoID,    Var_ClienteID,  Var_MonedaID,   Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID, Var_SucOrigen,  Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						CALL CEDESMOVALT(
							Var_CedeID,     Par_Fecha,          TipoProvision,      Var_InteresPagar,   NatAbono,
							Cue_PagIntere,  Var_MonedaID,       SalidaNO,           Par_NumErr,         Par_ErrMen,
							Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
							Aud_Sucursal,   Aud_NumTransaccion  );

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);
						SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);

                         -- Se obtiene la fecha de inicio y vencimiento de la amortizacion
                        SET Var_FechaInicio 		:= (SELECT FechaInicio FROM AMORTIZACEDES WHERE CedeID = Var_CedeID AND AmortizacionID = Var_AmortizacionID);
                        SET Var_FechaVencimiento 	:= (SELECT FechaVencimiento FROM AMORTIZACEDES WHERE CedeID = Var_CedeID AND AmortizacionID = Var_AmortizacionID);

                        -- Se obtiene el Monto de la CEDE
                        SET Var_MontoCede 	:= (SELECT Monto FROM CEDES WHERE CedeID = Var_CedeID);
                        SET Var_MontoCede	:= IFNULL(Var_MontoCede,DecimalCero);

						SET Var_Tasa	:=(SELECT TasaFija FROM CEDES WHERE CedeID = Var_CedeID);
						SET Var_Tasa	:=IFNULL(Var_Tasa,EnteroCero);

                        -- Registro de informacion para el Calculo del Interes Real para Cedes
						CALL CALCULOINTERESREALALT (
							 Var_ClienteID,			Par_Fecha,				InstCede,			Var_CedeID,			Var_MontoCede,
							 Var_InteresPagar,		Var_InteresRetener,		Var_Tasa,			Var_FechaInicio,	Var_FechaVencimiento,
                             Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
                             Aud_Sucursal,			Aud_NumTransaccion);

					END IF;
					-- Fin Pago de Rendimiento

					-- Retencion ISR
					IF (Var_InteresRetener > EnteroCero) THEN

						CALL CUENTASAHORROMOVALT(
							Var_CuentaAhoID,    Aud_NumTransaccion, Par_Fecha,          NatCargo,           Var_InteresRetener,
							CueRetCeder,        Var_Instrumento,    MovPagCedRet,       SalidaNO,           Par_NumErr,
							Par_ErrMen,			Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

						IF(Par_NumErr != EnteroCero) THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

						CALL POLIZASAHORROPRO(
							Var_Poliza,         Par_EmpresaID,      Par_Fecha,          Var_ClienteID,      ConCapital,
							Var_CuentaAhoID,    Var_MonedaID,       Var_InteresRetener, EnteroCero,         CueRetCeder,
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
							  OpeInterna,       TipCompra,          Var_Instrumento,    RefePagoCede,       NombreProceso,
							  Var_Poliza,       Par_EmpresaID,     	Aud_Usuario,      	Aud_FechaActual,    Aud_DireccionIP,
                              Aud_ProgramaID,   Var_SucOrigen,      Aud_NumTransaccion);

						ELSE
							SET Var_IntRetMN := Var_InteresRetener;
						END IF;

						CALL CONTACEDESPRO(
							Var_CedeID,         Par_EmpresaID,      Par_Fecha,          Var_IntRetMN,       Cadena_Vacia,
							PagoCeder,          ConCedISR,          EnteroCero,         NatAbono,           AltPolizaNO,
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
						UPDATE AMORTIZACEDES Amo
						  SET 	Amo.Estatus   		= EstPagado,
								EmpresaID       	= Par_EmpresaID,
								Usuario         	= Aud_Usuario,
								FechaActual     	= Aud_FechaActual,
								DireccionIP     	= Aud_DireccionIP,
								ProgramaID      	= Aud_ProgramaID,
								Sucursal        	= Aud_Sucursal,
								NumTransaccion  	= Aud_NumTransaccion
						WHERE	Amo.CedeID    		= Var_CedeID
						AND 	Amo.Estatus   		!= EstPagado
						AND 	Amo.AmortizacionID	= Var_AmortizacionID;

					  -- Fin de la Actualizacion de la Ultima Amotizacion a Pagada

						UPDATE CEDES
						  SET	Estatus     	= EstPagado,
								EmpresaID     	= Par_EmpresaID,
								UsuarioID     	= Aud_Usuario,
								FechaActual   	= Aud_FechaActual,
								DireccionIP   	= Aud_DireccionIP,
								ProgramaID    	= Aud_ProgramaID,
								Sucursal    	= Aud_Sucursal,
								NumTransaccion	= Aud_NumTransaccion
						WHERE	CedeID			= Var_CedeID;

					  /*SE ACTUALIZA EL SALDO PROVISION CEDES*/
						UPDATE CEDES SET
							SaldoProvision= SaldoProvision - Var_SaldoProvision
						WHERE CedeID = Var_CedeID;

					END ErrorCursor;-- Termina BEGIN Start Transaction

					SET Var_CedeStr := CONVERT(Var_CedeID, CHAR);

					IF (Var_ErrorKey = 0) THEN
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 1) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,          Var_CedeStr,      ErrorUno,
							  Par_EmpresaID,    Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 2) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,       Var_CedeStr,     ErrorDos,
							  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 3) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
							  ProcSinTasa,      Par_Fecha,      Var_CedeStr,      	ErrorTres,
							  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  	Aud_DireccionIP,
							  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 4) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								ProcSinTasa,    	Par_Fecha,     	Var_CedeStr,     	ErrorCuatro,
								Par_EmpresaID,    	Aud_Usuario,    Aud_FechaActual, 	Aud_DireccionIP,
								Aud_ProgramaID,   	Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF (Var_ErrorKey = 99) THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								ProcSinTasa,    	Par_Fecha,      Var_CedeStr,     	CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Par_EmpresaID,    	Aud_Usuario,    Aud_FechaActual,  	Aud_DireccionIP,
								Aud_ProgramaID,   	Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

				END LOOP CICLOPAGOCEDECUR;
			END;
			CLOSE PAGOCEDECUR;

			/*SE ELIMINAN LAS CEDES QUE NO TIENEN TASA*/
			DELETE FROM TEMPCEDES WHERE NuevaTasa <= DecimalCero;

			IF(Par_NumErr = EnteroCero) THEN
				SET Par_NumErr  :=  EnteroCero;
				SET Par_ErrMen  :=  'Pago CEDES sin Tasa Realizado Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo cedes*/
			IF(Aud_ProgramaID!=Var_ProVenMasi)THEN
				CALL BITACORABATCHALT(
					ProcesoCede,        Par_Fecha,          Var_MinutosBit,      	Par_EmpresaID,    	Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,  		Aud_Sucursal,     Aud_NumTransaccion);
			END IF;
			SET Var_FecBitaco := NOW();

		END IF;

        SET Par_NumErr  :=  EnteroCero;
		SET Par_ErrMen  :=  'Pago CEDES sin Tasa Realizado Exitosamente.';

	END ManejoErrores;
	  IF (Par_Salida = SalidaSI) THEN
		  SELECT  	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
		END IF;

END TerminaStore$$