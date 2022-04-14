-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATIMBRADO024CFDI
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATIMBRADO024CFDI`;
DELIMITER $$


CREATE PROCEDURE `EDOCTATIMBRADO024CFDI`(
-- SP para el timbrado del Estado de Cuenta
	Par_RFCEmisor 				VARCHAR(25),				-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),				-- Razon Social del Emisor
	Par_ExpCalle 				VARCHAR(100),				-- Calle de la Sucursal de Expedicion
	Par_ExpNumero 				VARCHAR(10),				-- Numero Sucursal de Expedicion
	Par_ExpColonia 				VARCHAR(50),				-- Colonia Sucursal Expedicion

	Par_ExpMunicipio			VARCHAR(50),				-- Municipio Sucursal Expedicion
	Par_ExpEstado 				VARCHAR(50),				-- Estado Sucursal Expedicion
	Par_ExpCP 					VARCHAR(10),				-- Codigo Postal Sucursal Expedicion
	Par_Tasa 					DECIMAL(14,2),				-- Valor Tasa
	Par_NumIntEmisor 			VARCHAR(20),				-- Numero Interior Emisor

    Par_NumExtEmisor 			VARCHAR(20),				-- Numero Exterior Emisor
	Par_NumReg 					INT(11),					-- Numero de Registro
	Par_CPEmisor 				VARCHAR(12),				-- Codigo Postal Emisor
	Par_TimbraEdoCta			CHAR(1),					-- Timbrado de Estado de Cuenta: SI NO
	Par_EstadoEmisor			VARCHAR(50),				-- Estado Emisor

    Par_MuniEmisor				VARCHAR(50),				-- Municipio Emisor
	Par_LocalEmisor				VARCHAR(100),				-- Localidad Emisor
	Par_ColEmisor				VARCHAR(100),				-- Colonia Emisor
	Par_CalleEmisor				VARCHAR(100),				-- Calle Emisor
	Par_GeneraCFDI				CHAR(1),					-- Genera CFDI: SI NO

    Par_AnioMes					CHAR(10),					-- Anio y mes que se genera el Estado de Cuenta
	Par_SucursalID 				INT(11),					-- Sucursal del Cliente
	Par_NombreSucursalCte 		VARCHAR(150),				-- Nombre del Sucursal del Cliente
	Par_ClienteID 				INT(11),					-- Numero del Cliente
	Par_NombreComple 			VARCHAR(250),				-- Nombre Completo del Cliente

    Par_TipPer 					CHAR(2),					-- Tipo de Persona
	Par_TipoPersona 			VARCHAR(50),				-- Descripcion Tipo de Persona
	Par_Calle 					VARCHAR(250),				-- Calle del Cliente
	Par_NumInt					VARCHAR(10),				-- Numero Interior Domicilio del Cliente
	Par_NumExt					VARCHAR(10),				-- Numero Exterior Domicilio del Cliente

    Par_Colonia 				VARCHAR(200),				-- Colonia del Domicilio del Cliente
	Par_Estado 					VARCHAR(50),				-- Estado del Cliente
	Par_CodigoPostal 			VARCHAR(10),				-- Codigo Postal del Cliente
	Par_RFC 					VARCHAR(20),				-- RFC del Cliente
	Par_ISR 					DECIMAL(12,2),				-- ISR

    Par_FechaGeneracion 		VARCHAR(15),				-- Fecha en que se genera Informacion del Cliente
	Par_RegHacienda 			CHAR(1),					-- Registro en Hacienda: SI NO
	Par_ComisionAhorro 			DECIMAL(14,2),				-- Comision por Ahorro
	Par_ComisionCredito 		DECIMAL(14,2),				-- Comision de Credito
	Par_NombreInstitucion		VARCHAR(100),				-- Nombre Institucion

    Par_DireccionInstitucion	VARCHAR(150),				-- Direccion Institucion
	Par_MunicipioDelegacion		VARCHAR(50)					-- Municipio y Delegacion
	)

TerminaStore:BEGIN
		-- Declaracion de Variables
	DECLARE Var_TotalCredito	DECIMAL(14,2);
	DECLARE Var_TotalAhorro 	DECIMAL(14,2);
	DECLARE Var_Subtotal 		DECIMAL(14,2);
	DECLARE Var_TotalInver		DECIMAL(14,2);
    DECLARE Var_CadenaCFDI 		VARCHAR(10000);

    DECLARE Var_TotalIVA 		DECIMAL(14,2);
	DECLARE Var_Total 			DECIMAL(14,2);
	DECLARE Var_Contador 		INT(11);
	DECLARE Var_IntCredito 		DECIMAL(14,2);
    DECLARE Var_ComMoratorio 	DECIMAL(14,2);

    DECLARE Var_ComFaltaPago 	DECIMAL(14,2);
	DECLARE Var_OtrasCom 		DECIMAL(14,2);
	DECLARE Var_DirFiscal 		VARCHAR(250);
	DECLARE Var_LongRFC			INT(11);
	DECLARE Var_MontoMinimo		DECIMAL(14,2);

    DECLARE Var_TipoInstitID	INT(11);
	DECLARE Var_IntCreditoGen 	DECIMAL(14,2);
	DECLARE Var_ComMoratorioGen DECIMAL(14,2);
    DECLARE Var_ComFaltaPagoGen DECIMAL(14,2);
	DECLARE Var_OtrasComGen 	DECIMAL(14,2);

    DECLARE Var_TotalIVAGen 	DECIMAL(14,2);
	DECLARE Var_SubtotalGen 	DECIMAL(14,2);
    DECLARE Var_Comision		DECIMAL(14,2);
	DECLARE Var_IvaComision		DECIMAL(14,2);
    DECLARE Var_TotalISR        DECIMAL(14,2);

    DECLARE Var_TotalIVACom	    DECIMAL(14,2);
    DECLARE Var_ValorTasa		DECIMAL(12,6);
	DECLARE Var_ValorTasaISR	DECIMAL(12,6);
	DECLARE Var_ImporteIntCredito 		DECIMAL(12,2);
	DECLARE Var_ImporteComMoratorio 	DECIMAL(12,2);

    DECLARE Var_ImporteComFaltaPago		DECIMAL(12,2);
	DECLARE Var_ImporteOtrasCom 		DECIMAL(12,2);
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
	DECLARE Var_FecIniMes				DATE;
	DECLARE Var_FecFinMes				DATE;
	DECLARE Var_AnioMesStr				VARCHAR(10);		-- Anio y Mes
	DECLARE Var_Anio					INT(11);			-- Anio
	DECLARE Var_MesIni					INT(11);			-- Mes Inicio
	DECLARE Var_MesFin					INT(11);			-- Mes Fin
	DECLARE Var_MesesExcluir			VARCHAR(150);		-- Meses a excluir
	DECLARE Var_ProdCredito				INT(11);			-- Producto de credito

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
    DECLARE TipoInstSOFOM       INT(11);

    DECLARE ClasMovComision     INT(11);
	DECLARE ClasMovIVACom       INT(11);
	DECLARE ClasMovISR          INT(11);
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
	DECLARE DiaUnoDelMes			CHAR(2);			-- Dia Primero del mes
	DECLARE Entero_Seis				INT(11);			-- Entero seis

	-- Asignacion de Constantes
	SET Entero_Cero 		:= 0;						-- Entero cero
	SET Decimal_Cero 		:= 0.00;					-- Decimal cero
	SET Entero_Uno 			:= 1;						-- Entero uno
	SET Cadena_Vacia 		:= '';						-- Cadena Vacia
    SET PersonaFisica		:= 'F';						-- Tipo de Persona: Fisica

    SET Long_PerFisica		:= 13;						-- Longitud RFC Persona Fisica: 13
	SET PersonaMoral		:= 'M';						-- Tipo de Persona: Moral
	SET Long_PerMoral		:= 12;						-- Longitud RFC Persona Moral: 12
	SET GeneraSI 			:= 'S';						-- Genera CFDI con RFC Generico: SI
	SET RFCGenerico 		:= 'XAXX010101000'; 		-- RFC Generico

    SET Var_Continuar		:= Entero_Cero; 			-- Se valida si se continua con el timbrado CFDI
	SET NoAltaHacienda 		:= 'N';						-- Alta en hacienda: NO
	SET NaturalezaCargo		:= 'C';						-- Naturaleza Movimiento: Cargo
    SET NaturalezaAbono 	:= 'A';						-- Naturaleza Movimiento: Abono
	SET TipoInstSOFOM       := 4;						-- Tipo Institucion: 4 (SOFOM) TIPOSINSTITUCION

    SET ClasMovComision 	:= 2;						-- Clasificacion Movimiento: Comision
	SET ClasMovIVACom   	:= 3;						-- Clasificacion Movimiento: IVA Comision
    SET ClasMovISR      	:= 4;						-- Clasificacion Movimiento: ISR
    SET FormaPagoEfectivo 	:= '01'; 					-- Forma Pago: Efectivo
	SET ComprobanteIngreso 	:= 'I';						-- Tipo Comprobante: Ingreso

    SET MetodoPagoPUE		:= 'PUE';					-- Metodo Pago: Pago en una sola exhibicion
	SET RegFiscalPerMora	:= '601';					-- Regimen Fiscal: General de Ley Personas Morales
	SET PorDefininir		:= 'P01'; 					-- Uso CFDI: Por Definir
	SET Actividad			:= 'ACT';					-- Clave Unidad: Actividad
	SET ImpuestoIVA			:= '002';					-- Impuesto: IVA

	SET ClaveProdServCat	:= '84121500';				-- Clave Producto Servicio: Instituciones bancarias
	SET FactorTasa			:= 'Tasa';					-- Tipo Factor Tasa
	SET ImpuestoISR			:= '001';					-- Impuesto: ISR
    SET ComprobanteEgreso 	:= 'E';						-- Tipo Comprobante: Egreso
	SET DiaUnoDelMes		:= '01';					-- Dia Primero del mes
	SET Entero_Seis			:= 6;						-- Asignacion de Entero seis

		-- Asignacion de variables
	SET Var_Continuar 	:= Entero_Cero;
	SET Var_Contador 	:= Var_Contador + 1;
	SET Var_LongRFC	 	:= (SELECT LENGTH(Par_RFC));
    SET Var_ValorTasa 	:= (Par_Tasa /100);

	SET Var_ValorTasaISR 	:= (SELECT TasaISR FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
	SET Var_ValorTasaISR 	:= (IFNULL(Var_ValorTasaISR,Entero_Cero) /100);

	SET Var_ImporteIntCredito 		:= Decimal_Cero;
	SET Var_ImporteComMoratorio 	:= Decimal_Cero;
	SET Var_ImporteComFaltaPago		:= Decimal_Cero;
	SET Var_ImporteOtrasCom 		:= Decimal_Cero;

	-- Asignacion de Variables
	-- Se obtiene el año y mes que marcan el inicio del semestre
	SET Var_AnioMesStr := CAST(Par_AnioMes AS CHAR);

	IF (CHAR_LENGTH(Var_AnioMesStr) > Entero_Seis) THEN
		SET Var_FecIniMes := DATE(CONCAT(LEFT(Var_AnioMesStr, Entero_Seis),DiaUnoDelMes));
		SET Var_Anio := YEAR(Var_FecIniMes);
		SET Var_MesIni := MONTH(Var_FecIniMes);
		SET Var_FecFinMes := DATE_ADD(Var_FecIniMes,INTERVAL Entero_Seis MONTH);
		SET Var_FecFinMes := DATE_ADD(Var_FecFinMes,INTERVAL -Entero_Uno DAY);
		SET Var_MesFin := MONTH(Var_FecFinMes);
	ELSE
		-- SET Var_Continuar := Entero_Uno;
        SET Var_Continuar := 0;
	END IF;
        -- Se obtiene el valor del IVA de Interes, IVA Moratorios e IVA del Cliente para Creditos

    SELECT 	ValorIVAInt, 		ValorIVAMora,		ValorIVAAccesorios
    INTO 	Var_ValorIVAInt, 	Var_ValorIVAMora,	Var_ValorIVAAccesorios
    FROM EDOCTARESUMCREDITOS
    WHERE ClienteID = Par_ClienteID
    LIMIT 1;

        -- Se obtiene el valor del IVA del Cliente para el IVA de las Comisiones para Captacion
	SELECT CASE WHEN Cli.PagaIVA = 'S' THEN
		IFNULL(Suc.IVA, Decimal_Cero) ELSE Decimal_Cero END
        AS IVA,	ProductoCredID
	INTO Var_ValorIVASucursal,	Var_ProdCredito
    FROM EDOCTADATOSCTE Edo,
		 CLIENTES Cli,
         SUCURSALES Suc
    WHERE Edo.ClienteID = Cli.ClienteID
    AND Cli.SucursalOrigen = Suc.SucursalID
    AND Edo.ClienteID = Par_ClienteID
    LIMIT 1;
	
    -- OBTENEMOS LOS MESOS QUE YA FUERON TIMBRADOS Y LOS EXCLUIMOS
	SET Var_MesesExcluir := FNEDOCTAMESESEXCLUYE(Var_ProdCredito, Var_Anio, Var_MesIni, Var_MesFin);

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
	IF ((Par_RegHacienda = NoAltaHacienda) AND (Var_Continuar = Entero_Cero)) THEN
		-- Se genera CFDI con RFC Generico

		IF ( Par_GeneraCFDI = GeneraSI ) THEN
			SET Par_RFC 	:= RFCGenerico;
		ELSE
			SET Var_Continuar := Entero_Uno;
		END IF;
	END IF;

	IF (Var_Continuar = Entero_Cero) THEN

		IF (Var_TipoInstitID = TipoInstSOFOM) THEN
			-- Se obtiene los movimientos de las comisiones de las cuentas
			SELECT CONVERT(IFNULL(SUM(Retiro), Decimal_Cero),CHAR) INTO Var_TotalAhorro
                FROM EDOCTADETACTA
                WHERE ClienteID = Par_ClienteID
                 AND TipoMovAhoID IN (202, 203, 204, 205, 206, 207, 208, 209, 21, 22,
                                      210, 211, 212, 213, 214,215,216,217,218,219,
                                      --  220, 221,   SE COMENTAN DEBIDO A QUE EL ISR (220) SE DEBE TIMBRAR POR APARTE Y EL IMPUESTO IDE (221) YA NO SE COBRA
                                      225, 226, 402, 403,81,82,83,84,86,88)
				AND find_in_set(MONTH(Fecha), Var_MesesExcluir) = 0 ;

			-- Se obtiene el monto de Interes,Moratorios, Comisiones e IVAS pagados por el cliente
			SELECT  SUM(Interes), 	SUM(Moratorios), 	SUM(ComFaltaPago), 	SUM(OtrasCom), 	SUM(IVAS),
					(SUM(Interes) + SUM(Moratorios) + SUM(ComFaltaPago) + SUM(OtrasCom))
			INTO 	Var_IntCredito, Var_ComMoratorio, 	Var_ComFaltaPago, 	Var_OtrasCom, 	Var_TotalIVA,
					Var_SubTotal
			FROM EDOCTARESUMCREDITOS
			WHERE ClienteID = Par_ClienteID
			AND Orden = 2;

			SET Var_TotalIVACom 	:= IFNULL(Var_TotalIVACom, Decimal_Cero);
			SET Var_ComMoratorio 	:= IFNULL(Var_ComMoratorio, Decimal_Cero);
			SET Var_ComFaltaPago 	:= IFNULL(Var_ComFaltaPago, Decimal_Cero);
			SET Var_OtrasCom 		:= IFNULL(Var_OtrasCom, Decimal_Cero);
			SET Var_TotalIVA 		:= IFNULL(Var_TotalIVA, Decimal_Cero);
			SET Var_SubTotal 		:= IFNULL(Var_SubTotal, Decimal_Cero);

		ELSE
			-- Se obtiene el monto de Interes,Moratorios, Comisiones e IVAS pagados por el cliente
			SELECT 	SUM(Interes), 	SUM(Moratorios), 	SUM(ComFaltaPago), 	SUM(OtrasCom), 		SUM(IVAS),
					(SUM(Interes) + SUM(Moratorios) + 	SUM(ComFaltaPago) + SUM(OtrasCom))
			INTO 	Var_IntCredito, Var_ComMoratorio, 	Var_ComFaltaPago, 	Var_OtrasCom, 		Var_TotalIVA,
					Var_SubTotal
			FROM EDOCTARESUMCREDITOS
			WHERE ClienteID = Par_ClienteID AND Orden = 2;

			SET Var_TotalIVACom 	:= IFNULL(Var_TotalIVACom, Decimal_Cero);
            SET Var_ComMoratorio 	:= IFNULL(Var_ComMoratorio, Decimal_Cero);
            SET Var_ComFaltaPago 	:= IFNULL(Var_ComFaltaPago, Decimal_Cero);
            SET Var_OtrasCom 		:= IFNULL(Var_OtrasCom, Decimal_Cero);
            SET Var_TotalIVA 		:= IFNULL(Var_TotalIVA, Decimal_Cero);
            SET Var_SubTotal 		:= IFNULL(Var_SubTotal, Decimal_Cero);

             -- Se obtiene el monto de la comision realizados en el periodo
			SELECT 	SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)  -
					SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END)  INTO Var_Comision
			  FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
			 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
			   AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
			   AND Cue.ClienteID = Par_ClienteID
			   AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
			   AND Tip.ClasificacionMov = ClasMovComision
			   AND Mov.DescripcionMov LIKE 'COMISION%'
               AND find_in_set(MONTH(Mov.Fecha), Var_MesesExcluir) = 0;

			SET Var_Comision 	:= IFNULL(Var_Comision, Decimal_Cero);
			SET Var_OtrasCom   	:= Var_OtrasCom + Var_Comision;

			-- Se obtiene el monto del iva de la comision realizados en el periodo
			SELECT SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)  -
				  SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END)
				 INTO Var_IvaComision
			  FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
			 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
			   AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
			   AND Cue.ClienteID = Par_ClienteID
			   AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
			   AND Tip.ClasificacionMov = ClasMovIVACom
			   AND (Mov.DescripcionMov LIKE 'IVA COMISION%' OR Mov.DescripcionMov LIKE 'Iva Comision%')
               AND find_in_set(MONTH(Mov.Fecha), Var_MesesExcluir) = 0;

			SET Var_IvaComision := IFNULL(Var_IvaComision, Decimal_Cero);

        END IF;

        -- Se obtiene el subtotal total de los creditos, cuentas e inversiones
       IF (Var_TipoInstitID = TipoInstSOFOM) THEN
			SET Var_Subtotal :=	IFNULL(Var_TotalAhorro, Decimal_Cero) 		-- Comisiones Cuentas
							+ IFNULL(Var_Subtotal, Decimal_Cero);			-- Intereses de Creditos
		ELSE
			SET Var_Subtotal :=	IFNULL(Var_Subtotal, Decimal_Cero)   		-- Intereses y Comisiones de Creditos
							+ IFNULL(Var_Comision, Decimal_Cero);			-- Comisiones Cuentas
        END IF;


		SET Var_Subtotal		:= IFNULL(Var_Subtotal, Decimal_Cero);
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
		SET Par_MunicipioDelegacion	:= IFNULL(Par_MunicipioDelegacion, Cadena_Vacia);
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

		IF (Var_TipoInstitID = TipoInstSOFOM) THEN

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
            SET Var_TotalIVA	:= Var_ImporteIntCredito + Var_ImporteComMoratorio + Var_ImporteComFaltaPago + Var_ImporteOtrasCom;

           -- Se actualiza el valor Total
			SET Var_Total := Var_Subtotal + Var_TotalIVA;

		ELSE

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

			SET Var_TotalIVACom := Var_ImporteIntCredito + Var_ImporteComMoratorio + Var_ImporteComFaltaPago + Var_ImporteOtrasCom;

             -- Actualizar el Total
			SET Var_Total := Var_Subtotal + Var_TotalIVACom;

		END IF;

	IF (Var_TipoInstitID = TipoInstSOFOM) THEN
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
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="OTRAS COMISIONES DE CREDITO" ');
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

            IF (IFNULL(Var_TotalAhorro, Decimal_Cero) > Decimal_Cero) THEN
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Concepto ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Cantidad="1" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Descripcion="OTRAS COMISIONES" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'ValorUnitario="', Var_TotalAhorro, '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', Var_TotalAhorro,'">');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Concepto>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
			END IF;

            SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Conceptos>\n');

            IF(Var_TotalIVA > Decimal_Cero) THEN
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Impuestos ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TotalImpuestosTrasladados="', Var_TotalIVA, '">\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslados>\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '<cfdi:Traslado ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Impuesto="',CAST(ImpuestoIVA AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'TasaOCuota="',Var_ValorTasa, '" ');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, 'Importe="', CAST(Var_TotalIVA AS CHAR), '"/>\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Traslados>\n');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Impuestos>');
				SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '\n');
			END IF;

            SET Var_CadenaCFDI = CONCAT(Var_CadenaCFDI, '</cfdi:Comprobante>');

			UPDATE EDOCTADATOSCTE SET
				ComisionAhorro 	= Var_TotalAhorro,
				ComisionCredito = Var_TotalIVA,
				CadenaCFDI 		= Var_CadenaCFDI
			WHERE ClienteID 	= Par_ClienteID;
		END IF;
	 END IF;

     IF (Var_TipoInstitID != TipoInstSOFOM) THEN

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

		-- Se obtiene el Monto del ISR de las Cuentas e Inversiones periodo
		SELECT SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Decimal_Cero END) INTO Var_TotalISR
		  FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
		 WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		   AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		   AND Cue.ClienteID = Par_ClienteID
		   AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
		   AND Tip.ClasificacionMov = ClasMovISR;

         SET Var_TotalISR 	:= IFNULL(Var_TotalISR, Decimal_Cero);

		SELECT SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) INTO Var_Intereses
		 FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip
		WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		 AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		 AND Cue.ClienteID = Par_ClienteID
		 AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
		AND Mov.TipoMovAhoID IN(62,63,200,201);

        SET Var_Intereses 		:= IFNULL(Var_Intereses, Decimal_Cero);

		SET Var_BaseISR			:= ROUND((Var_TotalISR/Var_ValorTasaISR),2);

           --  Subtotal Tipo Timbrado: Egresos
		SET Var_SubtotalRet 	:= Var_BaseISR;

		SET Var_TotalRet 		:= Var_SubtotalRet - Var_TotalISR;


		IF(Var_TotalRet > Decimal_Cero)THEN
			SET Var_CadenaCFDIRet = CONCAT('<?xml version="1.0" encoding="UTF-8"?>', '\n');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Version="3.3" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Fecha="', CURDATE(), 'T', CURTIME(), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Sello="" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'NoCertificado="" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Certificado="" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'LugarExpedicion="',CAST(Par_ExpCP AS CHAR),'" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'TipoDeComprobante="', CAST(ComprobanteEgreso AS CHAR), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'FormaPago="', CAST(FormaPagoEfectivo AS CHAR), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'CondicionesDePago="CONTADO" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'MetodoPago="', CAST(MetodoPagoPUE AS CHAR), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Moneda="MXN" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'SubTotal="', CAST(Var_SubtotalRet AS CHAR), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Total="', CAST(Var_TotalRet AS CHAR), '">');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '\n');

			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Emisor ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Rfc="',CAST(Par_RFCEmisor AS CHAR),'" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Nombre="',CAST(Par_RazonSocial AS CHAR),'" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'RegimenFiscal="', CAST(RegFiscalPerMora AS CHAR), '"/>');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '\n');

			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Receptor ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Rfc="',CAST(Par_RFC AS CHAR),'" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Nombre="',CAST(Par_NombreComple AS CHAR),'" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'UsoCFDI="', CAST(PorDefininir AS CHAR), '"/>');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '\n');

			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Conceptos>\n');
               -- Intereses Cuentas e Inversiones
			IF (IFNULL(Var_BaseISR, Decimal_Cero) > Decimal_Cero) THEN
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Concepto ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'ClaveProdServ="', CAST(ClaveProdServCat AS CHAR), '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Cantidad="1" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'ClaveUnidad="', CAST(Actividad AS CHAR), '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Descripcion="INTERESES PAGADOS" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'ValorUnitario="', Var_BaseISR, '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Importe="', Var_BaseISR, '">');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '\n');

				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Impuestos>\n');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Retenciones>\n');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Retencion ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Base="', Var_BaseISR, '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Impuesto="',CAST(ImpuestoISR AS CHAR), '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'TipoFactor="',CAST(FactorTasa AS CHAR), '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'TasaOCuota="',Var_ValorTasaISR, '" ');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Importe="', CAST(Var_TotalISR AS CHAR),'"/>\n');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Retenciones>\n');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Impuestos>\n');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Concepto>');
				SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '\n');

			END IF;

			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Conceptos>\n');

			-- Se obtiene el Valor de los Impuestos Retenidos
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Impuestos ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'TotalImpuestosRetenidos="',Var_TotalISR, '">\n');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Retenciones>\n');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '<cfdi:Retencion ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Impuesto="',CAST(ImpuestoISR AS CHAR), '" ');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, 'Importe="', CAST(Var_TotalISR AS CHAR),'"/>\n');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Retenciones>\n');
			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Impuestos>\n');

			SET Var_CadenaCFDIRet = CONCAT(Var_CadenaCFDIRet, '</cfdi:Comprobante>');

            UPDATE EDOCTADATOSCTE SET
				Intereses		= Var_Intereses,		-- Intereses Pagados
				ISR 			= Var_TotalISR,			-- Intereses Retenidos
				CadenaCFDIRet  	= Var_CadenaCFDIRet  	-- Cadena CFDI Tipo Timbrado Ingreso
			WHERE ClienteID = Par_ClienteID;

		END IF;
	 END IF;
  END IF;

END TerminaStore$$