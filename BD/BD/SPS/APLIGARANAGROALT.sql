-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLIGARANAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLIGARANAGROALT`;
DELIMITER $$


CREATE PROCEDURE `APLIGARANAGROALT`(
	/* STORE PARA ALTRA LA BITACORA DE APLICACION DE GARANTIAS FIRA*/
	Par_CreditoID		    	BIGINT(12),			/* ID del credito */
	Par_TipoGarantiaID   		INT(11),			/* ID del tipo de garantia FIRA que fue aplicado */
	Par_CreditoFondeoID			BIGINT(12),			/* ID del credito pasivo */
	Par_ClienteID		   		INT(11),			/* ID del cliente */
	Par_CuentaAhoID				BIGINT(12),			/* ID de la cuenta de ahorro */

	Par_MontoGL					DECIMAL(14,2),		/* Monto de aplicacion de garantia Liquida*/
	Par_PorcentajeGtia			DECIMAL(14,4),		/* Porcentaje de garantia a aplicar*/
	Par_MontoGarApli			DECIMAL(14,2),		/* Monto de aplicacion de garantia*/
	Par_Fecha					DATE,				/* Fecha de registro del cambio*/
	Par_CreditoContFondeador	BIGINT(20), 		-- Numero de credito Contigente Fondeador

	Par_Observacion				VARCHAR(500),		-- Observaciones
	Par_AcreditadoIDFIRA		BIGINT(20),			-- Numero de Identificador de Acreditado por FIRA
	Par_CreditoIDFIRA			BIGINT(20),			-- Numero de Identificador de Credito por FIRA

	Par_Salida 					CHAR(1),    		/* Indica una salida*/
	INOUT	Par_NumErr	 		INT(11),			/* parametro numero de error*/
	INOUT	Par_ErrMen	 		VARCHAR(400),		/* mensaje de error*/

	Par_EmpresaID	    		INT(11),			/* parametros de auditoria*/
	Aud_Usuario	       			INT(11),			/* parametros de auditoria*/
	Aud_FechaActual				DATETIME ,			/* parametros de auditoria*/
	Aud_DireccionIP				VARCHAR(15),		/* parametros de auditoria*/
	Aud_ProgramaID	    		VARCHAR(70),		/* parametros de auditoria*/
	Aud_Sucursal	    		INT(11),			/* parametros de auditoria*/
	Aud_NumTransaccion			BIGINT(20)			/* parametros de auditoria */
)

TerminaStore: BEGIN

    /* Declaracion de Variables  */
	DECLARE Var_FechaSis 			DATE;				/* Fecha del sistema*/
	DECLARE Var_CreditoID			BIGINT(12);			/* ID del credito */
	DECLARE Var_Consecutivo			BIGINT(12);			/* Consecutivo*/
	DECLARE Var_Control				VARCHAR(100);		/* control de pantalla*/
	DECLARE Var_FechaAtraso			DATE;				/*Fecha de Atraso del credito*/
	DECLARE Var_GraciaMoratorios	INT(11);			/*Dias de gracia moratorios*/
	DECLARE Var_FechaSisAnt			DATE;				/*Dia anterior a la fecha del sistema*/
	DECLARE Var_DiasAtraso			INT(11);			/*dias de atraso del credito*/

	/* Declaracion de Constantes*/
	DECLARE Entero_Cero 		INT(11);			/* entero cero*/
	DECLARE Entero_Uno	 		INT(11);			/* entero uno*/
	DECLARE Decimal_Cero		DECIMAL(14,2);		/* DECIMAL Cero*/
	DECLARE Salida_SI 			CHAR(1);			/* salida SI*/
	DECLARE Fecha_Vacia 		DATE;				/* Fecha vacia*/
	DECLARE Cadena_Vacia 		CHAR(1);			/* cadena vacia*/
	DECLARE ConstanteNo			CHAR(1);			/* Constamnte no*/
	DECLARE EstatusPagado		CHAR(1);			/* Estatus pagado*/
	DECLARE Entero_Negativo		INT;

    /* Asignacion de constantes */
	SET Entero_Cero 	:= 0;
	SET Entero_Negativo	:= -1;
	SET Entero_Uno		:= 1;
	SET Decimal_Cero	:= 0.00;
	SET Salida_SI		:= 'S';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Cadena_Vacia 	:= '';
	SET ConstanteNo		:= 'N';
	SET EstatusPagado	:= 'P';
	SET Par_CreditoContFondeador	:= IFNULL(Par_CreditoContFondeador, Entero_Cero);
	SET Par_Observacion				:= IFNULL(Par_Observacion, Cadena_Vacia);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-APLIGARANAGROALT');
			SET Var_Control := 'sqlexception';
		END;

		/* Asignamos valor a varibles */
		SET Aud_FechaActual  	:= NOW();
		SET Var_FechaSis 	 	:= (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
									WHERE EmpresaID = Par_EmpresaID);
		SET Var_Consecutivo		:= Entero_Cero;

		SET Var_GraciaMoratorios:= (SELECT Pro.GraciaMoratorios FROM CREDITOS Cre
										INNER JOIN PRODUCTOSCREDITO	Pro ON 	Cre.ProductoCreditoID = Pro.ProducCreditoID
									WHERE  Cre.CreditoID =Par_CreditoID);

		SET Par_AcreditadoIDFIRA := IFNULL(Par_AcreditadoIDFIRA, Entero_Cero);
		SET Par_CreditoIDFIRA := IFNULL(Par_CreditoIDFIRA, Entero_Cero);

		/* validaciones*/
		IF(IFNULL(Par_CreditoID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 		:= 001;
			SET	Par_ErrMen 		:= 'El Numero de Credito Esta Vacio.';
			SET Var_Control  	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoGarantiaID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 		:= 002;
			SET	Par_ErrMen 		:= 'ElTipo de Garantia esta Vacia.';
			SET Var_Control  	:= 'tipoGarantiaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClienteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Cliente esta Vacio';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio';
			SET Var_Control := 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'La Fecha esta Vacia';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Fecha> Var_FechaSis)THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'La Fecha es Mayor a la del Sistema.';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Observacion,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 007;
			SET Par_ErrMen  := 'La Causa de Pago esta Vacia';
			SET Var_Control := 'observacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CreditoContFondeador, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El Credito Cont. Fondeador esta Vacio.';
			SET Var_Control := 'creditoContFondeador';
			LEAVE ManejoErrores;
		END IF;

		/*Calculos para obtener la fecha de atraso mas reciente y los dias transacurridos a la fecha*/
		SELECT MIN(Amo.FechaExigible)	INTO Var_FechaAtraso
			FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID = Par_CreditoID
					AND Amo.FechaExigible <= Var_FechaSis
					AND Amo.Estatus <> EstatusPagado;

		SET Var_FechaAtraso := IFNULL(Var_FechaAtraso, Fecha_Vacia);
		SET Var_FechaSisAnt := date_add(Var_FechaSis, INTERVAL -1 DAY);

		SELECT Sal.DiasAtraso INTO Var_DiasAtraso
			FROM SALDOSCREDITOS Sal
				WHERE  Sal.CreditoID =Par_CreditoID
					AND Sal.FechaCorte = Var_FechaSisAnt;

		SET Var_DiasAtraso := IFNULL(Var_DiasAtraso,Entero_Cero);
		SET Var_GraciaMoratorios := IFNULL(Var_GraciaMoratorios, Entero_Cero);

		/*Si no hay registro de los dias de atraso en saldoscreditos, se calculan*/
		IF( Var_DiasAtraso = Entero_Negativo)THEN
			SET Var_DiasAtraso := DATEDIFF(Var_FechaSis, Var_FechaAtraso);
		END IF;

		/*Considerar dias de gracia*/
		SET Var_DiasAtraso:= Var_DiasAtraso - Var_GraciaMoratorios;

		IF(Var_DiasAtraso<Entero_Cero)THEN
			SET Var_DiasAtraso:=Entero_Cero;
		END IF;
		
		INSERT INTO BITACORAAPLIGAR(
			TipoGarantiaID,			CreditoID,					CreditoFondeoID,		ClienteID,				CuentaAhoID,
			MontoGLApli,			PorcentajeApli,				MontoGarApli,			FechaAplica,			FechaAtraso,
			DiasAtraso,				CreditoContFondeador,		Observacion,			AcreditadoIDFIRA,		CreditoIDFIRA,
			EmpresaID,				UsuarioID,					FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES (
			Par_TipoGarantiaID,		Par_CreditoID,				Par_CreditoFondeoID, 	Par_ClienteID,			Par_CuentaAhoID,
			Par_MontoGL,			Par_PorcentajeGtia,			Par_MontoGarApli,		Par_Fecha,				Var_FechaAtraso,
			Var_DiasAtraso,			Par_CreditoContFondeador,	Par_Observacion, 		Par_AcreditadoIDFIRA,	Par_CreditoIDFIRA,
			Par_EmpresaID, 			Aud_Usuario,				Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal, 			Aud_NumTransaccion );

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Bitacora Registrada Exitosamente';
		SET Var_Consecutivo	:= Par_CreditoID;
		SET Var_Control		:= 'creditoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
				Par_NumErr          AS NumErr,
				Par_ErrMen          AS ErrMen,
				Var_Control         AS control,
				Var_Consecutivo     AS consecutivo;

	END IF;
END TerminaStore$$