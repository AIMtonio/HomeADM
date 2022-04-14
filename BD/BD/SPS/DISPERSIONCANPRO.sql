-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONCANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONCANPRO`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONCANPRO`(
# ==================================================================
# ---- SP PARA REALIZAR LA CANCELACION DE DISPERSIONES POR CHEQUE---
# ==================================================================
	Par_ClaveDispMov			INT(11),
    Par_DispersionID			INT(11),
    Par_CuentaCheque			VARCHAR(18),    -- Numero de Cheque
	Par_Fecha					DATE,
	Par_PolizaID				BIGINT(20),		-- Numero de poliza

    Par_Salida          		CHAR(1),
	OUT Par_NumErr          	INT(11),
	OUT Par_ErrMen          	VARCHAR(400),
	OUT Par_Consecutivo     	BIGINT(12),

    Aud_EmpresaID       		INT(11),
    Aud_Usuario         		INT(11),
    Aud_FechaActual    			DATETIME,
    Aud_DireccionIP     		VARCHAR(15),
    Aud_ProgramaID      		VARCHAR(50),
    Aud_Sucursal        		INT(11),
    Aud_NumTransaccion  		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_FechaOpeDis			DATE;
	DECLARE Var_MontoMov			DECIMAL(12,2);
	DECLARE Var_DescripcionMov		VARCHAR(150);
	DECLARE Var_ReferenciaMov		VARCHAR(35);
	DECLARE Si_Conciliado			CHAR(1);
	DECLARE CtaAhoID				BIGINT(12);
	DECLARE Var_InstitucionID		INT(11);
	DECLARE Var_CuentaBancaria		VARCHAR(20);
	DECLARE Mon_Base				INT;
	DECLARE Fecha_Sistema			DATE;
	DECLARE Fecha_Valida			DATE;
	DECLARE Des_Contable			VARCHAR(150);
	DECLARE Var_ClienteID			INT(12);
	DECLARE Var_TipoMovimiento		INT;
	DECLARE Var_AltaMovAho			CHAR(1);
	DECLARE Tip_MovAho				CHAR(4);
	DECLARE Var_Refere				VARCHAR(100);-- contiene la referencia
	DECLARE Var_Consecutivo			INT;
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_ProveedorID			INT;
	DECLARE Var_NoFactura			VARCHAR(20);
	DECLARE Var_FacturaID			VARCHAR(20);
	DECLARE Var_DetReqGasID			INT;
	DECLARE Var_TipoGasto			INT;
	DECLARE Var_AnticipoFact		CHAR(11);
	DECLARE Var_EstFact				CHAR(1);
	DECLARE Var_TotFactura			DECIMAL(14,2);
	DECLARE Var_ReqGasID			INT(11);
	DECLARE Var_CenCostoID			INT(11);
	DECLARE Var_CuentaConta			VARCHAR(25);
	DECLARE Var_CatalogoServID		INT(11);
	DECLARE Var_SucursalID			INT(11);
	DECLARE Var_FormaPago			INT(1);
	DECLARE Var_ProrrateaImp		CHAR(1); -- Prorrateo de Impuestos en Facturacion Proveedores
	DECLARE	Var_TipoGastoDF			INT;
	DECLARE Var_DescripcionDF		CHAR(100);
	DECLARE Var_ImporteDF			DECIMAL(13,2);
	DECLARE	Var_CenCostoIDDF		INT;
	DECLARE Var_CenCostoManualID   	INT;
	DECLARE Var_Control         	VARCHAR(100);
	DECLARE Var_ImporteImp			DECIMAL(14,2);
	DECLARE Var_ImpID				INT(11);
	DECLARE Var_NatConta			CHAR(2);
	DECLARE Var_CtaAntProv			VARCHAR(25);
	DECLARE Var_CtaProvee			VARCHAR(25);
	DECLARE Var_CueGasto    		CHAR(25);
	DECLARE Var_TraCue   			VARCHAR(25);
	DECLARE Var_ReaCue				VARCHAR(25);
	DECLARE Var_TipoImp				CHAR(1);
	DECLARE Var_PolizaID			BIGINT(20);
	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_Automatico			CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Var_TipoChequeDesem 	CHAR(4);
	DECLARE Var_TipoChequeIndiv 	CHAR(4);
	DECLARE Var_CheqProveeFact  	CHAR(4);
	DECLARE Var_ChequeProvee    	CHAR(4);
	DECLARE Var_CheqProvAntFact		CHAR(4);
	DECLARE Nat_Cargo           	CHAR(1);
	DECLARE Nat_Abono           	CHAR(1);
	DECLARE No_EmitePoliza      	CHAR(1);
	DECLARE Si_EmitePoliza			CHAR(1);
	DECLARE Tip_MovAhoCHEQ      	CHAR(4);
	DECLARE SI_AltaMovAho       	CHAR(1);
	DECLARE NO_AltaMovAho       	CHAR(1);
	DECLARE Des_PagProvSinFac   	VARCHAR(50);
	DECLARE Tipo_PagFact        	CHAR(1);
	DECLARE var_RefCuentCheq		VARCHAR(150);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE Procedimiento			VARCHAR(30);
	DECLARE Con_PagoAntNO			CHAR(1);
	DECLARE FechaValida				DATE;
	DECLARE Var_FolioUUID       	VARCHAR(100);
	DECLARE Var_ProvRFC				VARCHAR(13);
	DECLARE Des_PagoFactura 		VARCHAR(100);
	DECLARE Cuenta_Vacia    		VARCHAR(15);
	DECLARE Imp_Gravado				CHAR(1);
	DECLARE Imp_Retenido			CHAR(1);
	DECLARE ConContaCancela 		INT(11);
	DECLARE Var_CentroCostosID		INT(11);


	-- Declaracion del cursor de cancelacion de detalles de la factura
	DECLARE CURSORDETFACT CURSOR FOR
			SELECT	Det.TipoGastoID,		Det.Descripcion,	Det.Importe,	Det.CentroCostoID,	Fac.FolioUUID,
					DetIm.ImporteImpuesto,	DetIm.ImpuestoID
				FROM	DETALLEIMPFACT	DetIm
				INNER JOIN	DETALLEFACTPROV	 Det ON	DetIm.NoFactura		= Det.NoFactura
												AND	DetIm.ProveedorID 	= Det.ProveedorID
												AND	DetIm.NoPartidaID 	= Det.NoPartidaID
				INNER JOIN  FACTURAPROV Fac		 ON	Det.ProveedorID		= Fac.ProveedorID
												AND	Det.NoFactura		= Fac.NoFactura
				WHERE		DetIm.ProveedorID	= Var_ProveedorID
				  AND 		DetIm.NoFactura		= Var_NoFactura;

	-- Declaracion de cursor de cancelacion de importes de impuestos
	DECLARE CURSORDETIMPUESTOS CURSOR FOR

		SELECT	ImporteImpuesto,ImpuestoID
			FROM 	DETALLEIMPFACT DI
			WHERE 	DI.ProveedorID 	= Var_ProveedorID
			AND 	DI.NoFactura	= Var_NoFactura;

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero en Cero
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Var_Automatico		:= 'A';				-- Tipo: Automatica
	SET Var_TipoChequeDesem	:= '12';			-- TIPOSMOVTESO: Cheque por Desembolso de Credito
	SET Var_TipoChequeIndiv	:= '4';				-- TIPOSMOVTESO: Salida Recursos del Cliente por Cheque
	SET Var_CheqProveeFact	:= '6';				-- TIPOSMOVTESO: Salida Cheque por Pago a Provedores Factura
	SET Var_ChequeProvee	:= '16';			-- TIPOSMOVTESO: Cheque por Pago a Provedores sin Factura
	SET Var_CheqProvAntFact	:= '23';			-- TIPOSMOVTESO: Salida Cheque por Anticipo Pago a Provedores Factura
	SET Nat_Cargo			:= 'C';				-- Naturaleza del Movimiento: Cargo
	SET Nat_Abono			:= 'A';				-- Naturaleza del Movimiento: Abono
	SET Si_Conciliado       := 'C';     		-- Movimiento no Conciliado
	SET No_EmitePoliza      := 'N';     		-- NO Genera Encabezado de la Poliza Contable
	SET Si_EmitePoliza      := 'S';     		-- NO Genera Encabezado de la Poliza Contable
	SET SI_AltaMovAho       := 'S';     		-- Alta del Movimiento de Ahorro: SI
	SET NO_AltaMovAho       := 'N';     		-- Alta del Movimiento de Ahorro: NO
	SET Salida_SI           := 'S';     		-- Llamada a Store sin Select de Salida
	SET Salida_NO           := 'N';    		 	-- Llamada a Store Con Select de Salida
	SET Tip_MovAhoCHEQ      := '15';    		-- Tipo de Movimiento de Ahorro: Entrega de Cheque
	SET Tipo_PagFact        := 'C';     		-- Tipo de Registro: Cancelacion de Factura
	SET Des_PagProvSinFac   := 'CANCELA CHEQUE A PROVEEDOR SIN FACTURA';
	SET TipoInstrumentoID	:= 19; 				-- TIPO DE INSTRUMENTO CUENTA BANCARIA --
	SET Procedimiento		:='DISPERSIONCANPRO'; -- Procedimiento que se ejecuta --
	SET Con_PagoAntNO 		:= 'N';
	SET Var_Consecutivo		:=0;
	SET Des_Contable        := '';
	SET Aud_FechaActual 	:= NOW();
	SET Des_PagoFactura 	:= 'CANCELACION CHEQUE';       -- Descripcion del Movimiento: Pago de Fact
	SET Cuenta_Vacia 		:= '000000000000000';-- Cuenta Contable Vacia
	SET Imp_Gravado			:= 'G';				-- Impuesto Gravado
	SET Imp_Retenido		:= 'R';				-- Impuesto Retenido
	SET ConContaCancela		:= 807; 			-- concepto contable de cancelacion de cheques corresponde con CONCEPTOSCONTA --

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DISPERSIONCANPRO');
						SET Var_Control = 'sqlException' ;
		END;


		SELECT  FechaSistema, MonedaBaseID
		INTO Fecha_Sistema, Mon_Base
		FROM PARAMETROSSIS;


		IF(IFNULL(Par_ClaveDispMov, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr      := 001;
				SET Par_ErrMen      := 'No existe el Movimiento de Dispersion.';
				SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT	Dis.CuentaAhoID,			Dis.FechaOperacion,		Dis.InstitucionID,	Teso.NumCtaInstit,		DisMov.CuentaCargo,
				DisMov.Monto,				DisMov.Descripcion,		DisMov.Referencia,	DisMov.TipoMovDIspID,	DisMov.CreditoID,
				DisMov.ProveedorID,			DisMov.FacturaProvID,	DisMov.DetReqGasID,	DisMov.TipoGastoID,		DisMov.CuentaContable,
				DisMov.CatalogoServID,		DisMov.SucursalID,
				CASE WHEN DisMov.TipoMovDIspID = Var_TipoChequeIndiv OR DisMov.TipoMovDIspID = Var_TipoChequeDesem OR DisMov.TipoMovDIspID = Var_CheqProveeFact
							OR DisMov.TipoMovDIspID = Var_ChequeProvee OR DisMov.TipoMovDIspID = Var_CheqProvAntFact
				THEN  CONCAT(DisMov.Referencia,"/CHEQUE:",Par_CuentaCheque)
				ELSE DisMov.Referencia END, DisMov.AnticipoFact,	DisMov.FormaPago
		INTO	CtaAhoID,					Var_FechaOpeDis,		Var_InstitucionID,	Var_CuentaBancaria,		Var_CuentaAhoID,
				Var_MontoMov,				Var_DescripcionMov,		Var_ReferenciaMov,	Var_TipoMovimiento,		Var_CreditoID,
				Var_ProveedorID,			Var_FacturaID,			Var_DetReqGasID,	Var_TipoGasto,			Var_CuentaConta,
				Var_CatalogoServID,			Var_SucursalID,			var_RefCuentCheq,	Var_AnticipoFact,		Var_FormaPago
			FROM DISPERSION Dis,
				 DISPERSIONMOV DisMov,
				 CUENTASAHOTESO Teso
			WHERE DisMov.DispersionID   = Par_DispersionID
			  AND DisMov.ClaveDispMov   = Par_ClaveDispMov
			  AND Dis.FolioOperacion    = DisMov.DispersionID
			  AND Teso.InstitucionID    = Dis.InstitucionID
			  AND Teso.NumCtaInstit      = Dis.NumCtaInstit;



		-- Validaciones Generales
		SET Var_TipoMovimiento  := IFNULL(Var_TipoMovimiento, Entero_Cero);

		IF(Var_TipoMovimiento = Entero_Cero) THEN
				SET Par_NumErr      := 002;
				SET Par_ErrMen      := 'No existe el Tipo de Movimiento de Dispersion.';
				SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_Fecha:= IFNULL(Par_Fecha,Var_FechaOpeDis);
		SET FechaValida:=Par_Fecha;
		SET Var_DescripcionMov := 'CANCELACION DE CHEQUE';

		-- El Tipo de Movimiento es de una Dispersion cheque de Credito o cheque individual
		IF (Var_TipoMovimiento =  Var_TipoChequeDesem OR
			Var_TipoMovimiento =  Var_TipoChequeIndiv) THEN

			-- si la cuenta contable viene vacia se des
			IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Var_AltaMovAho  := SI_AltaMovAho;
				SET Var_ClienteID := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID);
			ELSE
				SET Var_AltaMovAho  := NO_AltaMovAho;
			END IF;

			-- Seleccionamos el Tipo de Movimiento en la Cta de Ahorro
			IF (Var_TipoMovimiento =  Var_TipoChequeDesem) THEN
				SET Des_Contable := 'CANCELACION DE CHEQUE';
				SET Var_DescripcionMov := 'CANCELACION DE CHEQUE';
			ELSE
				SET Tip_MovAho  := Tip_MovAhoCHEQ;
			END IF;

			IF (Var_TipoMovimiento =  Var_TipoChequeIndiv) THEN
				SET Des_Contable := Var_DescripcionMov;
			END IF;


			SET Var_Refere := Par_CuentaCheque;

				-- alta en poliza Contable y CARGO contable a la cuenta de bancos del cheque a cancelar
			CALL CONTATESOREPRO(
					Aud_Sucursal,       Mon_Base,           Var_InstitucionID,  Var_CuentaBancaria,		Entero_Cero,
					Var_ProveedorID,    Entero_Cero,        FechaValida,		FechaValida,       		Var_MontoMov,
					Des_Contable,       Var_Refere,			Var_CuentaBancaria, No_EmitePoliza,     	Par_PolizaID,
					ConContaCancela,	Entero_Cero,        Nat_Cargo,          Var_AltaMovAho,     	Var_CuentaAhoID,
					Var_ClienteID,      Tip_MovAho,         Nat_Abono,          Salida_No,				Par_NumErr,
					Par_ErrMEn, 		Var_Consecutivo,    Aud_EmpresaID,      Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
			END IF;

		ELSE        -- Es Dispersion por Pago a Proveedor (Con Factura o sin Factura)

			IF(	Var_TipoMovimiento = Var_CheqProveeFact	OR
				Var_TipoMovimiento = Var_ChequeProvee) THEN

				SET Var_AltaMovAho  := NO_AltaMovAho;
				SET Tip_MovAho      := Cadena_Vacia;
				SET Des_Contable    := Var_DescripcionMov;

				IF (Var_TipoMovimiento =  Var_CheqProveeFact) THEN -- Es un Pago al Proveedor con Factura

					SELECT		Estatus,    	TotalFactura,	NoFactura,		ProrrateaImp, 		CenCostoManualID, 		FolioUUID
						INTO	Var_EstFact,    Var_TotFactura,	Var_NoFactura, 	Var_ProrrateaImp, 	Var_CenCostoManualID, 	Var_FolioUUID
						FROM 	FACTURAPROV
						WHERE 	FacturaProvID 	= Var_FacturaID
						AND 	ProveedorID 	= Var_ProveedorID;

						-- Contabilidad de la Factura
					SET Var_ProvRFC = (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
					FROM PROVEEDORES
					WHERE ProveedorID = Var_ProveedorID);

					SELECT CuentaAnticipo,CuentaCompleta
					INTO Var_CtaAntProv, Var_CtaProvee
					FROM PROVEEDORES
					WHERE ProveedorID = Var_ProveedorID;

					SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
					SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

					SET Var_NatConta :=	Nat_Abono;

					CALL CONTAFACTURAPRO(
						Var_ProveedorID,   		Var_NoFactura,		Tipo_PagFact,  			Con_PagoAntNO,		No_EmitePoliza,
						Par_PolizaID,			FechaValida,   		Var_MontoMov,			Entero_Cero,		Var_CenCostoManualID,
						Var_CtaProvee,			Entero_Cero,		Var_ProvRFC,			Var_FolioUUID,		Var_NatConta,
						ConContaCancela,		Des_PagoFactura,	IFNULL(Par_CuentaCheque,Entero_Cero),		Salida_NO,
						Par_NumErr,             Par_ErrMen,       	Aud_EmpresaID,  		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	    Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion );

					IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;


					OPEN CURSORDETFACT;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						LOOP

						FETCH CURSORDETFACT INTO
							Var_TipoGastoDF,	Var_DescripcionDF,		Var_ImporteDF, Var_CenCostoIDDF, Var_FolioUUID,
							Var_ImporteImp,		Var_ImpID;

						BEGIN

							SET Var_ProvRFC = (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
												FROM 	PROVEEDORES
												WHERE 	ProveedorID = Var_ProveedorID);

							SET Var_TraCue := (SELECT CtaEnTransito FROM IMPUESTOS WHERE ImpuestoID = Var_ImpID);
							SET Var_ReaCue := (SELECT CtaRealizado FROM IMPUESTOS WHERE ImpuestoID = Var_ImpID);
							SET Var_TipoImp := (SELECT GravaRetiene FROM IMPUESTOS WHERE ImpuestoID = Var_ImpID);

							SET Var_TraCue := IFNULL(Var_TraCue, Cuenta_Vacia);
							SET Var_ReaCue := IFNULL(Var_ReaCue, Cuenta_Vacia);

							IF(Var_TipoImp = Imp_Gravado)THEN
								SET Var_NatConta :=	Nat_Cargo;
							ELSE
								IF(Var_TipoImp = Imp_Retenido)THEN
									SET Var_NatConta :=	Nat_Abono;
								END IF;

							END IF;

							CALL CONTAFACTURAPRO(
								Var_ProveedorID,   		Var_NoFactura,		Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
								Par_PolizaID,			FechaValida,  		Var_ImporteImp,		Entero_Cero,		Var_CenCostoIDDF,
								Var_TraCue,				Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
								ConContaCancela,		Des_PagoFactura,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
								Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							IF(Var_TipoImp = Imp_Gravado)THEN
								SET Var_NatConta :=	Nat_Abono;
							ELSE
								IF(Var_TipoImp = Imp_Retenido)THEN
									SET Var_NatConta :=	Nat_Cargo;
								END IF;

							END IF;

							CALL CONTAFACTURAPRO(
								Var_ProveedorID,   		Var_NoFactura,		Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
								Par_PolizaID,			FechaValida,  		Var_ImporteImp,		Entero_Cero,		Var_CenCostoIDDF,
								Var_ReaCue,				Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
								ConContaCancela,		Des_PagoFactura,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
								Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion );

							IF(Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END;
						END LOOP;
						END;
					CLOSE CURSORDETFACT;
				END IF;

			ELSE    -- Es un pago al Proveedor sin Factura
				-- se obtiene el valor del id de la req de gastos para obtener el centro de costos
				SELECT DetReqGasID INTO Var_ReqGasID
				FROM DISPERSIONMOV
				WHERE DispersionID = Par_DispersionID
				AND ClaveDispMov   = Par_ClaveDispMov;
				-- se obtiene el numero de centro de costos del detalle
				SELECT CentroCostoID INTO Var_CenCostoID
					FROM 	REQGASTOSUCURMOV
					WHERE 	DetReqGasID  = Var_ReqGasID;


				SELECT CuentaCompleta INTO Var_CueGasto
					FROM 	TESOCATTIPGAS
					WHERE 	TipoGastoID = Var_TipoGasto;

				SET Var_CueGasto = IFNULL(Var_CueGasto, Cuenta_Vacia);

				SET Var_NatConta :=	Nat_Abono;

				-- Contabilidad del Pago al Proveedor por el Tipo de Gasto el pago es por cheque se manda el numero de cheque como referencia
				CALL CONTAFACTURAPRO(
					Var_ProveedorID,   		Par_CuentaCheque,	Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
					Par_PolizaID,			FechaValida,  		Var_MontoMov,		Entero_Cero,		Var_CenCostoID,
					Var_CueGasto,			Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
					ConContaCancela,		Des_PagProvSinFac,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
					Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


					-- alta en poliza Contable y CARGO contable a la cuenta de bancos del cheque a cancelar
				SET Var_Refere := Par_CuentaCheque;
				CALL CONTATESOREPRO(
						Aud_Sucursal,       Mon_Base,           Var_InstitucionID,  Var_CuentaBancaria,		Entero_Cero,
						Var_ProveedorID,    Entero_Cero,        FechaValida,		FechaValida,       		Var_MontoMov,
						Des_Contable,       Var_Refere,			Var_CuentaBancaria, No_EmitePoliza,     	Par_PolizaID,
						ConContaCancela,	Entero_Cero,        Nat_Cargo,          Var_AltaMovAho,     	Var_CuentaAhoID,
						Var_ClienteID,      Tip_MovAho,         Nat_Abono,          Salida_No,				Par_NumErr,
						Par_ErrMEn, 		Var_Consecutivo,    Aud_EmpresaID,      Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;


		-- AQUI ESTABA LA DISPERSION POR ANTICIPOS

		-- Si el movimiento de Dispersion SI se Autorizo
		-- Actualiza el Estatus de el movimiento de Dispersion
		SET Par_CuentaCheque :=  IFNULL(Par_CuentaCheque,Cadena_Vacia);

		/* Alta del Movimiento Operativo de la Cuenta Nostro de Tesoreria */
		CALL TESORERIAMOVSALT(
			CtaAhoID,		FechaValida,		Var_MontoMov,		Var_DescripcionMov,		IFNULL(var_RefCuentCheq,Var_ReferenciaMov),
			Si_Conciliado,	Nat_Abono,			Var_Automatico,		Var_TipoMovimiento,		Entero_Cero,
			Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Aud_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion  );

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) <> Cadena_Vacia THEN

			SET Var_ReferenciaMov := Par_CuentaCheque;
			SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);

			CALL DETALLEPOLIZAALT(
				Aud_EmpresaID,		Var_PolizaID,		FechaValida,		Var_CentroCostosID,	Var_CuentaConta,
				Var_CuentaBancaria,	Mon_Base,			Decimal_Cero,		Var_MontoMov,		Des_Contable,
				Var_ReferenciaMov,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		/* Actualizacion del Saldo de la Cuenta de Bancos */
		CALL SALDOSCTATESOACT(
			Var_CuentaBancaria, 	Var_InstitucionID,  Var_MontoMov,       Nat_Abono,      Salida_NO,
			Par_NumErr,        		Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		-- Elimina el movimiento de Dispersion
		CALL DISPERSIONMOVBAJ(
		Par_ClaveDispMov,		Par_DispersionID,	Salida_NO, 			Par_NumErr,			Par_ErrMen,
		Aud_EmpresaID,			Aud_Usuario,     	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,     		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr      := 000;
		SET Par_ErrMen      := 'El cheque  fue cancelado exitosamente';
		SET Par_Consecutivo := Par_PolizaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN

		SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Par_Consecutivo	 AS consecutivo;

	END IF;

END TerminaStore$$