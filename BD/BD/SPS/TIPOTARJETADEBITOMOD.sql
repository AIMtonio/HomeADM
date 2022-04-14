-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETADEBITOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOTARJETADEBITOMOD`;
DELIMITER $$

CREATE PROCEDURE `TIPOTARJETADEBITOMOD`(
	# SP PARA MODIFICACION DE TIPO TARJETA DEBITO Y CREDITO
	Par_TipoTarjetaDebID	INT(11),		-- Parametro de Tipo Tarjeta ID
	Par_Descripcion			VARCHAR(150),	-- Parametro Descripcion
	Par_CompraPOS			CHAR(1),		-- Parametro de Compra POS S= Si N = No
	Par_Estatus		    	CHAR(1),		-- Parametro de Estatus Tipo Tarjeta
	Par_IdentificaSocio		CHAR(1),		-- Parametro si requiere Identificacion

    Par_TipoProsaID			CHAR(4),		-- Id de prosa
    Par_VigenciaMeses		INT(11),		-- Parametro de Vigencia en Meses
    Par_ColorTarjeta		CHAR(2),		-- Parametro de color de tarjeta
    Par_TipoTarjeta			CHAR(1),		-- Parametro de Tipo Tarjeta
	Par_ProductoCredito		INT(11),		-- Parametro de Producto de Credito

    Par_TasaFija			DECIMAL(12,4),	-- Parametro de Tasa Fija
    Par_MontoAnual			DECIMAL(12,2),	-- Parametro de Monto Anual
    Par_CobraMora			CHAR(1),		-- Parametro de Cobra Moratorios S= Si N= No
    Par_TipoMora			CHAR(1),		-- Parametro de Tipo de Moratorio
    Par_FactorMora			DECIMAL(12,4),	-- Parametro de Factor de Moratorio

    Par_CobFalPago			CHAR(1),		-- Parametro de Cobra Falta de Pago S= Si N= No
    Par_TipoFalPago			CHAR(1),		-- Parametro de Tipo de falta de Pago
    Par_FacFalPago			DECIMAL(12,4),	-- Parametro de Tipo de falta de Pago
    Par_PorcPagMin			DECIMAL(10,4),	-- Parametro de Procentaje de Pago Minimo
    Par_MontoCredito		DECIMAL(12,2),	-- Parametro de monto de credito

    Par_CobComisionAper		CHAR(1),		-- Parametro de Cobro Comisiones por Apertura
    Par_TipoCobComAper		CHAR(1),		-- Parametro de Tipo de Cobro comision por apertura
    Par_FacComisionAper		DECIMAL(12,4),	-- Parametro de Factor de comision por apertura
    Par_TarBinParamsID    INT(11),        -- Identificador de tabla TARBINPARAMS
    Par_NumSubBIN         CHAR(2),        -- Numero del SubBin

    Par_PatrocinadorID    INT(11),          -- identificar a que institución pertenece el subbin
    Par_TipoCore          INT(11),        -- Tipo de Core 1-Core Externo, 2-SAFI Externo, 3-SAFI (Copayment)
    Par_UrlCore           VARCHAR(100),   -- La cadena de la url del core
    Par_TipoMaquilador    INT(11),        -- Tipo de maquilador

	Par_Salida              CHAR(1),          -- Tipo salida
	INOUT Par_NumErr        INT(11),          -- Numero de error
	INOUT Par_ErrMen        VARCHAR(400),     -- Mensaje de error

	Aud_EmpresaID			INT,			-- Parametro de Auditoria
	Aud_Usuario				INT,			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT,			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT			-- Parametro de Auditoria
		)
TerminaStore: BEGIN

	-- Variables
	DECLARE Var_TipoTarjetaDebExit INT(11);		-- Valida que no se registre un subbin con el mismo bin

	DECLARE	Estatus_Activo		CHAR(1);		-- Estatus Activo
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE	Entero_Cero			INT;			-- entero Cero
	DECLARE Modificar      	 	INT;  			-- Numero de Moficiacion
	DECLARE Var_TipoTarDebID	INT;			-- Variable de tipo Tarjeta ID
	DECLARE TipoCred			CHAR(1);		-- Tipo Credito
	DECLARE Decimal_Cero    	DECIMAL(2,2);	-- DECIMAL cero
	DECLARE SalidaSI        	CHAR(1);		-- Salida SI
	DECLARE varControl 			CHAR(20);		# almacena el elemento que es incorrecto
	DECLARE CadenaSi			CHAR(1);		-- Cadena SI
	DECLARE MaquilTGS			INT(2);			-- Identificador de maquila para TGS
	DECLARE MaquiISS  			INT(11);      -- Tipo de maquilador ISS

	SET	Estatus_Activo	:= 'A';
	SET	Cadena_Vacia	:= '';
	SET TipoCred		:= 'C';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Decimal_Cero    := '0.00';
	SET Aud_FechaActual	:= NOW();
	SET Modificar 		:=9;
	SET SalidaSI        := 'S';             -- El Store SI genera una Salida
    SET CadenaSi		:= 'S';
    SET MaquilTGS		:= 2;
    SET MaquiISS    	:= 1;                 -- Tipo maquilador ISS

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TIPOTARJETADEBITOMOD');
    END;

	SET Var_TipoTarDebID := (SELECT tar.TipoTarjetaDebID FROM TIPOTARJETADEB tar WHERE tar.TipoTarjetaDebID = Par_TipoTarjetaDebID);

	IF (Var_TipoTarDebID = Par_TipoTarjetaDebID) THEN
		IF(IFNULL(Par_Descripcion,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Especifique la descripcion';
			SET varControl  := 'descripcion' ;
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_Estatus,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Especifique el estatus';
			SET varControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoMaquilador = MaquiISS) THEN
			IF(IFNULL(Par_TipoProsaID,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := 'Especifique el Tipo de Reporte';
				SET varControl  := 'tipoProsaID' ;
				LEAVE ManejoErrores;
			END IF;
	        IF(IFNULL(Par_ColorTarjeta,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := 'Especifique el Color de Tarjeta.';
				SET varControl  := 'colorTarjeta' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


        IF(IFNULL(Par_TipoTarjeta,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Especifique el Tipo de Tarjeta.';
			SET varControl  := 'tipoTarjeta' ;
			LEAVE ManejoErrores;
		END IF;
		IF(Par_TipoTarjeta = TipoCred) THEN
			IF(IFNULL(Par_ProductoCredito,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 006;
				SET Par_ErrMen  := 'Especifique el Producto de Credito.';
				SET varControl  := 'productoCredito' ;
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_TasaFija,Decimal_Cero)) = Decimal_Cero THEN
					SET	Par_NumErr 	:= 007;
					SET	Par_ErrMen	:= 'Especifique la Tasa Fija';
					SET varControl  := 'tasaFija' ;
					LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_CobraMora,Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr 	:= 009;
					SET	Par_ErrMen	:= 'Especifique si Cobra Mora';
					SET varControl  := 'cobraMora' ;
					LEAVE ManejoErrores;
			END IF;
			IF(Par_CobraMora = CadenaSi) THEN
				IF(IFNULL(Par_TipoMora,Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr 	:= 010;
					SET	Par_ErrMen	:= 'Especifique el tipo de cobranza de moratorios';
					SET varControl  := 'tipoMora' ;
					LEAVE ManejoErrores;
				END IF;
				IF(IFNULL(Par_FactorMora,Decimal_Cero)) = Decimal_Cero THEN
						SET	Par_NumErr 	:= 011;
						SET	Par_ErrMen	:= 'Especifique el Factor de Moratorios';
						SET varControl  := 'factorMora' ;
						LEAVE ManejoErrores;
				END IF;
            END IF;
			IF(IFNULL(Par_CobFalPago,Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr 	:= 012;
					SET	Par_ErrMen	:= 'Especifique si cobra por Falta de Pago';
					SET varControl  := 'cobFaltaPago' ;
					LEAVE ManejoErrores;
			END IF;
            IF(Par_CobFalPago = CadenaSi) THEN
				IF(IFNULL(Par_TipoFalPago,Cadena_Vacia)) = Cadena_Vacia THEN
						SET	Par_NumErr 	:= 013;
						SET	Par_ErrMen	:= 'Especifique el tipo de cobranza por falta de pago';
						SET varControl  := 'tipoFaltaPago' ;
						LEAVE ManejoErrores;
				END IF;
				IF(IFNULL(Par_FacFalPago,Decimal_Cero)) = Decimal_Cero THEN
						SET	Par_NumErr 	:= 014;
						SET	Par_ErrMen	:= 'Especifique el Factor de Falta de Pago';
						SET varControl  := 'facFaltaPago' ;
						LEAVE ManejoErrores;
				END IF;
            END IF;
			IF(IFNULL(Par_PorcPagMin,Decimal_Cero)) = Decimal_Cero THEN
					SET	Par_NumErr 	:= 015;
					SET	Par_ErrMen	:= 'Especifique el porcentaje de pago minimo';
					SET varControl  := 'porcPagoMin' ;
					LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_MontoCredito,Decimal_Cero)) = Decimal_Cero THEN
					SET	Par_NumErr 	:= 016;
					SET	Par_ErrMen	:= 'Especifique el monto del credito';
					SET varControl  := 'montoCredito' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_CobComisionAper = CadenaSI) THEN
			IF(IFNULL(Par_CobComisionAper,Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr 	:= 017;
					SET	Par_ErrMen	:= 'Especifique si cobra por Comision por Apertura';
					SET varControl  := 'cobComisionAper' ;
					LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_TipoCobComAper,Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr 	:= 018;
					SET	Par_ErrMen	:= 'Especifique el tipo de cobranza por Apertura';
					SET varControl  := 'tipoCobComAper' ;
					LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_FacComisionAper,Decimal_Cero)) = Decimal_Cero THEN
				SET	Par_NumErr 	:= 019;
				SET	Par_ErrMen	:= 'Especifique el Factor de Comision por Apertura';
				SET varControl  := 'facComisionAper' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
    END IF;

    IF(Par_TipoMaquilador = MaquilTGS)THEN
	    IF(IFNULL(Par_TarBinParamsID,Entero_Cero)) = Entero_Cero THEN
	        SET Par_NumErr  := 20;
	        SET Par_ErrMen  := 'Especifique el BIN configurado';
	        SET varControl  := 'tarBinParamsID' ;
	        LEAVE ManejoErrores;
	    END IF;
	    SET Par_TipoCore := IFNULL(Par_TipoCore,Entero_Cero);
	    IF(Par_TipoCore NOT IN (1,2,3)) THEN
	        SET Par_NumErr  := 21;
	        SET Par_ErrMen  := 'Especifique un tipo de core valido 1-Externo, 2-SAFI Externo o 3-SAFI Copayment';
	        SET varControl  := 'tipoCore';
	        LEAVE ManejoErrores;
	    END IF;
	    IF(IFNULL(Par_UrlCore,Cadena_Vacia)) = Cadena_Vacia AND Par_TipoCore IN (1,2) THEN
	        SET Par_NumErr  := 22;
	        SET Par_ErrMen  := 'Especifique el Core o Ruta URL';
	        SET varControl  := 'urlCore';
	        LEAVE ManejoErrores;
	    END IF;
	      IF(IFNULL(Par_PatrocinadorID,Entero_Cero)) = Entero_Cero THEN
	        SET Par_NumErr  := 23;
	        SET Par_ErrMen  := 'Especifique el patrocinador';
	        SET varControl  := 'PatrocinadorID';
	        LEAVE ManejoErrores;
	    END IF;
	    IF(IFNULL(Par_NumSubBIN,Cadena_Vacia)) = Cadena_Vacia THEN
	        SET Par_NumErr  := 24;
	        SET Par_ErrMen  := 'Especifique el numero del subbin';
	        SET varControl  := 'numSubBIN';
	        LEAVE ManejoErrores;
	    END IF;

	    SELECT TipoTarjetaDebID
	      INTO Var_TipoTarjetaDebExit
	    FROM TIPOTARJETADEB
	      WHERE TarBinParamsID = Par_TarBinParamsID
	        AND NumSubBIN = Par_NumSubBIN
	        AND TipoTarjetaDebID <> Par_TipoTarjetaDebID;

	    IF(IFNULL(Var_TipoTarjetaDebExit,Entero_Cero)) != Entero_Cero THEN
	        SET Par_NumErr  := 25;
	        SET Par_ErrMen  := 'Ya existe un subbin asociado al bin configurado.';
	        SET varControl  := 'TarBinParamsID';
	        LEAVE ManejoErrores;
	    END IF;
	END IF;

    UPDATE TIPOTARJETADEB SET
			Descripcion				= Par_Descripcion,
			CompraPOSLinea			= Par_CompraPOS,
			Estatus					= Par_Estatus,
			IdentificacionSocio		= Par_IdentificaSocio,
			TipoProsaID    		 	= Par_TipoProsaID,

			VigenciaMeses   		= Par_VigenciaMeses,
			ColorTarjeta    		= Par_ColorTarjeta,
			TipoTarjeta				= Par_TipoTarjeta,
			ProductoCredito			= Par_ProductoCredito,
            TasaFija				= Par_TasaFija,

            MontoAnualidad			= Par_MontoAnual,
            CobraMora				= Par_CobraMora,
            TipCobComMorato			= Par_TipoMora,
            FactorMora				= Par_FactorMora,
            CobraFaltaPago			= Par_CobFalPago,

            TipCobComFalPago		= Par_TipoFalPago,
            FactorFaltaPago			= Par_FacFalPago,
            PorcPagoMin				= Par_PorcPagMin,
            MontoCredito			= Par_MontoCredito,
            CobComisionAper			= Par_CobComisionAper,

            TipoCobComAper			= Par_TipoCobComAper,
            FacComisionAper			= Par_FacComisionAper,
            TarBinParamsID			= Par_TarBinParamsID,
			NumSubBIN				= Par_NumSubBIN,
    		PatrocinadorID       	= Par_PatrocinadorID,

			TipoCore 				= Par_TipoCore,
			UrlCore 				= Par_UrlCore,
			TipoMaquilador 			= Par_TipoMaquilador,

			EmpresaID				= Aud_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,

			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion

	WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Tipo de Tarjeta de Debito Modificado Exitosmente');
			SET varControl  := 'tipoTarjetaDebID' ;
			 IF(Par_TipoTarjeta = TipoCred) THEN
				SET Par_ErrMen  := CONCAT('Tipo de Tarjeta de Credito Modificado Exitosamente');
            END IF;

		LEAVE ManejoErrores;

END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Par_TipoTarjetaDebID AS consecutivo;
	END IF;

END TerminaStore$$
