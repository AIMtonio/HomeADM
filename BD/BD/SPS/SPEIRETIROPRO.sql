-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRETIROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRETIROPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEIRETIROPRO`(



    Par_InstitucionID       INT,
    Par_CuentaBancos        VARCHAR(20),
    Par_Monto			    DECIMAL(16,2),
    Par_Cierre		        CHAR(1),
    OUT Par_Consecutivo     BIGINT,

    Par_Salida              CHAR(1),
	OUT Par_NumErr          INT,
	OUT Par_ErrMen          VARCHAR(400),

	Par_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
	)
TerminaStore: BEGIN



	DECLARE Var_Control	           	VARCHAR(200);
	DECLARE Var_Consecutivo        	BIGINT(20);
	DECLARE Var_PrioEnvio          	INT(1);
	DECLARE Var_EstatusEnv         	INT(3);
	DECLARE Var_FechaRecep         	DATE;
	DECLARE Var_InstiReceptora	   	INT(5);
	DECLARE Var_CuentaBeneficiario 	VARCHAR(20);
	DECLARE Var_NombreBeneficiario 	VARCHAR(40);
	DECLARE Var_RFCBeneficiario    	VARCHAR(18);
	DECLARE Var_CuentaAhoID        	BIGINT(12);
	DECLARE Var_ClienteID          	INT;
	DECLARE Var_MonedaID           	INT(11);
	DECLARE Var_Poliza             	BIGINT;
	DECLARE Var_CuentaAhoIDS       	BIGINT(12);
	DECLARE Var_InstiIDS	       	INT(11);
	DECLARE Var_NumCtaInstit	   	VARCHAR(20);
	DECLARE AltaMovAhorro_SI       	CHAR(1);

	DECLARE Var_InstitucionID      	INT;
	DECLARE Var_Clabe              	VARCHAR(18);
	DECLARE Var_SpeiPendientes     	INT;
	DECLARE Var_DescripConta       	VARCHAR(100);
	DECLARE Var_NombreCorto        	VARCHAR(45);
    DECLARE Var_SpeiSaldoActual	   	DECIMAL(16,2);


	DECLARE	Cadena_Vacia	       	CHAR(1);
	DECLARE	Entero_Cero		       	INT;
	DECLARE	Decimal_Cero	       	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		       	DATE;
	DECLARE Salida_SI 		       	CHAR(1);
	DECLARE Salida_NO              	CHAR(1);
	DECLARE Tipo_Pago              	INT(2);
	DECLARE Folio		           	BIGINT(20);
	DECLARE Clave_Ras              	VARCHAR(30);
	DECLARE Num_Uno                	INT;
	DECLARE TipoCuentaBen  	       	INT(2);
	DECLARE AltaMovAhorro_NO       	CHAR(1);
	DECLARE AltaPoliza_SI          	CHAR(1);
	DECLARE CtoCon_Spei	           	INT;
	DECLARE Nat_Cargo             	CHAR(1);
	DECLARE Nat_Abono              	CHAR(1);
	DECLARE	Var_DescMov		       	VARCHAR(150);
	DECLARE Var_Descripcion        	VARCHAR(150);
	DECLARE Var_Estatus            	CHAR(1);
	DECLARE	CtoAho_Spei		       	INT;
	DECLARE TipoInstrumentoID      	INT(11);
	DECLARE EstatusPendiente       	CHAR(1);
	DECLARE EstatusAutorizado      	CHAR(1);
	DECLARE EstatusVerificado      	CHAR(1);
	DECLARE Cierre_Dia  	       	CHAR(1);
	DECLARE Var_Refere			   	VARCHAR(35);
	DECLARE Var_Automatico  	   	CHAR(1);
	DECLARE Var_TipoMovIDC		   	INT;
	DECLARE Var_TipoMovIDA		   	INT;
	DECLARE Var_OrigenOperacion		CHAR(1);
	DECLARE TipoConBanxico			CHAR(1);
	DECLARE Var_SpeiRemID			BIGINT(20);
	DECLARE Var_TipoPagoRem			INT(11);

	SET	Cadena_Vacia	 	:= '';
	SET	Fecha_Vacia		 	:= '1900-01-01 00:00:00';
	SET	Entero_Cero		 	:= 0;
	SET	Decimal_Cero	 	:= 0.0;
	SET Salida_SI        	:= 'S';
	SET Salida_NO        	:= 'N';
	SET Tipo_Pago        	:= 5;
	SET Folio            	:= 0;
	SET Clave_Ras        	:= '';
	SET Num_Uno         	:= 1;
	SET TipoCuentaBen     	:= 40;
	SET AltaMovAhorro_NO  	:= 'N';
	SET AltaPoliza_SI     	:= 'S';
	SET CtoCon_Spei		  	:= 808;
	SET Nat_Cargo		 	:= 'C';
	SET Nat_Abono		  	:= 'A';
	SET Var_DescMov       	:= 'RETIRO SPEI';
	SET Var_Estatus       	:= 'A';
	SET CtoAho_Spei		  	:= 1;
	SET TipoInstrumentoID 	:= 27;
	SET EstatusPendiente  	:= 'P';
	SET EstatusAutorizado 	:= 'A';
	SET EstatusVerificado 	:= 'V';
	SET Cierre_Dia        	:= 'D';
	SET AltaMovAhorro_SI  	:= 'S';
	SET Var_Automatico 		:= 'P';
	SET Var_TipoMovIDC		:= 13;
	SET Var_TipoMovIDA		:= 14;
    SET	Var_OrigenOperacion	:= 'V';
	SET TipoConBanxico		:= 'B';				-- Tipo de Conexión Banxico (conecta).
	SET Var_TipoPagoRem			:= 15;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRETIROPRO');
				SET Var_Control = 'sqlException';
			END;


		SET Var_FechaRecep := (SELECT	FechaSistema	FROM	PARAMETROSSIS);

		IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen 	:= 'El Monto de Envio esta Vacio.';
			SET Var_Control	:= 'monto' ;
			LEAVE ManejoErrores;
		END IF;

        SELECT 	SaldoActual INTO Var_SpeiSaldoActual
	  	  FROM SPEISALDOS
	 	 WHERE 	EmpresaID	= Par_EmpresaID;


		IF (IFNULL(Par_Cierre, Cadena_Vacia) = Cierre_Dia) THEN

			SELECT		SpeiRemID
				INTO	Var_SpeiRemID
				FROM	SPEIREMESAS
				WHERE	Estatus = EstatusPendiente
				  AND	TipoPagoID = Var_TipoPagoRem
				LIMIT	1;

			SET Var_SpeiRemID	:= IFNULL(Var_SpeiRemID, Entero_Cero);

			IF (Var_SpeiRemID > Entero_Cero) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'Existen Remesas que no han sido Enviadas o Canceladas,
									por tal Motivo el Cierre no ha sido Realizado';
				LEAVE ManejoErrores;
			END IF;

			SET Var_SpeiPendientes := (SELECT COUNT(*) FROM SPEIENVIOS
										WHERE (Estatus = EstatusPendiente OR Estatus = EstatusAutorizado OR Estatus = EstatusVerificado)
										AND	DATE(FechaRecepcion) = Var_FechaRecep);

			IF (IFNULL(Var_SpeiPendientes, Entero_Cero) > Entero_Cero ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'Existen Transferencias que no han sido Enviadas o Canceladas,
									por tal Motivo el Cierre no ha sido Realizado';
				LEAVE ManejoErrores;
			END IF;

            IF (IFNULL(Var_SpeiSaldoActual, Decimal_Cero) != Par_Monto ) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('Saldo de Cierre es diferente al Saldo SPEI $',CONVERT(Var_SpeiSaldoActual,CHAR));
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF (IFNULL(Var_SpeiSaldoActual, Decimal_Cero) <= Par_Monto ) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('Saldo de Cierre Parcial es mayor o igual al Saldo SPEI $',CONVERT(Var_SpeiSaldoActual,CHAR));
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF NOT EXISTS (SELECT	InstitucionID
			FROM INSTITUCIONES
			WHERE	InstitucionID = Par_InstitucionID) THEN
				SET	Par_NumErr 	:= 002;
				SET Par_ErrMen 	:= CONCAT('La Institucion ',Par_InstitucionID, ' no Existe');
				SET Var_Control	:= 'institucionID' ;
				LEAVE ManejoErrores;
		END IF;


		IF NOT EXISTS (SELECT NumCtaInstit
			FROM CUENTASAHOTESO
			WHERE	NumCtaInstit = Par_CuentaBancos) THEN
				SET Par_NumErr 	:= 003;
				SET Par_ErrMen 	:= CONCAT('La Cuenta Bancaria ',Par_CuentaBancos, ' no Existe');
				SET Var_Control	:= 'numCtaInstit' ;
				LEAVE ManejoErrores;
		END IF;

		SELECT	cl.NombreCompleto,	cht.CueClave,	cl.RFC,		ch.CuentaAhoID,		cl.ClienteID,
				ch.MonedaID
		  INTO	Var_NombreBeneficiario,	Var_CuentaBeneficiario,	Var_RFCBeneficiario,	Var_CuentaAhoID,	Var_ClienteID,
				Var_MonedaID
			FROM CUENTASAHOTESO cht
				JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
				JOIN CLIENTES cl ON ch.ClienteID=cl.ClienteID
			WHERE	cht.NumCtaInstit 	= Par_CuentaBancos
			  AND	cht.InstitucionID 	= Par_InstitucionID;

		SELECT	PS.Prioridad, 	PS.Clabe,	CO.CuentaAhoID, 	CT.NumCtaInstit,	CT.InstitucionID
		  INTO 	Var_PrioEnvio, 	Var_Clabe, 	Var_CuentaAhoIDS,	Var_NumCtaInstit,	Var_InstiIDS
			FROM PARAMETROSSPEI PS
				JOIN CUENTASAHOTESO CT ON  PS.Clabe=CT.CueClave
				JOIN CUENTASAHO CO ON CT.CuentaAhoID=CO.CuentaAhoID
				JOIN CLIENTES CTE ON CO.ClienteID=CTE.ClienteID;


		SELECT	ClaveParticipaSpei,	NombreCorto
		  INTO	Var_InstitucionID,	Var_NombreCorto
			FROM INSTITUCIONES
			WHERE	InstitucionID = Par_InstitucionID;


		SET Var_DescripConta := CONCAT(Var_DescMov,' ',Var_NombreCorto,' ',Par_CuentaBancos);

		SET Var_Refere := CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));

		SET Var_EstatusEnv := Num_Uno;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Var_Poliza 		:= Entero_Cero;

		CALL SPEIENVIOSALT(
			Folio,              	Clave_Ras,           	Tipo_Pago,           	Var_CuentaAhoIDS,     	Entero_Cero,
			Cadena_Vacia,			Cadena_Vacia,           Cadena_Vacia,		    Var_MonedaID,           Entero_Cero,
			Par_Monto,    			Entero_Cero,       		Entero_Cero,            Entero_Cero,        	Entero_Cero,
			Par_Monto,  			Var_InstitucionID,	    Var_CuentaBeneficiario, Var_NombreBeneficiario,	Var_RFCBeneficiario,
			TipoCuentaBen,	   		Var_DescMov,	    	Entero_Cero,			Cadena_Vacia,    		Cadena_Vacia,
			Entero_Cero,   			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,      		Var_PrioEnvio,
			Fecha_Vacia,	        Var_EstatusEnv,		    Cadena_Vacia,	        Aud_Usuario,            Entero_Cero,
			Var_Estatus,		    Var_FechaRecep,         Fecha_Vacia,            Entero_Cero,			Cadena_Vacia,
			Var_OrigenOperacion,	Entero_Cero,			TipoConBanxico,			Salida_NO,				Par_NumErr,
			Par_ErrMen,             Par_EmpresaID,			Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP,
            Aud_ProgramaID,	        Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL TESORERIAMOVIMIALT(
			Var_CuentaAhoIDS,	Var_FechaRecep,		Par_Monto,			Var_DescMov, 		Var_Refere,
			Cadena_Vacia,     	Nat_Cargo,  		Var_Automatico, 	Var_TipoMovIDC,  	Entero_Cero,
			Par_Consecutivo,	Salida_NO,        	Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL TESORERIAMOVIMIALT(
			Var_CuentaAhoID,	Var_FechaRecep,		Par_Monto,			Var_DescMov, 		Var_Refere,
			Cadena_Vacia,     	Nat_Abono,  		Var_Automatico, 	Var_TipoMovIDA,  	Entero_Cero,
			Par_Consecutivo,	Salida_NO,        	Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL CONTASPEISPRO(
			Folio,					Aud_Sucursal,		Var_MonedaID,		Var_FechaRecep,		Var_FechaRecep,
			Par_Monto,				Entero_Cero,		Entero_Cero,	    Var_DescMov,		Entero_Cero,
			Var_CuentaAhoID,	    AltaPoliza_SI, 		Var_Poliza,		    CtoCon_Spei, 	    Nat_Abono,
			AltaMovAhorro_NO,		Var_CuentaAhoID, 	Var_ClienteID, 		Nat_Cargo,			CtoAho_Spei,
			Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL POLIZASTESOREPRO(
			Var_Poliza,         Par_EmpresaID,      Var_FechaRecep,         Var_Clabe,          Aud_Sucursal,
			Entero_Cero,        Par_Monto,			Decimal_Cero,           Var_MonedaID,       Entero_Cero,
			Entero_Cero,    	Entero_Cero,        Par_InstitucionID,      Par_CuentaBancos,   Var_DescripConta,
			Folio,  			Par_Consecutivo,	Salida_NO,          	Par_NumErr,         Par_ErrMen,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSCUENTATESOACT(
			Var_NumCtaInstit,	Var_InstiIDS,		Par_Monto,			Nat_Cargo,			Par_Consecutivo,
			Salida_NO,			Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSCUENTATESOACT(
			Par_CuentaBancos,	Par_InstitucionID,	Par_Monto,			Nat_Abono,			Par_Consecutivo,
			Salida_NO,			Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;



        IF (IFNULL(Par_Cierre, Cadena_Vacia) = Cierre_Dia) THEN

			CALL PARAMETROSSPEIACT(
				Par_EmpresaID, 		2, 					Salida_NO,			Par_NumErr,       	Par_ErrMen,
				Aud_Usuario,     	Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Envio SPEI Agregado Exitosamente';
		SET Var_Control	:= 'cuentaAhoID';

	END ManejoErrores;

		IF(Par_Salida = Salida_SI)THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Folio AS consecutivo;
		END IF;

END TerminaStore$$