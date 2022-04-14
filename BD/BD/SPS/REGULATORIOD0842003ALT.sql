-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD0842003ALT`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD0842003ALT`(
/*=======================================================================
--------- SP QUE ANADE UN REGISTRO PARA EL REGULATORIO D0842 -----------
========================================================================*/
  Par_Anio                INT(11),            -- Anio en que se reporta
  Par_Mes                 INT(11),            -- mes de generacion del reporte
  Par_NumeroIden          VARCHAR(6),         -- Numero de identificacion del pretsamista
  Par_TipoPrestamista     INT(11),            -- Tipo de prestamista
  Par_PaisEntidadExt      INT(11),            -- Pais del organismo o entidad financiera extranjera

  Par_NumeroCuenta        VARCHAR(22),        -- Numero de cuenta
  Par_NumeroContrato      VARCHAR(22),        -- Numero de contrato
  Par_ClasificaConta      VARCHAR(12),        -- Clasificacion contable del pretsmo
  Par_FechaContra         DATE,               -- Fecha de contratacion
  Par_FechaVencim         DATE,               -- Fecha de vencimiento

  Par_PeriodoPago         INT(11),            -- Perodicidad del plan de pagos.
  Par_MontoInicial        DECIMAL(21,2),      -- Mononto inicial del prestamo en su moneda Origen
  Par_MontoInicialMNX     DECIMAL(21,2),      -- Mononto inicial del prestamo
  Par_TipoTasa            INT(11),            -- Tipo de tasa sobre el patron del credito
  Par_ValorTasa           DECIMAL(16,6),      -- Valor de la tasa originalmente pactada

  Par_ValorTasaInt        DECIMAL(16,6),      -- Valor de la tasa originalmente  de intereses pactada
  Par_TasaIntRef          INT(11),            -- Tasa de interes de referencia.
  Par_DifTasaRefere       DECIMAL(16,6),      --  Diferencial sobre taza de referecia
  Par_OperaDifTasaRef     INT(11),            -- Operacion diferencial sobre tasa de referencia
  Par_FrecRevTasa         INT(11),            --  Numero de dias transcurridos entre revisiones de la tasa

  Par_TipoMoneda          INT(11),            -- Tipo de moneda segun catalogo en SITI
  Par_PorcentajeCom       DECIMAL(16,6),      -- Porcentaje de comision
  Par_ImporteComision     DECIMAL(21,2),      -- Importe de la comision
  Par_PeriodoComision     INT(11),            -- Periodicidad del pago d ela comision
  Par_TipoDispCredito     INT(11),            -- Tipo de Disposicion de credito

  Par_DestinoCredito      INT(11),            -- Clave destino del credito
  Par_ClasificaCortLarg   INT(11),            -- Clasificacion Corto Largo Plazo
  Par_SaldoIniPeriodo     DECIMAL(21,2),      -- Saldo al inicio del periodo
  Par_PagosPeriodo        DECIMAL(21,2),      -- Pagos Realizadops en el periodo
  Par_ComPagadasPeriodo   DECIMAL(21,2),      -- Comisiones pagadas en el periodo

  Par_InteresPagado       DECIMAL(21,2),      -- Intereses pagados en el periodo
  Par_InteresDevengado    DECIMAL(21,2),      -- Intereses DEvengados no pagados
  Par_SaldoCierre         DECIMAL(21,2),      -- Saldo al cierre del periodo
  Par_PorcentajeLinRev    DECIMAL(16,6),      -- Porcenteje dispuesto d elinea revolvente
  Par_FechaUltPago        DATE,               -- Fecha de ultimo pago

  Par_PagoAnticipado      INT(11),            -- Indica pago anbticipado SI/NO
  Par_MontoUltimoPago     DECIMAL(21,2),       -- monto del ultimo pago relaizado
  Par_FechaPagoSig        DATE,               -- Fecha de pago inmediato siguiente
  Par_MonImediato         DECIMAL(21,2),      -- monto pago inmediato Siguiente
  Par_TipoGarantia        INT(11),            -- Tipo de Garantia

  Par_MontoGarantia       DECIMAL(21,2),      -- Valor de la garantia
  Par_FechaValuaGaran     DATE,               -- Fecha valuacion garantia
  Par_PlazoVencin		  INT(11),			  -- Plazo en dias del vencimiento del prestamo

  Par_Salida              CHAR(1),
  INOUT Par_NumErr        INT(11),
  INOUT Par_ErrMen        VARCHAR(400),

  Par_EmpresaID           INT(11),
  Aud_Usuario             INT(11),
  Aud_FechaActual         DATETIME,
  Aud_DireccionIP         VARCHAR(15),
  Aud_ProgramaID          VARCHAR(50),
  Aud_Sucursal            INT(11),
  Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
  -- Declaracion de Variables
  DECLARE Var_Control       VARCHAR(100);
  DECLARE Var_Periodo       VARCHAR(6);
  DECLARE Var_Destino       VARCHAR(8);  -- Variable para validar que un destino de pagos existe
  DECLARE Var_Plazo         VARCHAR(8);  -- Variable para validar que un plazo existe
  DECLARE Var_TipoCred      VARCHAR(8);  -- Variable para validar que un tipo de creditos existe
  DECLARE Var_TipoGaran     VARCHAR(8);  -- Variable para validar que un tipo de garantia existe
  DECLARE Var_TipoPres      VARCHAR(8);  -- Variable para validar que tipo de prestamista existe
  DECLARE Var_Consecutivo   INT;
  DECLARE Var_Formulario    CHAR(4);
  DECLARE Var_ClaveEntidad  VARCHAR(6);

  -- Declaracion de Constantes
  DECLARE SalidaSI          CHAR(1);
  DECLARE Entero_Cero       INT;
  DECLARE Decimal_Cero      DECIMAL(14,2);
  DECLARE Cadena_Vacia      CHAR;
  DECLARE Entero_Uno        INT;
  DECLARE Fecha_Vacia		DATE;

  -- Asignacion de Constantes
  SET SalidaSI            :='S';
  SET Entero_Cero         :=0;
  SET Decimal_Cero        :=0.0;
  SET Cadena_Vacia        :='';
  SET Entero_Uno          := 1;
  SET Var_Formulario      := '0842';
  SET Fecha_Vacia		  := '1900-01-01';

  ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
					concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGULATORIOD0842003ALT');
		SET Var_Control := 'SQLEXCEPTION';
    END;

    SELECT ClaveEntidad INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

    SELECT (MAX(Consecutivo)+Entero_Uno) INTO Var_Consecutivo
      FROM  REGULATORIOD0842003 WHERE Anio = Par_Anio
        AND Mes = Par_Mes;

    SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Uno);

    IF (Par_Anio=Entero_Cero)THEN
      SET Par_NumErr  := 01;
      SET Par_ErrMen  := 'El Ano Esta Vacio.';
      SET Var_Control := 'anio';
      LEAVE ManejoErrores;
    END IF;

    IF (Par_Mes=Entero_Cero)THEN
      SET Par_NumErr  := 02;
      SET Par_ErrMen  := 'El Mes Esta Vacio.';
      SET Var_Control := 'mes';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NumeroIden, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 03;
      SET Par_ErrMen := 'El Numero de Identificacion Esta Vacio.';
      SET Var_Control := 'numeroIden';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TipoPrestamista, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 03;
      SET Par_ErrMen := 'El Tipo de Prestamista Esta Vacio.';
      SET Var_Control := 'tipoPrestamista';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PaisEntidadExt, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 04;
      SET Par_ErrMen := 'El Pais de la Entidad Finaciera Esta Vacio.';
      SET Var_Control := 'paisEntidadExtranjera';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NumeroCuenta, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 05;
      SET Par_ErrMen := 'El Numero de Cuenta Esta Vacio.';
      SET Var_Control := 'numeroCuenta';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NumeroContrato, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 06;
      SET Par_ErrMen := 'El Numero de Cuenta Esta Vacio.';
      SET Var_Control := 'numeroContrato';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClasificaConta, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 07;
      SET Par_ErrMen := 'La Clasificacion Contable Esta Vacia.';
      SET Var_Control := 'clasificaConta';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaContra, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 08;
      SET Par_ErrMen := 'La Fecha de Contratacion Esta Vacia.';
      SET Var_Control := 'fechaContra';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaVencim, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 09;
      SET Par_ErrMen := 'La Fecha de Vencimiento del Contrato Esta Vacia.';
      SET Var_Control := 'fechaVencim';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoInicial, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 011;
      SET Par_ErrMen := 'El Monto Inicial del Prestamo Esta Vacio.';
      SET Var_Control := 'montoRecibido';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoInicialMNX, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 012;
      SET Par_ErrMen := 'El Monto Inicial en Pesos del Prestamo Esta Vacio.';
      SET Var_Control := 'montoInicialPrestamo';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TipoTasa, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 013;
      SET Par_ErrMen := 'El Tipo de Tasa Esta Vacio.';
      SET Var_Control := 'tipoTasa';
      LEAVE ManejoErrores;
	ELSE
		IF(Par_TipoTasa != 101)  THEN
			IF(IFNULL(Par_FrecRevTasa, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 016;
				SET Par_ErrMen := 'La Frecuencia de Revision de la Tasa Esta Vacia.';
				SET Var_Control := 'frecRevisionTasa';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF(Par_FrecRevTasa!= Entero_Cero)THEN
				SET Par_NumErr := 016;
				SET Par_ErrMen := 'La Frecuencia de Revision de la Tasa Debe Ser Cero.';
				SET Var_Control := 'frecRevisionTasa';
				LEAVE ManejoErrores;
			END IF;
		END IF;
    END IF;

    IF(IFNULL(Par_ValorTasa, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 014;
      SET Par_ErrMen := 'El Valor de la Tasa Original Esta Vacio.';
      SET Var_Control := 'valTasaInt';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ValorTasaInt, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 014;
      SET Par_ErrMen := 'El Valor del Interes Aplicable a la Tasa Esta Vacio.';
      SET Var_Control := 'valTasaInt';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TasaIntRef, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 015;
      SET Par_ErrMen := 'La Tasa de Referencia Esta Vacia.';
      SET Var_Control := 'tasaIntReferencia';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_OperaDifTasaRef, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 018;
      SET Par_ErrMen := 'La Operacion Direfencial Sobre Tasa de Referencia Esta Vacia.';
      SET Var_Control := 'operaDifTasaRefe';
      LEAVE ManejoErrores;
    END IF;

    IF(Par_DifTasaRefere = Entero_Cero) THEN
		IF(Par_OperaDifTasaRef != 101)THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'La Operacion Direfencial Sobre Tasa de Referencia Es Incorrecta.';
			SET Var_Control := 'frecRevisionTasa';
			LEAVE ManejoErrores;
        END IF;
	END IF;

    IF(IFNULL(Par_TipoMoneda, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 019;
      SET Par_ErrMen := 'El Tipo de Moneda  Esta Vacio.';
      SET Var_Control := 'tipoMoneda';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PorcentajeCom, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 020;
      SET Par_ErrMen := 'El Porcentaje de la Comision Esta Vacio.';
      SET Var_Control := 'porcentajeComision';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ImporteComision, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 021;
      SET Par_ErrMen := 'El Importe de la Comision Esta Vacio.';
      SET Var_Control := 'importeComision';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TipoDispCredito, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 023;
      SET Par_ErrMen := 'El Tipo de Disposicion de Credito Esta Vacio.';
      SET Var_Control := 'tipoDisposicionCredito';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_DestinoCredito, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 024;
      SET Par_ErrMen := 'El Destino del Credito Esta Vacio.';
      SET Var_Control := 'destino';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ClasificaCortLarg, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 025;
      SET Par_ErrMen := 'La Clasificacion del Plazo Esta Vacia.';
      SET Var_Control := 'clasificaCortLarg';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SaldoIniPeriodo, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 026;
      SET Par_ErrMen := 'El Saldo Inicial del Periodo Esta Vacio.';
      SET Var_Control := 'saldoInicio';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PagosPeriodo, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 027;
      SET Par_ErrMen := 'El Monto de Pagos Realizados Esta Vacio.';
      SET Var_Control := 'pagosRealizados';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ComPagadasPeriodo, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 028;
      SET Par_ErrMen := 'El Monto de Comisiones Pagadas Esta Vacio.';
      SET Var_Control := 'comisionPagada';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_InteresPagado, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 029;
      SET Par_ErrMen := 'El Monto de Intereses Pagados Esta Vacio.';
      SET Var_Control := 'interesesPagados';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_InteresDevengado, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 030;
      SET Par_ErrMen := 'El Monto de Intereses Devengados Esta Vacio.';
      SET Var_Control := 'interesesDevengados';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SaldoCierre, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 031;
      SET Par_ErrMen := 'El Saldo al Cierre de Periodo Esta Vacio.';
      SET Var_Control := 'saldoCierre';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PorcentajeLinRev, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 032;
      SET Par_ErrMen := 'El Porcentaje de la Linea Revolvente Esta Vacia.';
      SET Var_Control := 'porcentajeLinRevolvente';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaUltPago, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 033;
      SET Par_ErrMen := 'La Fecha de Ultimo Pago Esta Vacia.';
      SET Var_Control := 'fechaUltPago';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_PagoAnticipado, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 034;
      SET Par_ErrMen := 'El Pago Anticipado Esta Vacio.';
      SET Var_Control := 'pagoAnticipado';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MontoUltimoPago, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 035;
      SET Par_ErrMen := 'El Monto del Ultimo Pago Esta Vacio.';
      SET Var_Control := 'montoUltimoPago';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaPagoSig, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr := 036;
      SET Par_ErrMen := 'La Fecha del Siguiente Pago Esta Vacia.';
      SET Var_Control := 'fechaPagoInmediato';
      LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MonImediato, Decimal_Cero)) = Decimal_Cero THEN
      SET Par_NumErr := 037;
      SET Par_ErrMen := 'El Monto del Pago Siguiente Esta Vacio.';
      SET Var_Control := 'montoPagoInmediato';
      LEAVE ManejoErrores;
    END IF;

     IF(Par_TipoGarantia != Entero_Cero )THEN

       IF(IFNULL(Par_MontoGarantia, Decimal_Cero)) = Decimal_Cero THEN
		  SET Par_NumErr := 039;
		  SET Par_ErrMen := 'El Monto de la Garantia Esta Vacio.';
		  SET Var_Control := 'montoGarantia';
		  LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaValuaGaran = Fecha_Vacia )THEN
		  SET Par_NumErr := 040;
		  SET Par_ErrMen := 'La Fecha de Valuacion de la Garantia Esta Vacia.';
		  SET Var_Control := 'fechaValuacionGaran';
		  LEAVE ManejoErrores;
		END IF;
	ELSE
		SET Par_MontoGarantia   := Decimal_Cero;
        SET Par_FechaValuaGaran	:= Fecha_Vacia;

    END IF;

    IF(IFNULL(Par_PlazoVencin, Entero_Cero)) = Entero_Cero THEN
      SET Par_NumErr := 041;
      SET Par_ErrMen := 'El Plazo de Vencimiento Esta Vacio.';
      SET Var_Control := 'plazo';
      LEAVE ManejoErrores;
    END IF;


    IF(Par_Mes < 10) THEN
      SET Var_Periodo    :=  CONCAT(Par_Anio,Entero_Cero,Par_Mes);
    ELSE
      SET Var_Periodo    :=  CONCAT(Par_Anio,Par_Mes);
    END IF;


  INSERT INTO REGULATORIOD0842003(
    Consecutivo,        Anio,               Mes,                Periodo,            ClaveEntidad,
    Formulario,         NumeroIden,         TipoPrestamista,    PaisEntidadExt,     NumeroCuenta,
    NumeroContrato,     ClasificaConta,     FechaContra,        FechaVencim,        PeriodoPago,
    MontoInicial,       MontoInicialMNX,    TipoTasa,           ValorTasa,          ValorTasaInt,
    TasaIntReferencia,  DifTasaReferencia,  OperaDifTasaRefe,   FrecRevTasa,        TipoMoneda,
    PorcentajeComision, ImporteComision,    PeriodoComision,    TipoDispCredito,    DestinoCredito,
    ClasificaCortLarg,  SaldoIniPeriodo,    PagosPeriodo,       ComPagadasPeriodo,  InteresPagado,
    InteresDevengados,  SaldoCierre,        PorcentajeLinRev,   FechaUltPago,       PagoAnticipado,
    MontoUltimoPago,    FechaPagoSig,       MontoPagImediato,   TipoGarantia,       MontoGarantia,
    FechaValuaGaran,    PlazoVencimiento,	EmpresaID,          Usuario,            FechaActual,
    DireccionIP,  		ProgramaID,         Sucursal,           NumTransaccion)

  VALUES(
    Var_Consecutivo,        Par_Anio,             Par_Mes,                Var_Periodo,            Var_ClaveEntidad,
    Var_Formulario,         Par_NumeroIden,       Par_TipoPrestamista,    Par_PaisEntidadExt,     Par_NumeroCuenta,
    Par_NumeroContrato,     Par_ClasificaConta,   Par_FechaContra,        Par_FechaVencim,        Par_PeriodoPago,
    Par_MontoInicial,       Par_MontoInicialMNX,  Par_TipoTasa,           Par_ValorTasa,          Par_ValorTasaInt,
    Par_TasaIntRef,         Par_DifTasaRefere,    Par_OperaDifTasaRef,    Par_FrecRevTasa,        Par_TipoMoneda,
    Par_PorcentajeCom,      Par_ImporteComision,  Par_PeriodoComision,    Par_TipoDispCredito,    Par_DestinoCredito,
    Par_ClasificaCortLarg,  Par_SaldoIniPeriodo,  Par_PagosPeriodo,       Par_ComPagadasPeriodo,  Par_InteresPagado,
    Par_InteresDevengado,   Par_SaldoCierre,      Par_PorcentajeLinRev,   Par_FechaUltPago,       Par_PagoAnticipado,
    Par_MontoUltimoPago,    Par_FechaPagoSig,     Par_MonImediato,        Par_TipoGarantia,       Par_MontoGarantia,
    Par_FechaValuaGaran,    Par_PlazoVencin,	  Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
    Aud_DireccionIP, 		Aud_ProgramaID,       Aud_Sucursal,           Aud_NumTransaccion);

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := CONCAT('Registro Agregado Correctamente: ',Var_Consecutivo);
    SET Var_Control := 'identificadorID';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
 END IF;

END TerminaStore$$