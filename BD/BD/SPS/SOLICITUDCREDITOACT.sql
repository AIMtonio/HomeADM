-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOACT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDCREDITOACT`(
# =====================================================================================
# ------- STORE PARA ACTUALIZAR SOLICITUDES DE CREDITOS---------
# =====================================================================================
	Par_SolicCredID		BIGINT(20),
	Par_MontoFondeo     DECIMAL(12,2),
	Par_PorceFondeo     DECIMAL(10,6),
    Par_Tasa            DECIMAL(18,4),
    Par_FactorMora      DECIMAL(18,4),

    Par_MontoPorComAper	DECIMAL(12,4),
	Par_NumAct			TINYINT UNSIGNED,
	Par_ClienteID		INT(11),
	Par_ProspectoID		INT(11),
	Par_CuentaCLABE		CHAR(18),

    Par_SobreTasa		DECIMAL(18,4),
    Par_FolioConSIC		VARCHAR(30),
    Par_ConvenioNominaID BIGINT UNSIGNED,			-- Identificador del convenio

	Par_Salida      	CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
    /* Parametros de Auditoria */
	Par_EmpresaID       INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

	DECLARE Entero_Cero   	    INT;
	DECLARE Entero_Uno   		INT;
	DECLARE Act_Alta			INT;
	DECLARE Act_ActCteIns		INT;
	DECLARE Act_Cancela   	    INT;
	DECLARE Act_WS		   	    INT;
	DECLARE Decimal_Cero   		DECIMAL(12,2);
	DECLARE Var_Iva		   		DECIMAL(12,2);
	DECLARE Cadena_Vacia   		CHAR(1);
	DECLARE SalidaSI	   		CHAR(1);
	DECLARE Fecha_Vacia   	    DATE;
	DECLARE Act_Cliente			INT;
	DECLARE EstatusDesem		CHAR(1);
	DECLARE Act_TsaFija       	INT;
	DECLARE Act_TsaMora        	INT;
	DECLARE Act_ComxApt        	INT;
	DECLARE Act_TsFMCom        	INT;
	DECLARE Act_SobreTasa      	INT;
    DECLARE Act_ConsultaBC		INT;
	DECLARE Act_ConsultaCC		INT;
    DECLARE Act_Reacredita		INT(11);
    DECLARE	Esta_Autori			CHAR(1);
    DECLARE Com_porcent			CHAR(1);
    DECLARE Com_Monto			CHAR(1);
	DECLARE Tipo_BuroCred		CHAR(2);
    DECLARE Tipo_CirculoC		CHAR(2);
    DECLARE Cons_SI				CHAR(1);

	DECLARE Var_TipoComA		CHAR(1);
    DECLARE Var_ProdCre			INT;
    DECLARE Var_MontoAut		DECIMAL(12,2);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_Consecutivo		BIGINT(20);

	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET	Fecha_Vacia		:= '1900-01-01';
	SET Cadena_Vacia	:= '';
	SET Act_Alta		:= 1;
	SET Act_Cancela		:= 2;
	SET Act_Cliente		:= 3;
	SET Act_WS			:= 4;
	SET Act_ActCteIns	:= 5;
	SET EstatusDesem 	:= 'D';
	SET	Act_TsaFija     := 6;
	SET Act_TsaMora     := 7;
	SET Act_ComxApt     := 8;
	SET Act_TsFMCom     := 9;
	SET Act_SobreTasa   := 10;
    SET Act_ConsultaBC	:= 11;
    SET Act_ConsultaCC	:= 12;
    SET Act_Reacredita	:= 13;
    SET	Esta_Autori		:= 'A';
	SET Com_porcent		:= 'P';
    SET Com_Monto		:= 'M';
    SET SalidaSI		:= 'S';
    SET Tipo_BuroCred	:= 'BC';
    SET Tipo_CirculoC	:= 'CC';
    SET Cons_SI			:= 'S';			-- Constante SI

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDITOACT');

		SET Var_Control:= 'sqlException';
    END;

	SET Aud_FechaActual :=  NOW();
	 -- Ticket 2737 aortega --
	IF EXISTS(SELECT SolicitudCreditoID FROM CREDITOS WHERE SolicitudCreditoID = Par_SolicCredID)THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'No Se Puede Actualizar La Tasa, El Credito Ya Se Encuentra Registrado.';
		SET Var_Control:= 'cuentaCLABE';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF (Par_NumAct = Act_TsaFija OR Par_NumAct =Act_TsaMora OR Par_NumAct =Act_ComxApt  OR Par_NumAct =Act_TsFMCom) THEN
			INSERT INTO CS_CAMBIOTASA
				SELECT Par_SolicCredID,Par_NumAct, TasaFija,FactorMora,MontoPorComAper,Par_EmpresaID,Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,Aud_Sucursal,Aud_NumTransaccion
					FROM SOLICITUDCREDITO 		WHERE	SolicitudCreditoID	=	Par_SolicCredID;
	END IF;

	IF(Par_NumAct = Act_Alta) THEN
		UPDATE	SOLICITUDCREDITO SET
			MontoFondeado			= IFNULL(MontoFondeado,Entero_Cero) + Par_MontoFondeo,
			PorcentajeFonde			= IFNULL(PorcentajeFonde,Entero_Cero) + Par_PorceFondeo,
			NumeroFondeos			= IFNULL(NumeroFondeos,Entero_Cero) + Entero_Uno,
			convenioNominaID		= IFNULL(Par_ConvenioNominaID, Entero_Uno),
			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	=	Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_ActCteIns) THEN
		UPDATE	SOLICITUDCREDITO SET
			MontoFondeado			= IFNULL(MontoFondeado,Entero_Cero) + Par_MontoFondeo,
			PorcentajeFonde			= IFNULL(PorcentajeFonde,Entero_Cero) + Par_PorceFondeo,
			NumeroFondeos			= IFNULL(NumeroFondeos,Entero_Cero),

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	=	Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_Cancela) THEN
		UPDATE	SOLICITUDCREDITO SET
			MontoFondeado			= IFNULL(IFNULL(MontoFondeado,Entero_Cero) - Par_MontoFondeo,Entero_Cero),
			PorcentajeFonde			= IFNULL(IFNULL(PorcentajeFonde,Entero_Cero) - Par_PorceFondeo,Entero_Cero),
			NumeroFondeos			= IFNULL(IFNULL(NumeroFondeos,Entero_Cero) - Entero_Uno,Entero_Cero),

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_Cliente) THEN
		UPDATE	SOLICITUDCREDITO SET
			ClienteID		= Par_ClienteID
		WHERE	ProspectoID	= Par_ProspectoID
		  AND	Estatus 	!= EstatusDesem
		  AND	(ClienteID = 0 OR ClienteID = '') ;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_WS) THEN

		IF(IFNULL(Par_CuentaCLABE, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= CONCAT('La Cuenta Clabe esta vacia.');
			SET Var_Control 	:= 'cuentaCLABE';
			SET Var_Consecutivo	:= Entero_Cero;

			LEAVE ManejoErrores;
		END IF;

		UPDATE	SOLICITUDCREDITO SET
			CuentaCLABE				= Par_CuentaCLABE
		WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campo Actualizado.');
		SET Var_Control 	:= 'porcentaje';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_TsaFija) THEN
		UPDATE	SOLICITUDCREDITO SET
			TasaFija		     	= Par_Tasa,

			EmpresaID		     	= Par_EmpresaID,
			Usuario			     	= Aud_Usuario,
			FechaActual 		 	= Aud_FechaActual,
			DireccionIP 		 	= Aud_DireccionIP,
			ProgramaID  		 	= Aud_ProgramaID,
			Sucursal			 	= Aud_Sucursal,
			NumTransaccion	     	= Aud_NumTransaccion
		WHERE	SolicitudCreditoID 	= Par_SolicCredID
		  AND	Estatus				= Esta_Autori;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Tasa Ordinaria Actualizada Exitosamente.');
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_TsaMora) THEN
		UPDATE	SOLICITUDCREDITO SET
			FactorMora		     	= Par_FactorMora,

			EmpresaID		     	= Par_EmpresaID,
			Usuario			     	= Aud_Usuario,
			FechaActual 		 	= Aud_FechaActual,
			DireccionIP 		 	= Aud_DireccionIP,
			ProgramaID  		 	= Aud_ProgramaID,
			Sucursal			 	= Aud_Sucursal,
			NumTransaccion	     	= Aud_NumTransaccion
		WHERE	SolicitudCreditoID 	= Par_SolicCredID
		  AND	Estatus				= Esta_Autori;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Tasa Moratoria Actualizada Exitosamente.');
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_ComxApt) THEN

		SELECT 	suc.IVA INTO Var_Iva
			FROM  SOLICITUDCREDITO sol
				INNER JOIN SUCURSALES suc ON suc.SucursalID = sol.SucursalID
			WHERE SolicitudCreditoID = Par_SolicCredID;

		SET Var_ProdCre		:= (SELECT productoCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolicCredID);
		SET Var_TipoComA	:= (SELECT TipoComXapert FROM PRODUCTOSCREDITO  WHERE ProducCreditoID =Var_ProdCre);


		IF (Var_TipoComA = Com_Monto) THEN
			UPDATE	SOLICITUDCREDITO SET
				MontoPorComAper	     	= Par_MontoPorComAper,
				IVAComAper				= ROUND(IFNULL(Var_Iva * Par_MontoPorComAper,Decimal_Cero),2),

				EmpresaID		     	= Par_EmpresaID,
				Usuario			     	= Aud_Usuario,
				FechaActual 		 	= Aud_FechaActual,
				DireccionIP 		 	= Aud_DireccionIP,
				ProgramaID  		 	= Aud_ProgramaID,
				Sucursal			 	= Aud_Sucursal,
				NumTransaccion	     	= Aud_NumTransaccion
			WHERE	SolicitudCreditoID 	= Par_SolicCredID
			  AND	Estatus				= Esta_Autori;
		ELSEIF(Var_TipoComA=Com_porcent) THEN


			UPDATE SOLICITUDCREDITO SET
				MontoPorComAper	     	= MontoAutorizado * (Par_MontoPorComAper/100),
				IVAComAper				= ROUND(IFNULL(Var_Iva * (MontoAutorizado * (Par_MontoPorComAper/100)),Decimal_Cero),2),

				EmpresaID		     	= Par_EmpresaID,
				Usuario			     	= Aud_Usuario,
				FechaActual 		 	= Aud_FechaActual,
				DireccionIP 		 	= Aud_DireccionIP,
				ProgramaID  		 	= Aud_ProgramaID,
				Sucursal			 	= Aud_Sucursal,
				NumTransaccion	     	= Aud_NumTransaccion
			WHERE	SolicitudCreditoID 	= Par_SolicCredID
			  AND	Estatus				= Esta_Autori;


		END IF;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Comision Por Apertura Actualizada Exitosamente.');
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_TsFMCom) THEN
		SELECT suc.IVA INTO Var_Iva
			FROM SOLICITUDCREDITO sol
				INNER JOIN SUCURSALES suc ON suc.SucursalID	= sol.SucursalID
			WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Var_ProdCre:= (SELECT productoCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolicCredID);
		SET Var_TipoComA	 := (SELECT TipoComXapert FROM PRODUCTOSCREDITO  WHERE ProducCreditoID =Var_ProdCre);

		UPDATE SOLICITUDCREDITO SET
			TasaFija		     	= Par_Tasa,
			FactorMora		     	= Par_FactorMora,
			MontoPorComAper	     	= CASE WHEN Var_TipoComA = Com_Monto THEN
										Par_MontoPorComAper
                                        ELSE
                                        MontoAutorizado * (Par_MontoPorComAper/100)
                                        END,
			IVAComAper				= CASE WHEN Var_TipoComA = Com_Monto THEN
										ROUND(IFNULL(Var_Iva * Par_MontoPorComAper,Decimal_Cero),2)
                                        ELSE
										ROUND(IFNULL(Var_Iva * Par_MontoPorComAper,Decimal_Cero),2)
                                        END,

			EmpresaID		     	= Par_EmpresaID,
			Usuario			     	= Aud_Usuario,
			FechaActual 		 	= Aud_FechaActual,
			DireccionIP 		 	= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal			 	= Aud_Sucursal,
			NumTransaccion	     	= Aud_NumTransaccion
		WHERE	SolicitudCreditoID 	= Par_SolicCredID
		  AND	Estatus				= Esta_Autori;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_SobreTasa) THEN
		IF(IFNULL(Par_Tasa,Decimal_Cero)=Decimal_Cero)THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen 		:= CONCAT('Tasa Base Actual esta vacia.');
			SET Var_Control 	:= 'tasaFija';
			SET Var_Consecutivo	:= Par_Tasa;
			LEAVE ManejoErrores;
        END IF;

		UPDATE	SOLICITUDCREDITO SET
			TasaFija		     	= Par_Tasa,
			SobreTasa		     	= Par_SobreTasa,

			EmpresaID		     	= Par_EmpresaID,
			Usuario			     	= Aud_Usuario,
			FechaActual 		 	= Aud_FechaActual,
			DireccionIP 		 	= Aud_DireccionIP,
			ProgramaID  		 	= Aud_ProgramaID,
			Sucursal			 	= Aud_Sucursal,
			NumTransaccion	     	= Aud_NumTransaccion
		WHERE	SolicitudCreditoID 	= Par_SolicCredID
		  AND	Estatus				= Esta_Autori;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Tasa Base Actual y Sobre Tasa Actualizadas Exitosamente.');
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

    -- actualizacion para folio de consulta de buro credito
    IF(Par_NumAct = Act_ConsultaBC) THEN
		UPDATE	SOLICITUDCREDITO SET
			TipoConsultaSIC			= Tipo_BuroCred,
			FolioConsultaBC			= Par_FolioConSIC,

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

    -- actualizacion para folio de consulta de circulo credito
    IF(Par_NumAct = Act_ConsultaCC) THEN
		UPDATE	SOLICITUDCREDITO SET
			TipoConsultaSIC			= Tipo_CirculoC,
			FolioConsultaCC			= Par_FolioConSIC,

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

     -- actualizacion para folio de consulta de circulo credito
    IF(Par_NumAct = Act_Reacredita) THEN
		UPDATE	SOLICITUDCREDITO SET
			Reacreditado			= Cons_SI,

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID	= Par_SolicCredID;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
		SET Var_Control 	:= 'solicitudCreditoID';
		SET Var_Consecutivo	:= Par_SolicCredID;

		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr 		:= 000;
	SET Par_ErrMen 		:= CONCAT('Campos Actualizados Exitosamente: ',CONVERT(Par_SolicCredID, CHAR));
	SET Var_Control 	:= 'solicitudCreditoID';
    SET Var_Consecutivo	:= Par_SolicCredID;

END ManejoErrores;

IF(Par_Salida = SalidaSI)THEN
    SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
        Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$