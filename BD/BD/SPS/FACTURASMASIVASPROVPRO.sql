-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURASMASIVASPROVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURASMASIVASPROVPRO`;
DELIMITER $$


CREATE PROCEDURE `FACTURASMASIVASPROVPRO`(
-- ---------------------------------------------------------------------------------
-- SP PARA DAR DE ALTA LAS FACTURAS DE PROVEEDORES MASIVAMENTE
-- ---------------------------------------------------------------------------------
    Par_FolioCargaID        INT(11),				-- FOLIO DE CARGA
    Par_FolioFacturaID      INT(11),				-- FOLIO DE DE FACTURA
    Par_Mes           		INT(11),				-- MES
    Par_CentroCostoID  		INT(11),				-- CENTRO DE COSTOS
    Par_TipoGastoID         INT(11),				-- TIPO DE GASTOS

    Par_TipoTransaccion     INT(11),				-- TIPO DE GASTOS

    Par_Salida              CHAR(1),				-- SALIDA
    INOUT Par_NumErr        INT(11),				-- NUMERO DE ERROR
    INOUT Par_ErrMen        VARCHAR(400),			-- MENSAJE DE ERROR

    Aud_EmpresaID           INT(11),				-- AUDITORIA
    Aud_Usuario             INT(11),				-- AUDITORIA
    Aud_FechaActual         DATETIME,				-- AUDITORIA
    Aud_DireccionIP         VARCHAR(15),			-- AUDITORIA
    Aud_ProgramaID          VARCHAR(50),			-- AUDITORIA
    Aud_Sucursal            INT(11),				-- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)				-- AUDITORIA
    )

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control         VARCHAR(100);				-- CONTROL
DECLARE Var_FehaSistema     DATE;						-- FECHA EL SISTEMA
DECLARE Var_FehaVencimiento DATE;						-- FECHA DE VENCIMIENTO
DECLARE Var_FacturaID		BIGINT(20);					-- FACTURA ID
DECLARE Var_FolioFacturaID	INT(11);					-- FOLIO DE FACTURA
DECLARE Var_UUID			VARCHAR(1000);				-- FOLIO UUID DE LA FACTURA
DECLARE Var_RfcEmisor		VARCHAR(20);				-- RFC EMISOR
DECLARE Var_ProveedorID		INT(11);					-- PROVEEDOR ID
DECLARE Var_Conceptos		TEXT;						-- CONCEPTOS DE LA FACTURA
DECLARE Var_CondicionesPago	VARCHAR(5000);				-- CONDICION DE PAGO
DECLARE Var_DescripcionPol	VARCHAR(50);				-- DESCRIPCION DE POLIZA

DECLARE Var_SubTotal		  DECIMAL(14,2);			-- SUBTOTAL DE LA FACTURA
DECLARE Var_ISRRetenido		  DECIMAL(14,2);			-- ISR RETENIDO DE LA FACTURA
DECLARE Var_ISRTrasladado	  DECIMAL(14,2);			-- ISR TRAASLADADO DE LA FACTURA
DECLARE Var_IVARetenidoGlobal DECIMAL(14,2);			-- IVA RETENIDO GLOBAL DE LA FACTURA
DECLARE Var_IVARetenido		  DECIMAL(14,2);			-- IVA RETENIDO DE LA FACTURA
DECLARE Var_IVATrasladado16	  DECIMAL(14,2);			-- IVA TRASLADADO DE LA FACTURA
DECLARE Var_IVATrasladado8	  DECIMAL(14,2);			-- IVA TRASLADADO8 DE LA FACTURA
DECLARE Var_Total	  		  DECIMAL(14,2);			-- TOTAL DE LA FACTURA
DECLARE Var_Monto	  		  DECIMAL(14,2);			-- MONTO DE LA FACTURA
DECLARE Var_MontoIVA  		  DECIMAL(14,2);			-- MONTO IVA DEL TIPO DE IMPUESO
DECLARE Var_Poliza            BIGINT(20);				-- NUMERO DE POLIZA
DECLARE Var_FacturaProvID     INT(11);					-- NUMERO DE FACTURA
DECLARE Var_CondicionPagoID	  INT(11);					-- NUMERO DE CONDICION DE PAGOS
DECLARE Var_NumExito		  INT(11);					-- NUMERO DE FACTURAS EXITOSAS
DECLARE Var_NumErr		  	  INT(11);					-- NUMERO DE FACTURAS NO EXITOSAS
DECLARE Var_TotalFactura  	  INT(11);					-- TOTAL DE FACTURAS
DECLARE Var_GeneraConta		  CHAR(1);					-- INDICA SI GENERA CONTABILIDAD S.-SI N.-NO
DECLARE Var_NumImpuestos	  INT(11); 					-- NUMERO DE TIPOS DE IMPUESTOS
DECLARE Var_Contador		  INT(11);					-- CONTADOR
DECLARE Var_ImpuestoID		  INT(11);					-- ID DEL TIPO DE IMPUESTO
DECLARE Var_ImpuestoCatID	  INT(11);					-- ID DEL TIPO DE IMPUESTO DEL CATALOGO CONFIGURADO
DECLARE Var_DesImpuesto		  VARCHAR(100);				-- DESCRIPCION DE TIPO DE IMPUESTO
DECLARE Var_DesCortaImpuesto  VARCHAR(100);				-- DESCRIPCION CORTA DEL TIPO DE IMPUESTO
DECLARE Var_TipoProveedor	  INT(11);					-- TIPO DE PROVEEDOR
DECLARE Var_TotalAbono		  DECIMAL(16,2);			-- TOTAL DE ABONOS
DECLARE Var_TotalCargo		  DECIMAL(16,2);			-- TOTAL DE CARGOS
DECLARE Var_DiferenciaTotales DECIMAL(16,2);			-- TOTAL DE CARGOS


-- DECARACION DE CONSTANTES
DECLARE Entero_Cero         INT(11);					-- ENETRO CERO
DECLARE Entero_Uno			INT(11);					-- ENTERO UNO
DECLARE Decimal_Cero        DECIMAL(12,2);				-- DECIMAL CERO
DECLARE Cadena_Vacia        CHAR(1);					-- CADENA VACIA
DECLARE Fecha_Vacia         DATE;						-- FECHA VACIA
DECLARE SalidaNO            CHAR(1);					-- SALIDA NO
DECLARE SalidaSI            CHAR(1);					-- SALIDA SI
DECLARE EstLiquidada		CHAR(1);					-- ESTATUS LIQUIDADA
DECLARE EstAlta				CHAR(1);					-- ESTATUS ALTA
DECLARE EstImportada		CHAR(1);					-- ESTATUS IMPORTADA/GUARDADA
DECLARE Cons_NO				CHAR(1);					-- CONSTANTE NO
DECLARE Cons_SI				CHAR(1);					-- CONSTANTE SI
DECLARE Cons_Procesado		CHAR(1);					-- ESTATUS PROCESADO
DECLARE Cons_Alta			INT(11);					-- ALTA DE FACTURA Y DETALLE
DECLARE Cons_Modificacion	INT(11);					-- MODIFICACION Y GENERACION DE CONTABILIDAD DE LA FACTURA
DECLARE Cons_GenContaFacMas VARCHAR(50);				-- GeneraContaFacturasMasivas
DECLARE Var_NombreProv		VARCHAR(2000);				-- NOMBRE COMPLERO DEL PROVEEDOR

-- ASIGNACION DE CONSTANTES
SET Entero_Cero             := 0;
SET Entero_Uno				:= 1;
SET Decimal_Cero            := 0.0;
SET Cadena_Vacia            := '';
SET Fecha_Vacia             := '1900-01-01';
SET SalidaNO                := 'N';
SET SalidaSI                := 'S';
SET EstLiquidada			:= 'L';
SET EstAlta					:= 'A';
SET EstImportada			:= 'I';
SET Cons_NO					:= 'N';
SET Cons_SI					:= 'S';
SET Cons_Procesado			:= 'P';
SET Cons_Alta				:= 1;
SET Cons_Modificacion		:= 2;
SET Cons_GenContaFacMas		:= 'GeneraContaFacturasMasivas';
SET Var_FacturaID			:= Entero_Cero;
SET Var_FehaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_Poliza				:= Entero_Cero;

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-FACTURAMASIVASPROVPRO');
							SET Var_Control = 'sqlException' ;
				END;


    IF(IFNULL(Par_FolioCargaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Folio de la Carga Esta Vacio.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_Mes, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El Mes de Carga Esta Vacio.';
		SET Var_Control := 'mes';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_Mes, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El Mes de Carga Esta Vacio.';
		SET Var_Control := 'mes';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_CentroCostoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Centro de Costos Esta Vacio.';
		SET Var_Control := 'mes';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoGastoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Tipo de Gasto Esta Vacio.';
		SET Var_Control := 'mes';
		LEAVE ManejoErrores;
	END IF;

    SELECT 	FolioFacturaID,				UUID, 				Folio,						RfcEmisor,				IFNULL(CondicionesPago, '0'),
			SubTotal,					ISRRetenido,		IVARetenidoGlobal,			IVATrasladado16,		Total,
			Conceptos,					ISRTrasladado,		IVARetenido6,				IVATrasladado8
		INTO Var_FolioFacturaID,		Var_UUID,			Var_FacturaID,				Var_RfcEmisor,			Var_CondicionesPago,
			 Var_SubTotal,				Var_ISRRetenido,	Var_IVARetenidoGlobal,		Var_IVATrasladado16,	Var_Total,
			 Var_Conceptos,				Var_ISRTrasladado,	Var_IVARetenido,			Var_IVATrasladado8
		FROM BITACORACARGAFACT
		WHERE FolioCargaID = Par_FolioCargaID
		AND FolioFacturaID = Par_FolioFacturaID
		AND MesSubirFact = Par_Mes;

	IF(IFNULL(Var_FolioFacturaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Folio de Factura Esta Vacio.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

	SELECT ProveedorID INTO Var_ProveedorID
		FROM PROVEEDORES
		WHERE RFC = Var_RfcEmisor
		OR RFCpm = Var_RfcEmisor
		LIMIT 1;

	IF(IFNULL(Var_ProveedorID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := 'El Proveedor No Existe.';
		SET Var_Control := 'mes';
		SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
	END IF;

    SELECT FacturaProvID INTO Var_FacturaProvID
	FROM FACTURAPROV
    WHERE ProveedorID = Var_ProveedorID
    AND NoFactura = Var_FacturaID;

    SET Var_FacturaProvID := IFNULL(Var_FacturaProvID, Entero_Cero);

    IF(IFNULL(Var_FacturaProvID, Entero_Cero) > Entero_Cero) THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := CONCAT('El Numero de Factura del Proveedor ya Existe. [',Var_RfcEmisor,'-',Var_ProveedorID,'-',Var_FacturaID,']');
		SET Var_Control := 'mes';
        SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Var_Total, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 008;
		SET Par_ErrMen := 'El Total de la Factura Debe ser Mayor a Cero.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

        CASE Var_CondicionesPago
		WHEN "CONTADO" THEN
			SET Var_FehaVencimiento	:=Var_FehaSistema;
            SET Var_CondicionPagoID:= 1;
		WHEN "7 DIAS" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 7 DAY);
            SET Var_CondicionPagoID:= 2;
		WHEN "14 DIAS" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 14 DAY);
            SET Var_CondicionPagoID:= 3;
		WHEN "15 DIAS" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 15 DAY);
            SET Var_CondicionPagoID:= 4;
		WHEN "1 MES" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 1 MONTH);
            SET Var_CondicionPagoID:= 5;
		WHEN "2 MES" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 2 MONTH);
            SET Var_CondicionPagoID:= 6;
		WHEN "3 MES" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 3 MONTH);
            SET Var_CondicionPagoID:= 7;
		WHEN "6 MES" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 6 MONTH);
            SET Var_CondicionPagoID:= 8;
		WHEN "9 MES" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 9 MONTH);
            SET Var_CondicionPagoID:= 9;
		WHEN "1 AÑO" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 1 YEAR);
            SET Var_CondicionPagoID:= 10;
		WHEN "2 AÑOS" THEN
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL 2 YEAR);
            SET Var_CondicionPagoID:= 11;
		ELSE
			SET Var_FehaVencimiento	:= DATE_ADD(Var_FehaSistema, INTERVAL FNLIMPIACARACTBUROCRED(IFNULL(Var_CondicionesPago, '0'), "SN") DAY);
            SET Var_CondicionPagoID:= 12;
	END CASE;

	SET Var_Monto := Var_SubTotal + Var_ISRTrasladado + Var_IVATrasladado16 + Var_IVATrasladado8;
	SET Var_Conceptos := SUBSTR(Var_Conceptos,1,50);
	SET Var_DescripcionPol:= CONCAT('REGISTRO DE FACTURA ', Var_FacturaID);

    SELECT ValorParametro INTO Var_GeneraConta
		FROM PARAMGENERALES
		WHERE LlaveParametro = Cons_GenContaFacMas;

    SET Var_GeneraConta := IFNULL(Var_GeneraConta, Cons_NO);

    IF(Var_GeneraConta=Cons_SI)THEN
        -- GENERAMOS LA POLIZA CONTABLE
		CALL MAESTROPOLIZASALT(Var_Poliza, 				Aud_EmpresaID, 				Var_FehaSistema,			"A", 				'71',
							   Var_DescripcionPol,		Cons_NO,					Par_NumErr,					Par_ErrMen,			Aud_Usuario,
							   Aud_FechaActual,			Aud_DireccionIP,            Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion );


		IF(Par_NumErr!=Entero_Cero)THEN
			SET Var_Control := 'mes';
			SET Var_FacturaID := Par_FolioCargaID;
			LEAVE ManejoErrores;
		END IF;
		/*************************************************************************************************************
		-- 											PROCESO DE ALTA DE FACTURA										--
		**************************************************************************************************************/
		CALL FACTURAPROVALTPRO(Var_ProveedorID,			Var_FacturaID,			Var_FehaSistema,			EstAlta,				Var_CondicionPagoID,
							Var_FehaSistema,			Var_FehaVencimiento,	Var_Total,					Var_SubTotal,			Var_Total,
							Var_Monto,					Cons_NO,				Cadena_Vacia,				Entero_Cero,			Entero_Cero,
							Par_CentroCostoID,			Cons_NO,				Cadena_Vacia,				Cadena_Vacia,			Var_UUID,
							Var_GeneraConta,            "FM",					SalidaNO,					Par_NumErr,				Par_ErrMen,
							Aud_EmpresaID,              Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal,               Aud_NumTransaccion);
		
        IF(Par_NumErr!=Entero_Cero)THEN
			SET Var_Control := 'mes';
			SET Var_FacturaID := Par_FolioCargaID;
			LEAVE ManejoErrores;
		END IF;


	ELSE
		/*************************************************************************************************************
		-- 											PROCESO DE ALTA DE FACTURA										--
		**************************************************************************************************************/
		CALL FACTURAPROVALTPRO(Var_ProveedorID,			Var_FacturaID,			Var_FehaSistema,			EstImportada,			Var_CondicionPagoID,
							Var_FehaSistema,			Var_FehaVencimiento,	Var_Total,					Var_SubTotal,			Var_Total,
							Var_SubTotal,				Cons_NO,				Cadena_Vacia,				Entero_Cero,			Entero_Cero,
							Par_CentroCostoID,			Cons_NO,				Cadena_Vacia,				Cadena_Vacia,			Var_UUID,
							Var_GeneraConta,            "FM",					SalidaNO,					Par_NumErr,				Par_ErrMen,
							Aud_EmpresaID,              Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal,               Aud_NumTransaccion);

        IF(Par_NumErr!=Entero_Cero)THEN
			SET Var_Control := 'mes';
			SET Var_FacturaID := Par_FolioCargaID;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_NumErr!=Entero_Cero)THEN
		SET Var_Control := 'mes';
		SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
	END IF;

	-- ALTA DETALLE DE FACTURA
	CALL DETALLEFACTPROVALTPRO( Var_ProveedorID,	Var_FacturaID,			Par_CentroCostoID,				Par_CentroCostoID,			Par_TipoGastoID,
								1,					Var_SubTotal,			Var_SubTotal,					Var_Conceptos,				'S',
								Cons_NO,			Var_FehaSistema,		Var_Poliza,						Cons_NO,					Cons_NO,
								Entero_Cero,		Entero_Cero,			Entero_Cero,					Var_GeneraConta,			"FM",
								SalidaNO,           Par_NumErr,				Par_ErrMen,						Aud_EmpresaID,				Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		SET Var_Control := 'mes';
		SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
	END IF;

	-- VALIDACIONES PARA EL ALTA DE TIPO DE IMPUESTOS DEL PROVEEDOR

	SELECT 	TipoProveedor,
			CASE TipoPersona WHEN "M" THEN RazonSocial ELSE TRIM(CONCAT(PrimerNombre," ", SegundoNombre, " ", ApellidoPaterno, " ", ApellidoMaterno)) END
		INTO Var_TipoProveedor,	Var_NombreProv
    FROM PROVEEDORES
    WHERE ProveedorID=Var_ProveedorID;

	SET Var_TipoProveedor := IFNULL(Var_TipoProveedor, Entero_Cero);
	SET Var_NombreProv := TRIM(IFNULL(Var_NombreProv, Cadena_Vacia));

	SELECT COUNT(*) INTO Var_NumImpuestos
		FROM TIPOPROVEIMPUES
        WHERE TipoProveedorID = Var_TipoProveedor;

	SET Var_NumImpuestos 	:= IFNULL(Var_NumImpuestos, Entero_Cero);
	SET Var_Contador 		:= Entero_Cero;

    IF(Var_NumImpuestos = Var_Contador)THEN
		SET Par_NumErr := 009;
		SET Par_ErrMen := CONCAT('El Proveedor <b>',Var_ProveedorID,"-",Var_NombreProv, '</b> No Tiene Configurado Los Tipos de Impuesto.');
		SET Var_Control := 'mes';
		SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
    END IF;

	WHILE Var_Contador < Var_NumImpuestos DO
		SET Var_ImpuestoCatID:= Entero_Cero;
		SET Var_DesImpuesto:= Cadena_Vacia;
		SET Var_DesCortaImpuesto:= Cadena_Vacia;
		SET Var_ImpuestoID:= Entero_Cero;

		SELECT  ImpuestoID
			INTO Var_ImpuestoID
        FROM TIPOPROVEIMPUES
        WHERE TipoProveedorID = Var_TipoProveedor
		ORDER BY ImpuestoID ASC
        LIMIT Var_Contador, Entero_Uno;

        SET Var_ImpuestoID := IFNULL(Var_ImpuestoID, Entero_Cero);

		SELECT	  Descripcion,		DescripCorta
			INTO  Var_DesImpuesto,	Var_DesCortaImpuesto
			FROM IMPUESTOSCARGAMASIVA
            WHERE ImpuestoID= Var_ImpuestoID
            LIMIT Entero_Uno;

		SET Var_DesImpuesto := IFNULL(Var_DesImpuesto, Cadena_Vacia);
		SET Var_DesCortaImpuesto := IFNULL(Var_DesCortaImpuesto, Cadena_Vacia);

		CASE Var_DesCortaImpuesto
			WHEN "ISR RETE" THEN SET Var_MontoIVA:= Var_ISRRetenido;				-- ISR RETENIDO
			WHEN "ISR TRAS" THEN SET Var_MontoIVA:= Var_ISRTrasladado;				-- ISR TRASLADADO
			WHEN "IVA RETE" THEN SET Var_MontoIVA:= Var_IVARetenido;				-- IVA RETENIDO
			WHEN "IVA16 TRAS" THEN SET Var_MontoIVA:= Var_IVATrasladado16;			-- IVA TRASLADADO16
			WHEN "IVA8 TRAS" THEN SET Var_MontoIVA:= Var_IVATrasladado8;			-- IVA TRASLADADO8
		ELSE
			SET Var_MontoIVA:= Entero_Cero;
		END CASE;

		SET Var_MontoIVA:=IFNULL(Var_MontoIVA, Entero_Cero);

        -- ALTA TIPO DE IMPUESTO
		CALL DETALLEIMPFACTALTPRO(  Var_ProveedorID,	Var_FacturaID,			Entero_Uno,						Cons_NO,					Cadena_Vacia,
									Var_FehaSistema,	Par_CentroCostoID,		Entero_Cero,					Par_CentroCostoID,			Entero_Cero,
									Var_UUID,			Var_ImpuestoID,			Var_MontoIVA,					Var_Poliza,					Cons_NO,
									Var_GeneraConta,    SalidaNO,				Par_NumErr,						Par_ErrMen,					Aud_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,				Aud_ProgramaID,				Aud_Sucursal,
									Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Var_Control := 'mes';
			SET Var_FacturaID := Par_FolioCargaID;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Poliza>Entero_Cero AND Var_GeneraConta=Cons_SI)THEN
			SELECT 	SUM(Abonos),		SUM(Cargos)	INTO
					Var_TotalAbono, 	Var_TotalCargo
				FROM DETALLEPOLIZA
			WHERE PolizaID = Var_Poliza
			AND NumTransaccion = Aud_NumTransaccion;

			SET Var_TotalAbono := IFNULL(Var_TotalAbono, Entero_Cero);
			SET Var_TotalCargo := IFNULL(Var_TotalCargo, Entero_Cero);
			SET Var_DiferenciaTotales := ABS(Var_TotalCargo - Var_TotalAbono);

			IF(Var_TotalAbono != Var_TotalCargo)THEN
				SET Par_NumErr := 100;
				SET Par_ErrMen := CONCAT('Poliza descuadrada. DATOS: [Factura: ',Var_FacturaID,'<br>
																	  Total Abono: ',Var_TotalAbono,'<br>
																	  Total Cargo: ',Var_TotalCargo,'<br>
																	  Diferencia: ', Var_DiferenciaTotales,']');
				SET Var_Control := 'mes';
				SET Var_FacturaID := Par_FolioCargaID;
				LEAVE ManejoErrores;
			END IF;

		END IF;
		SET Var_Contador:=Var_Contador+1;
	END WHILE;


	-- ACTUALIZAMOS EL ESTATUS DE LA BITACORA
    CALL BITACORACARGAFACTACT(Par_FolioCargaID,			Par_FolioFacturaID,				2,
							  SalidaNO,					Par_NumErr,						Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,
                              Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);


    IF(Par_NumErr!=Entero_Cero)THEN
		SET Var_Control := 'mes';
		SET Var_FacturaID := Par_FolioCargaID;
		LEAVE ManejoErrores;
	END IF;

	SELECT COUNT(EstatusPro) INTO Var_NumExito
		FROM BITACORACARGAFACT
		WHERE  FolioCargaID=Par_FolioCargaID
		AND EstatusPro=Cons_Procesado;

	SELECT COUNT(EstatusPro) INTO Var_NumErr
		FROM BITACORACARGAFACT
		WHERE  FolioCargaID=Par_FolioCargaID
		AND TipoError!=Entero_Cero;

	SELECT NumTotalFacturas INTO Var_TotalFactura
		FROM ARCHIVOSCARGAFACT
		WHERE FolioCargaID=Par_FolioCargaID
		AND Mes= Par_Mes;

	-- ACTUALIZAMOS EL ESTATUS DEL FOLIO
	IF((Var_NumExito+Var_NumErr) = Var_TotalFactura)THEN
		UPDATE ARCHIVOSCARGAFACT
			SET Estatus = Cons_Procesado
		WHERE FolioCargaID = Par_FolioCargaID
		AND Mes = Par_Mes;
	END IF;


    IF(Var_GeneraConta=Cons_SI)THEN
		SET Par_ErrMen := CONCAT('La(s) Factura(s) : ',Var_FacturaID,'  fue(ron) Agregada(s).<b> POLIZA[ ',Var_Poliza,' ].');
	ELSE
		SET Par_ErrMen := CONCAT('La(s) Factura(s) : ',Var_FacturaID,' fue(ron) Importada(s).');
    END IF;
    SET Par_NumErr := Entero_Cero;
    SET Var_Control := 'folioCargaID';


END ManejoErrores;



IF(Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_FolioCargaID AS consecutivo;
END IF;

END TerminaStore$$