-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATIMBRADO015CFDI
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATIMBRADO015CFDI`;
DELIMITER $$

CREATE PROCEDURE `EDOCTATIMBRADO015CFDI`(
	-- SP para el timbrado del Estado de Cuenta para Sofi Express
	Par_RFCEmisor 				VARCHAR(25),			-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),			-- Razon Social del Emisor
	Par_ExpCalle 				VARCHAR(100),			-- Calle de la Sucursal de Expedicion
	Par_ExpNumero 				VARCHAR(10),			-- Numero Sucursal de Expedicion
	Par_ExpColonia 				VARCHAR(50),			-- Colonia Sucursal Expedicion

	Par_ExpMunicipio			VARCHAR(50),			-- Municipio Sucursal Expedicion
	Par_ExpEstado 				VARCHAR(50),			-- Estado Sucursal Expedicion
	Par_ExpCP 					VARCHAR(10),			-- Codigo Postal Sucursal Expedicion
	Par_Tasa 					DECIMAL(12,2),			-- Valor Tasa
	Par_NumIntEmisor 			VARCHAR(20),			-- Numero Interior Emisor

	Par_NumExtEmisor 			VARCHAR(20),			-- Numero Exterior Emisor
	Par_NumReg 					INT(11),				-- Numero de Registro
	Par_CPEmisor 				VARCHAR(12),			-- Codigo Postal Emisor
	Par_TimbraEdoCta			CHAR(1),				-- Timbrado de Estado de Cuenta: SI NO
	Par_EstadoEmisor			VARCHAR(50),			-- Estado Emisor

	Par_MuniEmisor				VARCHAR(50),			-- Municipio Emisor
	Par_LocalEmisor				VARCHAR(100),			-- Localidad Emisor
	Par_ColEmisor				VARCHAR(100),			-- Colonia Emisor
	Par_CalleEmisor				VARCHAR(100),			-- Calle Emisor
	Par_GeneraCFDI				CHAR(1),				-- Genera CFDI: SI NO

	Par_AnioMes					CHAR(6),				-- Anio y mes que se genera el Estado de Cuenta
	Par_SucursalID 				INT(11),				-- Sucursal del Cliente
	Par_NombreSucursalCte 		VARCHAR(150),			-- Nombre del Sucursal del Cliente
	Par_ClienteID 				INT(11),				-- Numero del Cliente
	Par_NombreComple 			VARCHAR(250),			-- Nombre Completo del Cliente

	Par_TipPer 					CHAR(2),				-- Tipo de Persona
	Par_TipoPersona 			VARCHAR(50),			-- Descripcion Tipo de Persona
	Par_Calle 					VARCHAR(250),			-- Calle del Cliente
	Par_NumInt					VARCHAR(10),			-- Numero Interior Domicilio del Cliente
	Par_NumExt					VARCHAR(10),			-- Numero Exterior Domicilio del Cliente

	Par_Colonia 				VARCHAR(200),			-- Colonia del Domicilio del Cliente
	Par_Estado 					VARCHAR(50),			-- Estado del Cliente
	Par_CodigoPostal 			VARCHAR(10),			-- Codigo Postal del Cliente
	Par_RFC 					VARCHAR(20),			-- RFC del Cliente
	Par_ISR 					DECIMAL(12,2),			-- ISR

	Par_FechaGeneracion 		VARCHAR(15),			-- Fecha en que se genera Informacion del Cliente
	Par_RegHacienda 			CHAR(1),				-- Registro en Hacienda: SI NO
	Par_ComisionAhorro 			DECIMAL(12,2),			-- Comision por Ahorro
	Par_ComisionCredito 		DECIMAL(12,2),			-- Comision de Credito
	Par_NombreInstitucion		VARCHAR(100),			-- Nombre Institucion

	Par_DireccionInstitucion	VARCHAR(150),			-- Direccion Institucion
	Par_MunicipioDelegacion		VARCHAR(50)				-- Municipio y Delegacion
	)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_TotalCredito 		DECIMAL(12,2);
	DECLARE Var_TotalAhorro 		DECIMAL(12,2);
	DECLARE Var_Subtotal 			DECIMAL(12,2);
	DECLARE Var_CadenaCFDI 			VARCHAR(10000);
	DECLARE Var_TotalIVAInt 		DECIMAL(12,2);

	DECLARE Var_IvaCom				DECIMAL(12,2);
	DECLARE Var_Total 				DECIMAL(12,2);
	DECLARE Var_Contador 			INT(11);
	DECLARE Var_IntCredito 			DECIMAL(12,2);
	DECLARE Var_ComMoratorio 		DECIMAL(12,2);

	DECLARE Var_ComFaltaPago 		DECIMAL(12,2);
	DECLARE Var_OtrasCom 			DECIMAL(12,2);
	DECLARE Var_DirFiscal 			VARCHAR(250);
	DECLARE Var_AbonoComision 		DECIMAL(12,2);
	DECLARE Var_AbonoIVAComision 	DECIMAL(12,2);

	DECLARE Var_CargoComision		DECIMAL(12,2);
	DECLARE Var_CargoIVAComision 	DECIMAL(12,2);
	DECLARE Var_Comision		 	DECIMAL(12,2);
	DECLARE Var_IvaComision		 	DECIMAL(12,2);
	DECLARE Var_TotalIVACom	 		DECIMAL(12,2);

	DECLARE Var_MontoMinimo			DECIMAL(12,2);
	DECLARE Var_TotalISR 			DECIMAL(12,2);
	DECLARE Var_LongRFC				INT(11);
	DECLARE Var_ValorTasa			DECIMAL(12,6);
	DECLARE Var_ImporteIntCredito 	DECIMAL(12,2);

	DECLARE Var_ImporteComMoratorio 	DECIMAL(12,2);
	DECLARE Var_ImporteComFaltaPago		DECIMAL(12,2);
	DECLARE Var_ImporteOtrasCom 		DECIMAL(12,2);
	DECLARE Var_ValorTasaISR			DECIMAL(12,6);
    DECLARE Var_BaseISR					DECIMAL(12,2);

    DECLARE Var_NumConcepto				VARCHAR(50);
    DECLARE Var_ValorIVAInt				DECIMAL(12,6);
    DECLARE Var_ValorIVAMora			DECIMAL(12,6);
    DECLARE Var_ValorIVAAccesorios		DECIMAL(12,6);
    DECLARE Var_ValorIVASucursal		DECIMAL(12,2);

    DECLARE Var_Intereses				DECIMAL(12,2);
    DECLARE Var_CadenaCFDIRet 			VARCHAR(10000);
    DECLARE Var_SubtotalRet 			DECIMAL(12,2);
	DECLARE Var_TotalRet 				DECIMAL(12,2);
	DECLARE Var_TipoInstitID			INT(11);		-- Tipo de Institucion
	DECLARE Var_ProveedorTimbrado		CHAR(1);		-- Almacena el proveedor de servicios para timbrado

	-- Declaracion de Constantes
	DECLARE Entero_Cero 			INT(11);
	DECLARE Decimal_Cero 			DECIMAL(12,2);
	DECLARE Cadena_Vacia 			CHAR(1);
	DECLARE Entero_Uno 				INT(11);
	DECLARE PersonaFisica			CHAR(1);

	DECLARE Long_PerFisica			INT(11);
	DECLARE PersonaMoral			CHAR(1);
	DECLARE Long_PerMoral			INT(11);
	DECLARE NoAltaHacienda 			CHAR(1);
	DECLARE GeneraSI 				CHAR(1);

	DECLARE RFCGenerico 			VARCHAR(151);
	DECLARE Var_Continuar 			INT(11);
	DECLARE NaturalezaCargo			CHAR(1);
	DECLARE NaturalezaAbono			CHAR(1);
	DECLARE ClasMovComision 		INT(11);

	DECLARE ClasMovIVACom 			INT(11);
	DECLARE ClasMovISR 				INT(11);
	DECLARE FormaPagoTransfer		CHAR(10);
	DECLARE ComprobanteIngreso		CHAR(1);
	DECLARE MetodoPagoPUE			CHAR(10);

	DECLARE RegFiscalPerMora		CHAR(10);
	DECLARE PorDefininir			CHAR(10);
	DECLARE Actividad				CHAR(10);
	DECLARE ImpuestoIVA				CHAR(10);
	DECLARE ClaveProdServCat		VARCHAR(20);

	DECLARE FactorTasa				CHAR(10);
	DECLARE ImpuestoISR				CHAR(10);
    DECLARE ComprobanteEgreso		CHAR(1);
    DECLARE LlaveProveTimb			VARCHAR(150);		-- Llave para consulta de proveedor de timbrado
	DECLARE Con_ProveFM				CHAR(1);			-- Constante proveedor facturacion moderna
	DECLARE Con_ProveSW				CHAR(1);			-- Constante proveedor smart web
	DECLARE TipoInstSOFOM       	INT(11);
	DECLARE FormaPagoEfectivo 		CHAR(10);
	DECLARE TipoInstrumCueAho		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero 		:= 0;					-- Entero cero
	SET Decimal_Cero 		:= 0.00;				-- DECIMAL cero
	SET Entero_Uno 			:= 1;					-- Entero uno
	SET Cadena_Vacia 		:= '';					-- Cadena vacia
	SET NoAltaHacienda 		:= 'N';					-- Alta en hacienda: NO

	SET GeneraSI 			:= 'S';					-- Genera CFDI con RFC Generico: SI
	SET RFCGenerico 		:= 'XAXX010101000'; 	-- RFC Generico
	SET Var_Continuar		:= Entero_Cero; 		-- Se valida si se continua con el timbrado CFDI
	SET PersonaFisica		:= 'F';					-- Tipo de Persona: Fisica
	SET Long_PerFisica		:= 13;					-- Longitud RFC Persona Fisica: 13

	SET PersonaMoral		:= 'M';					-- Tipo de Persona: Moral
	SET Long_PerMoral		:= 12;					-- Longitud RFC Persona Moral: 12
	SET NaturalezaCargo		:= 'C';					-- Naturaleza Movimiento: Cargo
	SET NaturalezaAbono 	:= 'A';					-- Naturaleza Movimiento: Abono
	SET ClasMovComision 	:= 2;					-- Clasificacion Movimiento: Comision

	SET ClasMovIVACom 		:= 3;					-- Clasificacion Movimiento: IVA Comision
	SET ClasMovISR 			:= 4;					-- Clasificacion Movimiento: ISR
	SET FormaPagoTransfer 	:= '03'; 				-- Forma Pago: Efectivo
	SET ComprobanteIngreso 	:= 'I';					-- Tipo Comprobante: Ingreso
	SET MetodoPagoPUE		:= 'PUE';				-- Metodo Pago: Pago en una sola exhibicion

	SET RegFiscalPerMora	:= '601';				-- Regimen Fiscal: General de Ley Personas Morales
	SET PorDefininir		:= 'P01'; 				-- Uso CFDI: Por Definir
	SET Actividad			:= 'ACT';				-- Clave Unidad: Actividad
	SET ImpuestoIVA			:= '002';				-- Impuesto: IVA
	SET ClaveProdServCat	:= '01010101';			-- Clave Producto Servicio: No Existe en el Catalogo

	SET FactorTasa			:= 'Tasa';				-- Tipo Factor Tasa
	SET ImpuestoISR			:= '001';				-- Impuesto: ISR
    SET ComprobanteEgreso 	:= 'E';					-- Tipo Comprobante: Egreso
    SET LlaveProveTimb		:= 'ProveedorTimbreEdoCta';	-- Llave para obtener el proveedor de timbrado
	SET Con_ProveFM			:= 'F';					-- Constante proveedor Facturacion Moderna
	SET Con_ProveSW			:= 'S';					-- Cosntante proveedor Smart Web
	SET TipoInstSOFOM       := 4;					-- Tipo Institucion: 4 (SOFOM) TIPOSINSTITUCION
	SET FormaPagoEfectivo 	:= '01'; 					-- Forma Pago: Efectivo
	SET TipoInstrumCueAho	:= 'A';					-- Tipo de instrumento: Cuentas de Ahorro

	-- Asignacion de variables
	SET Var_Continuar 	:= Entero_Cero;
	SET Var_Contador 	:= Var_Contador + 1;
	SET Var_LongRFC	 	:= (SELECT LENGTH(Par_RFC));
	SET Var_ValorTasa 	:= (Par_Tasa /100);

    SET Var_ValorTasaISR := (SELECT TasaISR FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
	SET Var_ValorTasaISR := (IFNULL(Var_ValorTasaISR, Entero_Cero) /100);

    SET Var_ImporteIntCredito 		:= Decimal_Cero;
	SET Var_ImporteComMoratorio 	:= Decimal_Cero;
	SET Var_ImporteComFaltaPago		:= Decimal_Cero;
	SET Var_ImporteOtrasCom 		:= Decimal_Cero;

	SET Var_ProveedorTimbrado 	:= (SELECT ProveedorTimbrado FROM PARAMETROSSIS);
	SET Var_ProveedorTimbrado 	:= IFNULL(Var_ProveedorTimbrado,Cadena_Vacia);

	-- Se obtiene el valor del IVA de Interes, IVA Moratorios e IVA del Cliente para Creditos
    SELECT 	ValorIVAInt, 		ValorIVAMora,		ValorIVAAccesorios
    INTO 	Var_ValorIVAInt, 	Var_ValorIVAMora,	Var_ValorIVAAccesorios
    FROM EDOCTARESUMCREDITOS
    WHERE ClienteID = Par_ClienteID
    LIMIT 1;

    -- Se obtiene el valor del IVA del Cliente para el IVA de las Comisiones para Captacion
	SELECT CASE WHEN Cli.PagaIVA = 'S' THEN
		IFNULL(Suc.IVA, Decimal_Cero) ELSE Decimal_Cero END
        AS IVA
	INTO Var_ValorIVASucursal
    FROM EDOCTADATOSCTE Edo,
		 CLIENTES Cli,
         SUCURSALES Suc
    WHERE Edo.ClienteID = Cli.ClienteID
    AND Cli.SucursalOrigen = Suc.SucursalID
    AND Edo.ClienteID = Par_ClienteID;

	-- Longitud de Persona Fisica: 13
	IF (Par_TipPer = PersonaFisica)THEN
		IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerFisica )THEN
			SET Var_Continuar	:= Entero_Uno;
		END IF;
	END IF;

	-- Longitud de Persona Moral: 12
	IF (Par_TipPer = PersonaMoral)THEN
		IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerMoral )THEN
			SET Var_Continuar	:= Entero_Uno;
		END IF;
	END IF;

	-- El cliente no esta dado de alta en hacienda
	IF (Par_RegHacienda = NoAltaHacienda) THEN
		-- Se genera CFDI con RFC Generico
		IF (Par_GeneraCFDI = GeneraSI ) THEN
			SET Par_RFC 	:= RFCGenerico;
			SET Var_Continuar := Entero_Cero;
		ELSE
			SET Var_Continuar := Entero_Uno;
		END IF;
	END IF;

	-- Se obtiene el tipo de institucion
	 SELECT Ins.TipoInstitID INTO Var_TipoInstitID
		FROM INSTITUCIONES Ins,
			 PARAMETROSSIS Par
		WHERE Par.InstitucionID = Ins.InstitucionID;

	IF (Var_Continuar = Entero_Cero) THEN

		/* ====================== INICIO INFORMACION TIPO TIMBRADO: INGRESOS ======================= */
		-- Se obtiene la suma de los movimientos de los creditos realizados en el periodo
		SELECT 	IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (10,11,12,13,14) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (15,16,17) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (40) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (41,42) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (22,23,24) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (20,21) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (10,11,12,13,14,15,16,17,40,41,42) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero),
				IFNULL(SUM(CASE WHEN Mov.TipoMovCreID IN (10,11,12,13,14,15,16,17,40,41,42, 20,21,22,23,24) THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero)
		INTO 	Var_IntCredito,			Var_ComMoratorio, 		Var_ComFaltaPago, 		Var_OtrasCom,		Var_IvaCom,
				Var_TotalIVAInt,		Var_SubTotal,			Var_TotalCredito
		 FROM CREDITOS Cre, CREDITOSMOVS Mov
		 WHERE	Cre.ClienteID = Par_ClienteID
			AND	Cre.CreditoID = Mov.CreditoID
			AND	CAST(CONCAT(CAST(YEAR(Mov.FechaOperacion) AS CHAR(4)),LPAD((CAST(MONTH(Mov.FechaOperacion) AS CHAR(4))),2,'00')) AS UNSIGNED) = Par_AnioMes
			AND	(((Mov.Descripcion LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%' OR Mov.Descripcion LIKE 'COMISION%'
				OR Mov.Descripcion LIKE 'COMISION%' OR Mov.Descripcion LIKE 'IVA DE COMISION%') AND Mov.NatMovimiento='A')
				OR (Mov.Referencia LIKE 'DISPOSICION%' AND	Mov.NatMovimiento='C'))
			AND Mov.TipoMovCreID IN (10,11,12,13,14,15,16,17,20,21,22,23,24,40,41,42);

		-- Se obtiene el monto de la comision realizados en el periodo (CAPTACION)
		SELECT SUM(CASE WHEN Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END) -
			 SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) INTO Var_Comision
		 FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
		 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		 AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		 AND Cue.ClienteID = Par_ClienteID
		 AND CAST(CONCAT(CAST(YEAR(Mov.Fecha) AS CHAR(4)),LPAD((CAST(MONTH(Mov.Fecha) AS CHAR(4))),2,'00')) AS UNSIGNED) = Par_AnioMes
		 AND Tip.ClasificacionMov = ClasMovComision
		 AND Mov.DescripcionMov LIKE 'COMISION%';

		SET Var_Comision := IFNULL(Var_Comision,Decimal_Cero);
		SET Var_OtrasCom := Var_OtrasCom + Var_Comision;

		-- Se obtiene el monto del iva de la comision realizados en el periodo (CAPTACION)
		SELECT SUM(CASE WHEN Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END) -
			 SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END)
			 INTO Var_IvaComision
		 FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
		 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		 AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		 AND Cue.ClienteID = Par_ClienteID
		 AND CAST(CONCAT(CAST(YEAR(Mov.Fecha) AS CHAR(4)),LPAD((CAST(MONTH(Mov.Fecha) AS CHAR(4))),2,'00')) AS UNSIGNED) = Par_AnioMes
		 AND Tip.ClasificacionMov = ClasMovIVACom
		 AND (Mov.DescripcionMov LIKE 'IVA COMISION%' OR Mov.DescripcionMov LIKE 'Iva Comision%');

		SET Var_IvaComision := IFNULL(Var_IvaComision,Decimal_Cero);
		SET Var_IvaCom 		:= Var_IvaCom + Var_IvaComision;


		--  Subtotal Tipo Timbrado: INGRESOS
		SET Var_Subtotal :=	IFNULL(Var_IntCredito, Decimal_Cero)
							+	IFNULL(Var_ComMoratorio, Decimal_Cero)
							+	IFNULL(Var_ComFaltaPago, Decimal_Cero)
							+ 	IFNULL(Var_OtrasCom, Decimal_Cero);

		SET Var_Subtotal			:= IFNULL(Var_Subtotal, Decimal_Cero);
		SET Par_Estado 				:= IFNULL(Par_Estado, Cadena_Vacia);
		SET Par_CalleEmisor			:= IFNULL(Par_CalleEmisor, Cadena_Vacia);
		SET Par_ColEmisor			:= IFNULL(Par_ColEmisor, Cadena_Vacia);
		SET Par_LocalEmisor			:= IFNULL(Par_LocalEmisor, Cadena_Vacia);
		SET Par_MuniEmisor			:= IFNULL(Par_MuniEmisor, Cadena_Vacia);
		SET Par_EstadoEmisor		:= IFNULL(Par_EstadoEmisor, Cadena_Vacia);
		SET Par_NombreComple		:= IFNULL(Par_NombreComple, Cadena_Vacia);
		SET Par_Calle				:= IFNULL(Par_Calle, Cadena_Vacia);
		SET Par_NumExt				:= IFNULL(Par_NumExt, Cadena_Vacia);
		SET Par_NumInt				:= IFNULL(Par_NumInt, Cadena_Vacia);
		SET Par_Colonia				:= IFNULL(Par_Colonia, Cadena_Vacia);
		SET Par_MunicipioDelegacion	:= IFNULL(Par_MunicipioDelegacion, Cadena_Vacia);
		SET Par_CodigoPostal		:= IFNULL(Par_CodigoPostal, Cadena_Vacia);
		SET Var_IntCredito 			:= IFNULL(Var_IntCredito, Decimal_Cero);
		SET Var_ComMoratorio 		:= IFNULL(Var_ComMoratorio, Decimal_Cero);
		SET Var_ComFaltaPago 		:= IFNULL(Var_ComFaltaPago, Decimal_Cero);
		SET Var_OtrasCom			:= IFNULL(Var_OtrasCom, Decimal_Cero);
		SET Var_TotalIVAInt			:= IFNULL(Var_TotalIVAInt, Decimal_Cero);
		SET Var_IvaCom				:= IFNULL(Var_IvaCom, Decimal_Cero);
		SET Var_TotalIVACom			:= IFNULL(Var_TotalIVACom, Decimal_Cero);
		SET Var_Comision 			:= IFNULL(Var_Comision, Decimal_Cero);
		SET Var_IvaComision 		:= IFNULL(Var_IvaComision, Decimal_Cero);


		IF(Var_ValorIVAInt > Decimal_Cero) THEN
			SET Var_ImporteIntCredito 		:= ROUND((Var_IntCredito * Var_ValorIVAInt),2);
            SET Var_ImporteIntCredito		:= IFNULL(Var_ImporteIntCredito,Decimal_Cero);
        END IF;

        IF(Var_ValorIVAMora > Decimal_Cero)THEN
			SET Var_ImporteComMoratorio 	:= ROUND((Var_ComMoratorio * Var_ValorIVAMora),2);
            SET Var_ImporteComMoratorio		:= IFNULL(Var_ImporteComMoratorio,Decimal_Cero);
        END IF;

        IF(Var_ValorIVAAccesorios > Decimal_Cero)THEN
			SET Var_ImporteComFaltaPago		:= ROUND((Var_ComFaltaPago * Var_ValorIVAAccesorios),2);
            SET Var_ImporteComFaltaPago		:= IFNULL(Var_ImporteComFaltaPago,Decimal_Cero);
		END IF;

        IF(Var_ValorIVASucursal > Decimal_Cero)THEN
			SET Var_ImporteOtrasCom		:= ROUND((Var_OtrasCom * Var_ValorIVASucursal),2);
            SET Var_ImporteOtrasCom		:= IFNULL(Var_ImporteOtrasCom,Decimal_Cero);
		END IF;

	    -- Se obtiene el valor total del IVA
 		SET Var_TotalIVACom := Var_ImporteIntCredito + Var_ImporteComMoratorio + Var_ImporteComFaltaPago + Var_ImporteOtrasCom;

		-- Se actualiza el valor Total
		SET Var_Total := Var_Subtotal + Var_TotalIVACom;

		IF(Var_ProveedorTimbrado = Con_ProveFM) THEN
			-- Se valida que el valor total sea mayor a cero para el timbrado del estado de cuenta
			IF (Var_Total > Decimal_Cero) THEN
				SET Var_CadenaCFDI = CONCAT('[ComprobanteFiscalDigital]', '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Version=3.3\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Fecha=asignarFecha\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'FormaPago=', CAST(FormaPagoTransfer AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI,	'NoCertificado=\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI,	'CondicionesDePago=CONTADO\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'SubTotal=', CAST(Var_Subtotal AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Moneda=MXN\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Total=', CAST(Var_Total AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoDeComprobante=', CAST(ComprobanteIngreso AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'MetodoPago=', CAST(MetodoPagoPUE AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'LugarExpedicion=',CAST(Par_ExpCP AS CHAR),'\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[DatosAdicionales]\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'tipoDocumento=Factura\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[Emisor]\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc=',CAST(Par_RFCEmisor AS CHAR),'\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre=',CAST(Par_RazonSocial AS CHAR),'\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'RegimenFiscal=', CAST(RegFiscalPerMora AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[Receptor]\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc=',CAST(Par_RFC AS CHAR),'\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre=',CAST(Par_NombreComple AS CHAR),'\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'UsoCFDI=', CAST(PorDefininir AS CHAR), '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				IF (Var_IntCredito > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#1';
	            END IF;

	            -- Intereses de Creditos
				IF (IFNULL(Var_IntCredito, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[',CAST(Var_NumConcepto AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ=', CAST(ClaveProdServCat AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad=1\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad=', CAST(Actividad AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Unidad=No Aplica\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion=INTERES DE CREDITO\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario=', Var_IntCredito, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe=', Var_IntCredito, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

	                -- IVA Intereses de Creditos
					IF(Var_ImporteIntCredito > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Base=[', Var_IntCredito, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Impuesto=[',CAST(ImpuestoIVA AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TipoFactor=[',CAST(FactorTasa AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TasaOCuota=[',Var_ValorTasa, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Importe=[', CAST(Var_ImporteIntCredito AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
				END IF;

				IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#1';
	            END IF;

	            IF(Var_IntCredito > Decimal_Cero AND Var_ComMoratorio > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#2';
	            END IF;

	            -- Intereses Moratorios de Credito
				IF (IFNULL(Var_ComMoratorio, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[',CAST(Var_NumConcepto AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ=', CAST(ClaveProdServCat AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad=1\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad=', CAST(Actividad AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Unidad=No Aplica\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion=INTERES MORATORIO\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario=', Var_ComMoratorio, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe=',Var_ComMoratorio,'\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

					-- IVA Intereses Moratorios de Credito
					IF(Var_ImporteComMoratorio > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Base=[', Var_ComMoratorio, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Impuesto=[',CAST(ImpuestoIVA AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TipoFactor=[',CAST(FactorTasa AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TasaOCuota=[',Var_ValorTasa, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Importe=[', CAST(Var_ImporteComMoratorio AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
				END IF;

	            IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero) THEN
	                SET Var_NumConcepto = 'Concepto#1';
				END IF;

	            IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio > Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero) OR
	                (Var_IntCredito > Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero)THEN
					SET Var_NumConcepto = 'Concepto#2';
				END IF;

				IF(Var_IntCredito > Decimal_Cero AND Var_ComMoratorio > Decimal_Cero AND
					Var_ComFaltaPago > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#3';
	            END IF;

	            -- Comision por Falta de Pago de Creditos
				IF (IFNULL(Var_ComFaltaPago, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[',CAST(Var_NumConcepto AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ=',CAST(ClaveProdServCat AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad=1\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad=', CAST(Actividad AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Unidad=No Aplica\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion=COMISION FALTA DE PAGO\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario=', Var_ComFaltaPago, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe=',Var_ComFaltaPago,'\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

	                -- IVA Comision por Falta de Pago de Creditos
					IF(Var_ImporteComFaltaPago > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Base=[', Var_ComFaltaPago, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Impuesto=[',CAST(ImpuestoIVA AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TipoFactor=[',CAST(FactorTasa AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TasaOCuota=[',Var_ValorTasa, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Importe=[', CAST(Var_ImporteComFaltaPago AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
				END IF;

				IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago = Decimal_Cero AND Var_OtrasCom > Decimal_Cero) THEN
	                SET Var_NumConcepto = 'Concepto#1';
				END IF;

				IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero AND Var_OtrasCom > Decimal_Cero) OR
	                (Var_IntCredito > Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago = Decimal_Cero AND Var_OtrasCom > Decimal_Cero) OR
	                (Var_IntCredito = Decimal_Cero AND Var_ComMoratorio > Decimal_Cero
					AND Var_ComFaltaPago = Decimal_Cero AND Var_OtrasCom > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#2';
				END IF;

	            IF(Var_IntCredito = Decimal_Cero AND Var_ComMoratorio > Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero AND Var_OtrasCom > Decimal_Cero) OR
	                (Var_IntCredito > Decimal_Cero AND Var_ComMoratorio = Decimal_Cero
					AND Var_ComFaltaPago > Decimal_Cero AND Var_OtrasCom > Decimal_Cero) OR
	                (Var_IntCredito > Decimal_Cero AND Var_ComMoratorio > Decimal_Cero
					AND Var_ComFaltaPago = Decimal_Cero AND Var_OtrasCom > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#3';
				END IF;

				IF(Var_IntCredito > Decimal_Cero AND Var_ComMoratorio > Decimal_Cero AND
					Var_ComFaltaPago > Decimal_Cero AND Var_OtrasCom > Decimal_Cero) THEN
					SET Var_NumConcepto = 'Concepto#4';
	            END IF;

				-- Otras Comisiones de Credito y Captacion
				IF (IFNULL(Var_OtrasCom, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[',CAST(Var_NumConcepto AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ=', CAST(ClaveProdServCat AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad=1\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad=', CAST(Actividad AS CHAR), '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Unidad=No Aplica\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion=OTRAS COMISIONES\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario=', Var_OtrasCom, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe=', Var_OtrasCom,'\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

	                -- IVA Otras Comisiones de Credito y Captacion
					IF(Var_ImporteOtrasCom > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Base=[', Var_OtrasCom, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Impuesto=[',CAST(ImpuestoIVA AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TipoFactor=[',CAST(FactorTasa AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.TasaOCuota=[',Var_ValorTasa, ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuestos.Traslados.Importe=[', CAST(Var_ImporteOtrasCom AS CHAR), ']\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
				END IF;

	            -- Se obtiene el Valor de los Impuestos Trasladados
	            IF(Var_TotalIVACom > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '[Traslados]\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosTrasladados=', Var_TotalIVACom, '\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto=[',CAST(ImpuestoIVA AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor=[',CAST(FactorTasa AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota=[',Var_ValorTasa, ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe=[', CAST(Var_TotalIVACom AS CHAR), ']\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;


				-- Se actualizan registros para el Tipo Timbrado: Ingreso
				UPDATE EDOCTADATOSCTE SET
					TotalInteres	= (Var_IntCredito + Var_ComMoratorio),  -- Total Intereses Credito
					ComisionCredito = Var_TotalIVAInt, 						-- Total IVA's Intereses Credito
					Comisiones		= Var_OtrasCom + Var_ComFaltaPago,    	-- Comisiones Credito y Captacion
					IvaComisiones 	= Var_IvaCom,							-- IVA Comisiones Credito y Captacion
					ComisionAhorro 	= Var_IvaComision,  					-- IVA Comisiones Captacion
					CadenaCFDI 		= Var_CadenaCFDI  						-- Cadena CFDI Tipo Timbrado Ingreso
				WHERE ClienteID = Par_ClienteID;
	        END IF;
		END IF;

		IF(Var_ProveedorTimbrado = Con_ProveSW) THEN
			IF (Var_Total > Decimal_Cero) THEN
				SET Var_CadenaCFDI = CONCAT('<?xml version="1.0" encoding="UTF-8"?>', '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Version="3.3" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Fecha="', CURDATE(), 'T', CURTIME(), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Sello="" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'NoCertificado="" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Certificado="" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'LugarExpedicion="',CAST(Par_ExpCP AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoDeComprobante="', CAST(ComprobanteIngreso AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'FormaPago="', CAST(FormaPagoEfectivo AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI,	'CondicionesDePago="CONTADO" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'MetodoPago="', CAST(MetodoPagoPUE AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Moneda="MXN" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'SubTotal="', CAST(Var_Subtotal AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Total="', CAST(Var_Total AS CHAR), '">');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Emisor ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc="',CAST(Par_RFCEmisor AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre="',CAST(Par_RazonSocial AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'RegimenFiscal="', CAST(RegFiscalPerMora AS CHAR), '"/>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Receptor ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc="',CAST(Par_RFC AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre="',CAST(Par_NombreComple AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'UsoCFDI="', CAST(PorDefininir AS CHAR), '"/>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Conceptos>\n');

				IF (IFNULL(Var_IntCredito, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="INTERES DE CREDITO" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_IntCredito, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', Var_IntCredito, '">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

					IF(Var_ImporteIntCredito > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_IntCredito, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteIntCredito AS CHAR), '"/>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				IF (IFNULL(Var_ComMoratorio, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="INTERES MORATORIO" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_ComMoratorio, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="',Var_ComMoratorio,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

					IF(Var_ImporteComMoratorio > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_ComMoratorio, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteComMoratorio AS CHAR), '"/>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				IF (IFNULL(Var_ComFaltaPago, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="',CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="COMISION FALTA DE PAGO" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_ComFaltaPago, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="',Var_ComFaltaPago,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

					IF(Var_ImporteComFaltaPago > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_ComFaltaPago, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteComFaltaPago AS CHAR), '"/>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				IF (IFNULL(Var_OtrasCom, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="OTRAS COMISIONES" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_OtrasCom, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', Var_OtrasCom,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');

					IF(Var_ImporteOtrasCom > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_OtrasCom, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteOtrasCom AS CHAR), '"/>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Conceptos>\n');

				IF(Var_TotalIVACom > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosTrasladados="', Var_TotalIVACom, '">\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_TotalIVACom AS CHAR), '"/>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				IF(Var_TotalISR > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosRetenidos="', Var_TotalISR, '">\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Retenciones>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Retencion ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoISR AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_TotalISR AS CHAR), '"/>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Retenciones>\n');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				END IF;

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Comprobante>');

				UPDATE EDOCTADATOSCTE SET
					ComisionAhorro 	= Var_Comision,
					ComisionCredito = (Var_ComFaltaPago + Var_OtrasCom),
					CadenaCFDI 		= Var_CadenaCFDI,
					TotalInteres	= (Var_IntCredito  + Var_ComMoratorio),
					Comisiones		= Var_OtrasCom,
					IvaComisiones   = Var_IvaComision,
					EstatusCadenaProd = "S"
				WHERE ClienteID = Par_ClienteID;
			END IF;
		END IF;
			

		/* ====================== FIN INFORMACION TIPO TIMBRADO: INGRESOS ======================= */


		/* ====================== INICIO INFORMACION TIPO TIMBRADO: EGRESOS ======================= */

		-- Se obtiene el Monto del ISR del periodo
		SELECT SUM(CASE WHEN Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END) INTO Var_TotalISR
			 FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
			 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
			 AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
			 AND Cue.ClienteID = Par_ClienteID
			 AND CAST(CONCAT(CAST(YEAR(Mov.Fecha) AS CHAR(4)),LPAD((CAST(MONTH(Mov.Fecha) AS CHAR(4))),2,'00')) AS UNSIGNED) = Par_AnioMes
			 AND Tip.ClasificacionMov = ClasMovISR;

        SET Var_TotalISR 		:= IFNULL(Var_TotalISR, Decimal_Cero);

        SELECT SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) INTO Var_Intereses
			 FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
			 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
			 AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
			 AND Cue.ClienteID = Par_ClienteID
			 AND CAST(CONCAT(CAST(YEAR(Mov.Fecha) AS CHAR(4)),LPAD((CAST(MONTH(Mov.Fecha) AS CHAR(4))),2,'00')) AS UNSIGNED) = Par_AnioMes
			AND Mov.TipoMovAhoID IN(62,63,200,201);

        SET Var_Intereses 		:= IFNULL(Var_Intereses, Decimal_Cero);

		IF(Var_ValorTasaISR > Entero_Cero)THEN
			SET Var_BaseISR		:= ROUND((Var_TotalISR/Var_ValorTasaISR),2);
		ELSE
			SET Var_BaseISR		:= Entero_Cero;
		END IF;

		--  Subtotal Tipo Timbrado: Egresos
		SET Var_SubtotalRet 	:= Var_BaseISR;

		SET Var_TotalRet 		:= Var_SubtotalRet - Var_TotalISR;

         /* ====================== FIN INFORMACION TIPO TIMBRADO: EGRESOS ======================= */
	END IF;

END TerminaStore$$