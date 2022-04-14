-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUENTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCUENTAALT`;
DELIMITER $$

CREATE PROCEDURE `TIPOSCUENTAALT`(
	Par_MonedaID			INT(11),
	Par_Descripcion 		VARCHAR(30),
	Par_Abreviacion 		VARCHAR(10),
	Par_GeneraInteres		CHAR(1),
	Par_TipoInteres			CHAR(1),

	Par_EsServicio 			CHAR(1),
	Par_EsBancaria			CHAR(1),
	Par_EsConcentra			CHAR(1),
	Par_MinimoApertura 		DECIMAL(14,2),
	Par_ComApertura	 		DECIMAL(14,2),

	Par_ComManejoCta 		DECIMAL(14,2),
	Par_ComAniveRsario 		DECIMAL(14,2),
	Par_CobraBanEle 		CHAR(1),
	Par_ParticipaSpei       CHAR(1),
	Par_CobraSpei 			CHAR(1),

	Par_ComSpeiPerFis       DECIMAL(18,2),
	Par_ComSpeiPerMor       DECIMAL(18,2),
	Par_ComFalsoCobro 		DECIMAL(14,2),
	Par_ExPrimDispSeg		CHAR(1),
	Par_ComDispSeg			DECIMAL(14,2),

	Par_SaldoMinR			DECIMAL(14,2),
	Par_TipoPersona			CHAR(15),
	Par_EsBloqueoAuto		CHAR(1),
	Par_ClasificacionConta	CHAR(1),
	Par_RelacionadoCuenta	CHAR(1),

	Par_RegistroFirmas		CHAR(1),
	Par_HuellasFirmante		CHAR(1),
	Par_ConCuenta			CHAR(1),
	Par_GatInformativo		DECIMAL(12,2),
	Par_NivelID				INT(11),

	Par_DireccionOficial	CHAR(1),
    Par_IdenOficial         CHAR(1),
    Par_CheckListExpFisico	CHAR(1),
    Par_LimAbonosMensuales	CHAR(1),
    Par_AbonosMenHasta	    DECIMAL(14,2),

    Par_PerAboAdi           CHAR(1),
    Par_AboAdiHas           DECIMAL(14,2),
    Par_LimSaldoCuenta	    CHAR(1),
    Par_SaldoHasta	        DECIMAL(14,2),
	Par_NumRegistroRECA	    VARCHAR(100),

    Par_FechaInscripcion	DATE,
    Par_NombreComercial	    VARCHAR(100),
    Par_ClaveCNBV			VARCHAR(10),
    Par_ClaveCNBVAmpCred	VARCHAR(10),
	Par_EnvioSMSRetiro		CHAR(1),			-- Indica si se realizan envios de SMS al realizar un retiro. S - Si, N - No

    Par_MontoMinSMSRetiro	DECIMAL(14,2),		-- Monto minimo de retiros para realizar envios de SMS
    Par_EstadoCivil			CHAR(1),			-- Indica si se valida el Estado Civil S:Si / N:No
    Par_NotificacionSms		CHAR(1),			-- Indica si se realizan envios de SMS al activar cuenta
    Par_PlantillaID			INT(11),			-- Indica la plantilla a utilizar para el envio de SMS
	Par_ComisionSalProm		DECIMAL(16,2),		-- INDICA SALDO PROMEDIO

	Par_SaldoPromMinReq		DECIMAL(16,2),		-- INDICA SALDO PROMEDIO REQUERIDO
	Par_ExentaCobroSalPromOtros	CHAR(1),		-- INSIDCA SI EXCEBTA SALDO PROMEDIO DE OTROS PRODUCTOS
	Par_DepositoActiva		CHAR(1),			-- Indica si el tipo de cuenta requiere un deposito para activarla S= si, N= no
    Par_MontoDepositoActiva	DECIMAL(18,2),		-- Si requiere un deposito para activar cuenta, indica el monto del deposito

    Par_Salida				CHAR(1),
    INOUT	Par_NumErr		INT,
    INOUT	Par_ErrMen		VARCHAR(350),

	Aud_EmpresaID			INT,
    Aud_Usuario				INT,
    Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
			)
TerminaStore: BEGIN

	/* declaracion de constantes */
	DECLARE		NumTipoCuentaID 	INT;
	DECLARE		Cadena_Vacia		CHAR(1);
	DECLARE		Fecha_Vacia			DATE;
	DECLARE		Entero_Cero			INT;
	DECLARE		Decimal_Cero		DECIMAL(14,2);
	DECLARE 	Salida_SI			CHAR(1);
	DECLARE 	Var_Control			VARCHAR(200);
	DECLARE 	Var_Consecutivo		INT(11);

	/* asignacion de constantes */
	SET	NumTipoCuentaID		:= 0;  	-- Numero del tipo de cuenta
	SET	Cadena_Vacia		:= ''; 	-- Constante cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Constante fecha vacia
	SET	Entero_Cero			:= 0; 	-- Constante entero cero
	SET	Decimal_Cero		:= 0.0;	-- COnstante DECIMAL cero
	SET Salida_SI			:= 'S';	-- Salida SI

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen :=  CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
												'esto le ocasiona. Ref: SP-TIPOSCUENTAALT');
					SET Var_Control = 'SQLEXCEPTION' ;
				END;

		IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen :='La Moneda esta Vacia.';
			SET Var_Control :=  'monedaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Descripcion esta Vacia.';
			SET Var_Control :=  'descripcion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Abreviacion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Abreviacion esta Vacia.';
			SET Var_Control :=  'abreviacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MinimoApertura,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'Minimo de Apertura esta Vacio.' ;
			SET Var_Control :=  'minimoApertura' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NivelID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El Nivel de Cuenta esta Vacio.' ;
			SET Var_Control :=  'nivelCtaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EnvioSMSRetiro, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'Se debe indicar si se habilitan o no los envios de SMS en retiros';
			SET Var_Control:= 'envioSMSRetiro';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MontoMinSMSRetiro < Decimal_Cero) THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'El monto minimo para envios de SMS no debe ser menor que cero';
			SET Var_Control:= 'montoMinSMSRetiro';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NotificacionSms, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 009;
			SET Par_ErrMen := 'Se debe indicar si se habilitan o no los envios de SMS de bienvenida';
			SET Var_Control:= 'NotificacionSms';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NotificacionSms = Salida_SI) THEN
			IF(IFNULL(Par_PlantillaID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'No se ha definido una Plantilla para el mensaje de bienvenida';
				SET Var_Control:= 'Par_PlantillaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_ComisionSalProm, Entero_Cero)>Entero_Cero AND  IFNULL(Par_SaldoPromMinReq, Entero_Cero)=Entero_Cero )THEN
			SET Par_NumErr := 011;
			SET Par_ErrMen := 'Saldo Promedio Mínimo Requerido debe ser mayor a 0.';
			SET Var_Control:= 'saldoPromMinReq';
			LEAVE ManejoErrores;
		END IF;

	    IF(IFNULL(Par_ExentaCobroSalPromOtros, Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'Exenta Cobro Comision Saldo Promedio Otros Productos esta vacio.';
			SET Var_Control:= 'exentaCobroSalPromOtros';
			LEAVE ManejoErrores;
	    END IF;

		IF(Par_DepositoActiva = Salida_SI) THEN
			IF(IFNULL(Par_MontoDepositoActiva, Entero_Cero) <= Entero_Cero)THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := 'El Monto para Activacion Cta debe ser Mayor a Cero.';
				SET Var_Control:= 'montoDepositoActiva';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET NumTipoCuentaID:= (SELECT IFNULL(MAX(TipoCuentaID),Entero_Cero) + 1 FROM TIPOSCUENTAS);
		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET Par_ClaveCNBV :=  IFNULL(Par_ClaveCNBV,Cadena_Vacia);
		SET Par_ClaveCNBVAmpCred :=  IFNULL(Par_ClaveCNBVAmpCred,Cadena_Vacia);


		INSERT INTO TIPOSCUENTAS (
			TipoCuentaID,			MonedaID,				Descripcion,			Abreviacion,			GeneraInteres,
			TipoInteres,			EsServicio,				EsBancaria,				EsConcentradora,		MinimoApertura,
			ComApertura,			ComManejoCta,			ComAniversario,			CobraBanEle,			ParticipaSpei,
			CobraSpei,		    	ComSpeiPerFis,          ComSpeiPerMor,  		ComFalsoCobro,			ExPrimDispSeg,
			ComDispSeg,				SaldoMInReq,		    TipoPersona,			EsBloqueoAuto,			ClasificacionConta,
			RelacionadoCuenta,  	RegistroFirmas,		    HuellasFirmante,		ConCuenta,				GatInformativo,
			NivelID,				DireccionOficial,   	IdenOficial,        	CheckListExpFisico, 	LimAbonosMensuales,
			AbonosMenHasta,     	PerAboAdi,           	AboAdiHas,         		LimSaldoCuenta,     	SaldoHasta,
			NumRegistroRECA,    	FechaInscripcion,   	NombreComercial,		EnvioSMSRetiro,			MontoMinSMSRetiro,
			ClaveCNBV,				ClaveCNBVAmpCred,		EstadoCivil,			NotificacionSms,		PlantillaID,
           	ComisionSalProm,		SaldoPromMinReq,		ExentaCobroSalPromOtros,DepositoActiva,			MontoDepositoActiva,
            EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES (
			NumTipoCuentaID,	   	Par_MonedaID,			Par_Descripcion,		Par_Abreviacion,		Par_GeneraInteres,
			Par_TipoInteres,	   	Par_EsServicio,			Par_EsBancaria,			Par_EsConcentra,		Par_MinimoApertura,
			Par_ComApertura,	   	Par_ComManejoCta,		Par_ComAniversario,		Par_CobraBanEle,		Par_ParticipaSpei,
			Par_CobraSpei,	       	Par_ComSpeiPerFis,      Par_ComSpeiPerMor,      Par_ComFalsoCobro,		Par_ExPrimDispSeg,
			Par_ComDispSeg,		  	Par_SaldoMinR,		    Par_TipoPersona,	    Par_EsBloqueoAuto,		Par_ClasificacionConta,
			Par_RelacionadoCuenta, 	Par_RegistroFirmas,     Par_HuellasFirmante,	Par_ConCuenta,			Par_GatInformativo,
			Par_NivelID,		   	Par_DireccionOficial, 	Par_IdenOficial,        Par_CheckListExpFisico,	Par_LimAbonosMensuales,
			Par_AbonosMenHasta,   	Par_PerAboAdi,        	Par_AboAdiHas,			Par_LimSaldoCuenta,		Par_SaldoHasta,
			Par_NumRegistroRECA,   	Par_FechaInscripcion,  	Par_NombreComercial,	Par_EnvioSMSRetiro,		Par_MontoMinSMSRetiro,
			Par_ClaveCNBV,		   	Par_ClaveCNBVAmpCred,	Par_EstadoCivil,		Par_NotificacionSms,   	Par_PlantillaID,
            Par_ComisionSalProm,	Par_SaldoPromMinReq,	Par_ExentaCobroSalPromOtros,Par_DepositoActiva,	Par_MontoDepositoActiva,
            Aud_EmpresaID,		   	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		   	Aud_NumTransaccion);
			
		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= CONCAT("Tipo de Cuenta Agregado Exitosamente: ", CONVERT(NumTipoCuentaID, CHAR));
		SET Var_Control := 'tipoCuentaID' ;
		SET Var_Consecutivo := NumTipoCuentaID;

		END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$