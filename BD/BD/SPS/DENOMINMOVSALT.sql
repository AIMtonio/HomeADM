-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DENOMINMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DENOMINMOVSALT`;DELIMITER $$

CREATE PROCEDURE `DENOMINMOVSALT`(



    Par_SucursalID      	INT(11),
    Par_CajaID          	INT(11),
    Par_Fecha           	DATE,
    Par_Transaccion     	BIGINT,
    Par_Naturaleza      	INT,

    Par_DenominacionID  	INT,
    Par_Cantidad        	DECIMAL(14,2),
    Par_Monto           	DECIMAL(14,2),
    Par_MonedaID        	INT,
    Par_AltaEncPoliza   	CHAR(1),

    Par_Instrumento     	VARCHAR(20),
    Par_Referencia      	VARCHAR(200),
    Par_EmpresaID       	INT,
    Par_DesMovCaja      	VARCHAR(150),
	Par_ClienteID			INT(11),

    Var_Poliza        		BIGINT,
    INOUT Par_Consecutivo  	BIGINT,

    Par_Salida          	CHAR(1),
	INOUT Par_NumErr       	INT,
	INOUT Par_ErrMen       	VARCHAR(400),


	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT
		)
TerminaStore: BEGIN


	DECLARE Var_EstatusCaja     	CHAR(1);
	DECLARE Var_FechaSistema    	DATE;
	DECLARE Var_TipoDenom       	CHAR(1);
	DECLARE Var_Cargos          	DECIMAL(14,2);
	DECLARE Var_Abonos          	DECIMAL(14,2);
	DECLARE Var_SucursalCaja    	INT;
	DECLARE Var_EstatusOpera    	CHAR(1);
	DECLARE Var_SaldoEfecMN     	DECIMAL(14,2);
	DECLARE Var_SaldoEfecME     	DECIMAL(14,2);
	DECLARE Var_MonedaBaseID    	INT;
	DECLARE Var_CantidBalanza   	DECIMAL(14,2);
	DECLARE Var_SucursalOrigenCte 	INT(11);
	DECLARE Var_MaximoRetiro		DECIMAL(14,2);
	DECLARE Var_LimiteEfectivoMN	DECIMAL(14,2);
	DECLARE Var_LimiteDesemMN		DECIMAL(14,2);
	DECLARE Var_Monto				DECIMAL(14,2);
	DECLARE Var_Control				VARCHAR(100);


	DECLARE Cadena_Vacia	  		CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12, 2);

	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Salida_NO    			CHAR(1);
	DECLARE Salida_SI    			CHAR(1);
	DECLARE AltaPoliza_SI   		CHAR(1);
	DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE Mov_Entrada     		INT;
	DECLARE Mov_Salida      		INT;
	DECLARE Pol_Automatica  		CHAR(1);
	DECLARE Coc_MovCaja     		INT;
	DECLARE Den_Billete     		CHAR(1);
	DECLARE Den_Moneda      		CHAR(1);
	DECLARE Con_Divisa     			INT;
	DECLARE Act_Saldo       		INT;
	DECLARE Des_MovCaja     		VARCHAR(50);
	DECLARE EstO_Cerrado			CHAR(1);


	SET Cadena_Vacia   				:= '';
	SET Fecha_Vacia     			:= '1900-01-01';
	SET Entero_Cero     			:= 0;
	SET Decimal_Cero    			:= 0.00;
	SET Esta_Activo     			:= 'A';

	SET Salida_NO    				:= 'N';
	SET Salida_SI    				:= 'S';
	SET AltaPoliza_SI   			:= 'S';
	SET AltaPoliza_NO   			:= 'N';
	SET Mov_Entrada     			:= 1;
	SET Mov_Salida      			:= 2;
	SET Pol_Automatica  			:= 'A';
	SET Coc_MovCaja     			:= 30;
	SET Con_Divisa      			:= 1;
	SET Den_Billete     			:= 'B';
	SET Den_Moneda      			:= 'M';
	SET Act_Saldo       			:= 1;
	SET Des_MovCaja     			:= 'MOVIMIENTO DE EFECTIVO EN CAJA';
	SET EstO_Cerrado				:= 'C';
	SET Aud_FechaActual 			:= NOW();

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DENOMINMOVSALT');
				SET Var_Control = 'sqlException';
			END;

		SELECT	FechaSistema, 		MonedaBaseID
		  INTO	Var_FechaSistema, 	Var_MonedaBaseID
		  FROM PARAMETROSSIS;

		SELECT	Estatus,    		SucursalID,			EstatusOpera,		LimiteEfectivoMN,		SaldoEfecMN,
				MaximoRetiroMN,		LimiteDesemMN
		  INTO 	Var_EstatusCaja, 	Var_SucursalCaja,	Var_EstatusOpera,	Var_LimiteEfectivoMN,	Var_SaldoEfecMN,
				Var_MaximoRetiro,	Var_LimiteDesemMN
		  FROM CAJASVENTANILLA
		 WHERE	SucursalID	= Par_SucursalID
		   AND	CajaID		= Par_CajaID;

		SELECT SucursalOrigen INTO Var_SucursalOrigenCte
		  FROM CLIENTES
		 WHERE	ClienteID	= Par_ClienteID;


		SET Var_SucursalOrigenCte 	:= IFNULL(Var_SucursalOrigenCte, Entero_Cero);
		SET Var_EstatusCaja 		:= IFNULL(Var_EstatusCaja, Cadena_Vacia);

		SELECT IFNULL(SUM(Monto),0) INTO Var_Monto
		  FROM DENOMINACIONMOVS
		 WHERE	Transaccion	= Par_Transaccion;


		SET Var_Monto:=  Par_Monto+Var_Monto;



		IF(Var_EstatusCaja != Esta_Activo) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'La Caja no Existe o no se Encuentra Activa.';
			SET Var_Control		:= 'cajaID';
			SET Par_Consecutivo	:= Entero_cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_EstatusOpera, Cadena_Vacia)) = EstO_Cerrado THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'La Caja se encuentra Cerrada.';
			SET Var_Control		:= 'caja';
			SET Par_Consecutivo := Entero_cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero)) <= Decimal_Cero THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'Monto del Movimiento Menor o Igual a Cero.';
			SET Var_Control		:= 'monto';
			SET Par_Consecutivo	:= Entero_cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DesMovCaja, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_DesMovCaja := Des_MovCaja;
		END IF;


        SELECT TipoDenominacion INTO Var_TipoDenom
		  FROM DENOMINACIONES
		 WHERE	DenominacionID = Par_DenominacionID
		   AND	MonedaID       = Par_MonedaID;


		IF(IFNULL(Var_TipoDenom, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'La Denominacion no Existe.';
			SET Var_Control		:= 'monto';
			SET Par_Consecutivo := Entero_cero;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Naturaleza = Mov_Salida) THEN
			SELECT  Caj.SaldoEfecMN, Caj.SaldoEfecMN INTO Var_SaldoEfecMN, Var_SaldoEfecME
			  FROM CAJASVENTANILLA Caj
			 WHERE	SucursalID = Par_SucursalID
			   AND	CajaID     = Par_CajaID;

			SET Var_SaldoEfecMN := IFNULL(Var_SaldoEfecMN, Entero_Cero);
			SET Var_SaldoEfecME := IFNULL(Var_SaldoEfecME, Entero_Cero);

			IF(Par_DenominacionID = Var_MonedaBaseID) THEN
				IF(Var_SaldoEfecMN < Par_Monto) THEN
					SET Par_NumErr		:= 007;
					SET Par_ErrMen		:='Saldo de la Caja Insuficiente.';
					SET Var_Control		:='monto';
					SET Par_Consecutivo := Entero_cero;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF(Var_SaldoEfecME < Par_Monto) THEN
					SET Par_NumErr		:= 008;
					SET Par_ErrMen      := 'Saldo de la Caja Insuficiente.';
					SET Var_Control		:= 'monto';
					SET Par_Consecutivo := Entero_cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SELECT Bal.Cantidad INTO Var_CantidBalanza
			  FROM BALANZADENOM Bal
			 WHERE SucursalID     = Par_SucursalID
			   AND CajaID         = Par_CajaID
			   AND DenominacionID = Par_DenominacionID
			   AND MonedaID       = Par_MonedaID;

			SET Var_CantidBalanza   := IFNULL(Var_CantidBalanza, Entero_Cero);

			IF(Var_CantidBalanza < Par_Cantidad) THEN
				SET Par_NumErr		:= 009;
				SET Par_ErrMen		:= 'La Caja no Cuenta con el Saldo en la Denominacion Especificada.';
				SET Var_Control		:= 'monto';
				SET Par_Consecutivo := Entero_cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT INTO DENOMINACIONMOVS(
			SucursalID,     CajaID,         Fecha,          Transaccion,    Naturaleza,
			DenominacionID, Cantidad,       Monto,          MonedaID,       EmpresaID,
			Usuario,        FechaActual,    DireccionIP,    ProgramaID,     Sucursal,
			NumTransaccion)
	    VALUES(
			Var_SucursalCaja,	Par_CajaID,         Par_Fecha,          Par_Transaccion,    Par_Naturaleza,
			Par_DenominacionID, Par_Cantidad,       Par_Monto,          Par_MonedaID,       Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);


		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			SET Var_Poliza:=0;
			CALL MAESTROPOLIZASALT(
					Var_Poliza,			Par_EmpresaID,  	Var_FechaSistema,   Pol_Automatica,     Coc_MovCaja,
					Par_DesMovCaja,		Salida_NO,   		Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF (Par_Naturaleza = Mov_Entrada) THEN
			SET Var_Cargos  := Par_Monto;
			SET Var_Abonos  := Decimal_Cero;
		ELSE
			SET Var_Cargos  := Decimal_Cero;
			SET Var_Abonos  := Par_Monto;
		END IF;


		CALL  POLIZASDIVISAPRO(
			Var_Poliza,         Par_SucursalID, 	Par_CajaID,     Par_EmpresaID,  		Var_FechaSistema,
			Var_TipoDenom,      Con_Divisa,     	Par_MonedaID,   Var_Cargos,     		Var_Abonos,
			Par_Instrumento,    Par_DesMovCaja, 	Par_Referencia, Var_SucursalOrigenCte,	Salida_NO,
			Par_NumErr,			Par_ErrMen,			Aud_Usuario,   	Aud_FechaActual,    	Aud_DireccionIP,
			Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL BALANZASDENOMACT(
			Par_SucursalID,     Par_CajaID,     Par_DenominacionID, 	Par_MonedaID,       Par_Cantidad,
			Par_Naturaleza,     Act_Saldo,      Salida_NO,				Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    	Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;



		CALL CAJASVENTANILLASACT(
			Par_SucursalID,		Par_CajaID,     	Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,
			Fecha_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,		Par_MonedaID,
			Par_Monto,			Decimal_Cero,		Decimal_Cero,		Par_Naturaleza,   	Cadena_Vacia,
			Act_Saldo,      	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
			Aud_NumTransaccion );

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Movimiento de Efectivo Realizado';
		SET Par_Consecutivo := Var_Poliza;

	END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr 		AS NumErr,
					Par_ErrMen	 	AS ErrMen,
					Var_Control	 	AS control,
					Par_Consecutivo	AS consecutivo;
		END IF;

END TerminaStore$$