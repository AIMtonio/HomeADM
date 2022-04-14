-- EDOCTA2TIMBRADOCFDISW
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2TIMBRADOCFDISW`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAV2TIMBRADOCFDISW`(
	-- SP para el timbrado del Estado de Cuenta
	Par_RFCEmisor 				VARCHAR(25),			-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),			-- Razon Social del Emisor
	Par_ExpCalle 				VARCHAR(50),			-- Calle de la Sucursal de Expedicion
	Par_ExpNumero 				VARCHAR(10),			-- Numero Sucursal de Expedicion
	Par_ExpColonia 				VARCHAR(50),			-- Colonia Sucursal Expedicion

	Par_ExpMunicipio			VARCHAR(50),			-- Municipio Sucursal Expedicion
	Par_ExpEstado 				VARCHAR(50),			-- Estado Sucursal Expedicion
	Par_ExpCP 					VARCHAR(10),			-- Codigo Postal Sucursal Expedicion
	Par_Tasa 					DECIMAL(14,2),			-- Valor Tasa
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


	Par_FechaGeneracion 		VARCHAR(15),			-- Fecha en que se genera Informacion del Cliente
	Par_RegHacienda 			CHAR(1)				-- Registro en Hacienda: SI NO

	)

TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_TotalCredito			DECIMAL(18,2);
	DECLARE Var_TotalAhorro 			DECIMAL(18,2);
	DECLARE Var_SubTotal 				DECIMAL(18,2);
	DECLARE Var_TotalInver				DECIMAL(18,2);
	DECLARE Var_CadenaCFDI 				VARCHAR(10000);

	DECLARE Var_TotalIVA 				DECIMAL(18,2);
	DECLARE Var_Total 					DECIMAL(18,2);
	DECLARE Var_Contador 				INT(11);
	DECLARE Var_IntCredito 				DECIMAL(18,2);
	DECLARE Var_MontoBase				DECIMAL(18,2);
	DECLARE Var_ComMoratorio 			DECIMAL(18,2);

	DECLARE Var_ComFaltaPago 			DECIMAL(18,2);
	DECLARE Var_OtrasCom 				DECIMAL(18,2);
	DECLARE Var_DirFiscal 				VARCHAR(250);
	DECLARE Var_LongRFC					INT(11);
	DECLARE Var_MontoMinimo				DECIMAL(14,2);

	DECLARE Var_TipoInstitID			INT(11);
	DECLARE Var_IntCreditoGen 			DECIMAL(18,2);
	DECLARE Var_ComMoratorioGen 		DECIMAL(18,2);
	DECLARE Var_ComFaltaPagoGen 		DECIMAL(18,2);
	DECLARE Var_OtrasComGen 			DECIMAL(18,2);

	DECLARE Var_TotalIVAGen 			DECIMAL(18,2);
	DECLARE Var_SubTotalGen 			DECIMAL(18,2);
	DECLARE Var_Comision				DECIMAL(18,2);
	DECLARE Var_IvaComision				DECIMAL(18,2);
	DECLARE Var_TotalISR				DECIMAL(18,2);

	DECLARE Var_TotalIVACom				DECIMAL(18,2);
	DECLARE Var_ValorTasa				DECIMAL(12,6);
	DECLARE Var_ValorTasaISR			DECIMAL(12,6);

	DECLARE Var_ImporteIvaIntCredito 	DECIMAL(18,2);
	DECLARE Var_ImporteComMoratorio 	DECIMAL(18,2);
	DECLARE Var_ImporteComFaltaPago		DECIMAL(18,2);
	DECLARE Var_ImporteOtrasCom 		DECIMAL(18,2);
	DECLARE Var_BaseISR					DECIMAL(18,2);
	DECLARE Var_NumConcepto				VARCHAR(50);
	DECLARE Var_ValorIVAInt				DECIMAL(18,6);
	DECLARE Var_ValorIVAMora			DECIMAL(18,6);
	DECLARE Var_ValorIVAAccesorios		DECIMAL(18,6);
	DECLARE Var_ValorIVASucursal		DECIMAL(18,2);

	DECLARE Var_Intereses				DECIMAL(18,2);
	DECLARE Var_CadenaCFDIRet 			VARCHAR(10000);
	DECLARE Var_SubtotalRet 			DECIMAL(18,2);
	DECLARE Var_TotalRet 				DECIMAL(18,2);
	DECLARE Var_ImporteCalculado		DECIMAL(20,4);		-- Importe calculado


	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Decimal_Cero 		DECIMAL(14,2);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Entero_Uno 			INT(11);
	DECLARE PersonaFisica		CHAR(1);

	DECLARE Long_PerFisica		INT(11);
	DECLARE PersonaMoral		CHAR(1);
	DECLARE Long_PerMoral		INT(11);
	DECLARE GeneraSI 			CHAR(1);
	DECLARE RFCGenerico 		VARCHAR(151);

	DECLARE Var_Continuar 		INT(11);
	DECLARE NoAltaHacienda 		CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);
	DECLARE NaturalezaAbono		CHAR(1);
	DECLARE TipoInstSOFOM		INT(11);

	DECLARE ClasMovComision		INT(11);
	DECLARE ClasMovIVACom		INT(11);
	DECLARE ClasMovISR			INT(11);
	DECLARE FormaPagoEfectivo 		CHAR(10);
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
	DECLARE TipoInstrumCredito		CHAR(1);
	DECLARE TipoInstrumCueAho		CHAR(1);

	DECLARE VAR_INTERESCREDITO		INT(2);
	DECLARE VAR_IVAINTERESCREDITO	INT(2);
	DECLARE VAR_INTERESMORA			INT(2);
	DECLARE VAR_IVAINTERESMORA		INT(2);
	DECLARE VAR_COMISIONES			INT(2);
	DECLARE VAR_IVACOMISIONES		INT(2);
	DECLARE VAR_OTRASCOMISI			INT(2);
	DECLARE VAR_IVAOTRASCOMISI		INT(2);
	DECLARE VAR_SALTO_LINEA			VARCHAR(2);
	DECLARE Var_LimInfSup			DECIMAL(14,2);	-- Limite para el valor del importe que corresponde a traslado

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero cero
	SET Decimal_Cero		:= 0.00;				-- Decimal cero
	SET Entero_Uno			:= 1;					-- Entero uno
	SET Cadena_Vacia		:= '';					-- Cadena vacia
	SET PersonaFisica		:= 'F';					-- Tipo de Persona: Fisica

	SET Long_PerFisica		:= 13;					-- Longitud RFC Persona Fisica: 13
	SET PersonaMoral		:= 'M';					-- Tipo de Persona: Moral
	SET Long_PerMoral		:= 12;					-- Longitud RFC Persona Moral: 12
	SET GeneraSI			:= 'S';					-- Genera CFDI con RFC Generico: SI
	SET RFCGenerico			:= 'XAXX010101000'; 	-- RFC Generico

	SET Var_Continuar		:= Entero_Cero; 		-- Se valida si se continua con el timbrado CFDI
	SET NoAltaHacienda		:= 'N';					-- Alta en hacienda: NO
	SET NaturalezaCargo		:= 'C';					-- Naturaleza Movimiento: Cargo
	SET NaturalezaAbono		:= 'A';					-- Naturaleza Movimiento: Abono
	SET TipoInstSOFOM		:= 4;					-- Tipo Institucion: 4 (SOFOM) TIPOSINSTITUCION

	SET ClasMovComision 	:= 2;					-- Clasificacion Movimiento: Comision
	SET ClasMovIVACom		:= 3;					-- Clasificacion Movimiento: IVA Comision
	SET ClasMovISR			:= 4;					-- Clasificacion Movimiento: ISR
	SET FormaPagoEfectivo	:= '01'; 				-- Forma Pago: Efectivo
	SET ComprobanteIngreso	:= 'I';					-- Tipo Comprobante: Ingreso

	SET MetodoPagoPUE		:= 'PUE';				-- Metodo Pago: Pago en una sola exhibicion
	SET RegFiscalPerMora	:= '601';				-- Regimen Fiscal: General de Ley Personas Morales
	SET PorDefininir		:= 'G03'; 				-- Uso CFDI: Gastos en General
	SET Actividad			:= 'E48';				-- Clave Unidad: Actividad
	SET ImpuestoIVA			:= '002';				-- Impuesto: IVA

	SET ClaveProdServCat	:= '84121500';				-- Clave Producto Servicio: Instituciones bancarias
	SET FactorTasa			:= 'Tasa';				-- Tipo Factor Tasa
	SET ImpuestoISR			:= '001';				-- Impuesto: ISR
	SET ComprobanteEgreso	:= 'E';					-- Tipo Comprobante: Egreso
	SET TipoInstrumCredito	:= 'C';					-- Tipo de instrumento: Credito
	SET TipoInstrumCueAho	:= 'A';					-- Tipo de instrumento: Cuentas de Ahorro

	SET VAR_INTERESCREDITO		:= 1;
	SET VAR_IVAINTERESCREDITO	:= 2;
	SET VAR_INTERESMORA			:= 3;
	SET VAR_IVAINTERESMORA		:= 4;
	SET VAR_COMISIONES			:= 5;
	SET VAR_IVACOMISIONES		:= 6;
	SET VAR_OTRASCOMISI			:= 7;
	SET VAR_IVAOTRASCOMISI		:= 8;
	SET VAR_SALTO_LINEA			:= '';
	SET Var_LimInfSup			:= 0.01;			-- Limite para el valor del importe que corresponde a traslado

	-- Asignacion de variables
	SET Var_Continuar 	:= Entero_Cero;
	SET Var_Contador 	:= Var_Contador + 1;
	SET Var_LongRFC	 	:= (SELECT LENGTH(Par_RFC));
	SET Var_ValorTasa 	:= (Par_Tasa /100);

	SET Var_ValorTasaISR 	:= (SELECT TasaISR FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
	SET Var_ValorTasaISR 	:= (IFNULL(Var_ValorTasaISR,Entero_Cero) /100);

	SET Var_ImporteIvaIntCredito 		:= Decimal_Cero;
	SET Var_ImporteComMoratorio 	:= Decimal_Cero;
	SET Var_ImporteComFaltaPago		:= Decimal_Cero;
	SET Var_ImporteOtrasCom 		:= Decimal_Cero;

	-- Se obtiene el valor del IVA de Interes, IVA Moratorios e IVA del Cliente para Creditos
	SELECT	ValorIVA
	INTO	Var_ValorIVAInt
	FROM EDOCTAV2CFDIDATOS
	WHERE ClienteID = Par_ClienteID
	  AND TipoConcepto = VAR_INTERESCREDITO
	  AND TipoInstrumento = TipoInstrumCredito
	  LIMIT 1;

	SELECT	ValorIVA
	INTO	Var_ValorIVAMora
	FROM EDOCTAV2CFDIDATOS
	WHERE ClienteID = Par_ClienteID
	  AND TipoConcepto = VAR_INTERESMORA
	  AND TipoInstrumento = TipoInstrumCredito
	  LIMIT 1;

	SELECT	ValorIVA
	INTO	Var_ValorIVAAccesorios
	FROM EDOCTAV2CFDIDATOS
	WHERE ClienteID = Par_ClienteID
	  AND TipoConcepto = VAR_COMISIONES
	  AND TipoInstrumento = TipoInstrumCredito
	  LIMIT 1;

	-- Se obtiene el valor del IVA del Cliente para el IVA de las Comisiones para Captacion
	SELECT CASE WHEN Cli.PagaIVA = 'S' THEN
		IFNULL(Suc.IVA, Decimal_Cero) ELSE Decimal_Cero END
		AS IVA
	INTO Var_ValorIVASucursal
	FROM EDOCTAV2DATOSCTE Edo,
		 CLIENTES Cli,
		 SUCURSALES Suc
	WHERE Edo.ClienteID = Cli.ClienteID
	AND Cli.SucursalOrigen = Suc.SucursalID
	AND Edo.ClienteID = Par_ClienteID;

	 -- Se obtiene el tipo de institucion
	 SELECT Ins.TipoInstitID INTO Var_TipoInstitID
		FROM INSTITUCIONES Ins,
			 PARAMETROSSIS Par
		WHERE Par.InstitucionID = Ins.InstitucionID;

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
	IF ( IFNULL(Par_RegHacienda, NoAltaHacienda) = NoAltaHacienda) THEN
		-- Se genera CFDI con RFC Generico
		IF ( Par_GeneraCFDI = GeneraSI ) THEN
			SET Par_RFC 	:= RFCGenerico;
			SET Var_Continuar := Entero_Cero;
		ELSE
			SET Var_Continuar := Entero_Uno;
		END IF;
	END IF;

	IF (Var_Continuar = Entero_Cero) THEN
		IF (Var_TipoInstitID != TipoInstSOFOM) THEN
			-- Se obtiene el monto de Interes,Moratorios, Comisiones e IVAS pagados por el cliente
			SELECT	SUM(Monto)
			INTO	Var_IntCredito
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND TipoConcepto = VAR_INTERESCREDITO
			  AND TipoInstrumento = TipoInstrumCredito;


			-- sacamos el iva pagado del interes normal
			SELECT	SUM(Monto)
			INTO	Var_ImporteIvaIntCredito
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND TipoConcepto = VAR_IVAINTERESCREDITO
			  AND TipoInstrumento = TipoInstrumCredito;

			SELECT	SUM(Monto)
			INTO	Var_ComMoratorio
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND TipoConcepto = VAR_INTERESMORA
			  AND TipoInstrumento = TipoInstrumCredito;

			SELECT	SUM(Monto)
			INTO	Var_Comision
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND TipoConcepto = VAR_COMISIONES
			  AND TipoInstrumento = TipoInstrumCredito;

			SELECT	SUM(Monto)
			INTO	Var_OtrasCom
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND TipoConcepto = VAR_OTRASCOMISI
			  AND TipoInstrumento = TipoInstrumCueAho ;


			SET Var_TotalIVACom		:= IFNULL(Var_TotalIVACom, Decimal_Cero);
			SET Var_IntCredito		:= IFNULL(Var_IntCredito, Decimal_Cero);
			SET Var_ComMoratorio	:= IFNULL(Var_ComMoratorio, Decimal_Cero);
			SET Var_ComFaltaPago	:= IFNULL(Var_ComFaltaPago, Decimal_Cero);
			SET Var_Comision		:= IFNULL(Var_Comision, Decimal_Cero);
			SET Var_OtrasCom		:= IFNULL(Var_OtrasCom, Decimal_Cero);
			SET Var_TotalIVA		:= IFNULL(Var_TotalIVA, Decimal_Cero);



			-- Se obtiene el monto del iva de la comision realizados en el periodo
			SELECT	SUM(Monto)
			INTO	Var_IvaComision
			FROM EDOCTAV2CFDIDATOS
			WHERE ClienteID = Par_ClienteID
			  AND Concepto = 'OTRAS COMISIONES DE CREDITO'
			  AND TipoInstrumento = TipoInstrumCueAho;

			SET Var_IvaComision := IFNULL(Var_IvaComision, Decimal_Cero);

		END IF;



		SET Var_SubTotal		:= IFNULL(Var_SubTotal, Decimal_Cero);
		SET Par_Estado 			:= IFNULL(Par_Estado, Cadena_Vacia);
		SET Par_CalleEmisor		:= IFNULL(Par_CalleEmisor, Cadena_Vacia);
		SET Par_ColEmisor		:= IFNULL(Par_ColEmisor, Cadena_Vacia);
		SET Par_LocalEmisor		:= IFNULL(Par_LocalEmisor, Cadena_Vacia);
		SET Par_MuniEmisor		:= IFNULL(Par_MuniEmisor, Cadena_Vacia);
		SET Par_EstadoEmisor	:= IFNULL(Par_EstadoEmisor, Cadena_Vacia);
		SET Par_NombreComple	:= IFNULL(Par_NombreComple, Cadena_Vacia);
		SET Par_Calle			:= IFNULL(Par_Calle, Cadena_Vacia);
		SET Par_NumExt			:= IFNULL(Par_NumExt, Cadena_Vacia);
		SET Par_NumInt			:= IFNULL(Par_NumInt, Cadena_Vacia);
		SET Par_Colonia			:= IFNULL(Par_Colonia, Cadena_Vacia);
		SET Par_CodigoPostal	:= IFNULL(Par_CodigoPostal, Cadena_Vacia);
		SET Var_IntCredito 		:= IFNULL(Var_IntCredito, Decimal_Cero);
		SET Var_ComMoratorio 	:= IFNULL(Var_ComMoratorio, Decimal_Cero);
		SET Var_ComFaltaPago 	:= IFNULL(Var_ComFaltaPago, Decimal_Cero);
		SET Var_OtrasCom		:= IFNULL(Var_OtrasCom, Decimal_Cero);
		SET Var_TotalIVA		:= IFNULL(Var_TotalIVA, Decimal_Cero);
		SET Var_TotalInver 		:= IFNULL(Var_TotalInver,Decimal_Cero);
		SET Var_IntCreditoGen	:= IFNULL(Var_IntCreditoGen,Decimal_Cero);
		SET Var_ComMoratorioGen := IFNULL(Var_ComMoratorioGen,Decimal_Cero);
		SET Var_ComFaltaPagoGen := IFNULL(Var_ComFaltaPagoGen,Decimal_Cero);
		SET Var_OtrasComGen 	:= IFNULL(Var_OtrasComGen,Decimal_Cero);
		SET Var_TotalIVAGen 	:= IFNULL(Var_TotalIVAGen,Decimal_Cero);
		SET Var_SubTotalGen 	:= IFNULL(Var_SubTotalGen,Decimal_Cero);
		SET Var_TotalISR 		:= IFNULL(Var_TotalISR, Decimal_Cero);

		IF (Var_TipoInstitID != TipoInstSOFOM) THEN

			SET Var_MontoBase = Var_IntCredito;

			IF(Var_ValorIVAInt > Decimal_Cero) THEN
				SET Var_MontoBase 				:= ROUND((Var_ImporteIvaIntCredito / Var_ValorIVAInt),2); -- se calcula el interes en base al iva pagado (Interes Ordinario)
				SET Var_MontoBase				:= IFNULL(Var_MontoBase,Decimal_Cero);
			END IF;

			SET Var_ImporteCalculado		:= Var_MontoBase * Var_ValorTasa;
			SET Var_ImporteCalculado		:= IFNULL(Var_ImporteCalculado, Decimal_Cero);
			SET Var_ImporteIvaIntCredito	:= IF(ABS(Var_ImporteCalculado - Var_ImporteIvaIntCredito) > Var_LimInfSup, ROUND(Var_ImporteCalculado, 2), Var_ImporteIvaIntCredito);
			SET Var_ImporteIvaIntCredito	:= IFNULL(Var_ImporteIvaIntCredito, Decimal_Cero);

			IF(Var_ValorIVAMora > Decimal_Cero)THEN
				-- SET Var_ImporteComMoratorio 	:= ROUND((Var_ComMoratorio * Var_ValorIVAMora),2);
				SELECT	SUM(Monto)
				INTO	Var_ImporteComMoratorio
				FROM EDOCTAV2CFDIDATOS
				WHERE ClienteID = Par_ClienteID
				AND TipoConcepto = VAR_IVAINTERESMORA
				AND TipoInstrumento = TipoInstrumCredito;

				SET Var_ImporteComMoratorio		:= IFNULL(Var_ImporteComMoratorio,Decimal_Cero);

				SET Var_ImporteCalculado		:= Var_ComMoratorio * Var_ValorTasa;
				SET Var_ImporteCalculado		:= IFNULL(Var_ImporteCalculado, Decimal_Cero);
				SET Var_ImporteComMoratorio		:= IF(ABS(Var_ImporteCalculado - Var_ImporteComMoratorio) > Var_LimInfSup, ROUND(Var_ImporteCalculado, 2), Var_ImporteComMoratorio);
				SET Var_ImporteComMoratorio		:= IFNULL(Var_ImporteComMoratorio, Decimal_Cero);
			END IF;



			IF(Var_ValorIVASucursal > Decimal_Cero)THEN

				SELECT	SUM(Monto)
				INTO	Var_IvaComision
				FROM EDOCTAV2CFDIDATOS
				WHERE ClienteID = Par_ClienteID
				AND TipoConcepto = VAR_IVACOMISIONES
				AND TipoInstrumento = TipoInstrumCredito;

				SET Var_IvaComision		:= IFNULL(Var_IvaComision,Decimal_Cero);

				-- SET Var_ImporteOtrasCom		:= ROUND((Var_OtrasCom * Var_ValorIVASucursal),2);
				SELECT	SUM(Monto)
				INTO	Var_ImporteOtrasCom
				FROM EDOCTAV2CFDIDATOS
				WHERE ClienteID = Par_ClienteID
				AND TipoConcepto = VAR_IVAOTRASCOMISI
				AND TipoInstrumento = TipoInstrumCueAho;
				SET Var_ImporteOtrasCom		:= IFNULL(Var_ImporteOtrasCom,Decimal_Cero);

				SET Var_ImporteCalculado		:= Var_Comision * Var_ValorTasa;
				SET Var_ImporteCalculado		:= IFNULL(Var_ImporteCalculado, Decimal_Cero);
				SET Var_IvaComision				:= IF(ABS(Var_ImporteCalculado - Var_IvaComision) > Var_LimInfSup, ROUND(Var_ImporteCalculado, 2), Var_IvaComision);
				SET Var_IvaComision				:= IFNULL(Var_IvaComision, Decimal_Cero);

				SET Var_ImporteCalculado		:= Var_OtrasCom * Var_ValorTasa;
				SET Var_ImporteCalculado		:= IFNULL(Var_ImporteCalculado, Decimal_Cero);
				SET Var_ImporteOtrasCom			:= IF(ABS(Var_ImporteCalculado - Var_ImporteOtrasCom) > Var_LimInfSup, ROUND(Var_ImporteCalculado, 2), Var_ImporteOtrasCom);
				SET Var_ImporteOtrasCom			:= IFNULL(Var_ImporteOtrasCom, Decimal_Cero);
			END IF;

			SET Var_TotalIVACom := Var_ImporteIvaIntCredito + Var_ImporteComMoratorio + Var_IvaComision + Var_ImporteOtrasCom;

		END IF;

		SET Var_SubTotal		:= (Var_IntCredito + Var_ComMoratorio + Var_Comision + Var_OtrasCom);
		SET Var_SubTotal		:= IFNULL(Var_SubTotal, Decimal_Cero);
		SET Var_Total			:= Var_SubTotal + Var_TotalIVACom;


	IF (Var_TipoInstitID != TipoInstSOFOM) THEN

		IF (Var_Total > Decimal_Cero) THEN
				SET Var_CadenaCFDI = CONCAT('<?xml version="1.0" encoding="UTF-8"?>', VAR_SALTO_LINEA);
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
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'SubTotal="', CAST(Var_SubTotal AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Total="', CAST(Var_Total AS CHAR), '">');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Emisor ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc="',CAST(Par_RFCEmisor AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre="',CAST(Par_RazonSocial AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'RegimenFiscal="', CAST(RegFiscalPerMora AS CHAR), '"/>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Receptor ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Rfc="',CAST(Par_RFC AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Nombre="',CAST(Par_NombreComple AS CHAR),'" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'UsoCFDI="', CAST(PorDefininir AS CHAR), '"/>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Conceptos>',VAR_SALTO_LINEA);

				IF (IFNULL(Var_IntCredito, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="INTERES DE CREDITO" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_IntCredito, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', Var_IntCredito, '">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

					IF(Var_ImporteIvaIntCredito > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_MontoBase, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteIvaIntCredito AS CHAR), '"/>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				IF (IFNULL(Var_ComMoratorio, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="INTERES MORATORIO" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_ComMoratorio, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="',Var_ComMoratorio,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

					IF(Var_ImporteComMoratorio > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_ComMoratorio, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteComMoratorio AS CHAR), '"/>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				IF (IFNULL(Var_Comision, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="',CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="COMISIONES" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_Comision, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="',Var_Comision,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

					IF(Var_IvaComision > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_Comision, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_IvaComision AS CHAR), '"/>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				IF (IFNULL(Var_OtrasCom, Decimal_Cero) > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="OTRAS COMISIONES" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_OtrasCom, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', Var_OtrasCom,'">');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);

					IF(Var_ImporteOtrasCom > Decimal_Cero)THEN
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Base="', Var_OtrasCom, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_ImporteOtrasCom AS CHAR), '"/>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>',VAR_SALTO_LINEA);
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
						SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
					END IF;
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Conceptos>',VAR_SALTO_LINEA);

				IF(Var_TotalIVACom > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosTrasladados="', Var_TotalIVACom, '">',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_TotalIVACom AS CHAR), '"/>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				IF(Var_TotalISR > Decimal_Cero) THEN
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosRetenidos="', Var_TotalISR, '">',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Retenciones>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Retencion ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoISR AS CHAR), '" ');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_TotalISR AS CHAR), '"/>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Retenciones>',VAR_SALTO_LINEA);
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
					SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, VAR_SALTO_LINEA);
				END IF;

				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Comprobante>');

				UPDATE EDOCTAV2TIMBRADOINGRE SET
					CadenaCFDI 		= Var_CadenaCFDI
				WHERE ClienteID = Par_ClienteID;

			END IF;

		END IF;

	END IF;

END TerminaStore$$
