-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOSACT`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOSACT`(
# ===============================================================================================
# -- STORED PROCEDURE PARA ACTUALIZAR EL ESTATUS DE UN ARRENDAMIENTO
# ===============================================================================================
	Par_ArrendaID		BIGINT(12),			-- ID del arrendamiento
	Par_NumAct			TINYINT UNSIGNED,	-- Indica el tipo de actualizacion

	Par_Salida			CHAR(1),			-- Indica si el SP genera o no una salida
	INOUT Par_NumErr	INT(11),			-- Parametro de salida que indica el num. de error
	INOUT Par_ErrMen	VARCHAR(400),		-- Parametro de salida que indica el mensaje de eror

	Par_EmpresaID		INT(11),			-- Parametros de Auditoria
	Aud_Usuario			INT(11),			-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control     	VARCHAR(50);		-- Variable de Control
	DECLARE Var_FechaApertura	DATE;				-- Fecha de apertura
	DECLARE Var_FechaSucursal	DATE;				-- Fecha de sucursal
	DECLARE Var_PagareImpreso	CHAR(1);			-- Indicasi se ha impreso el pagare
	DECLARE Var_SumSaldoCap		DECIMAL(14, 4);		-- Variable para el total del saldo capital
	DECLARE Var_SumSaldoInt		DECIMAL(14, 4);		-- Variable para el total del saldo de interes
	DECLARE Var_SumSeguro		DECIMAL(14, 4);		-- Variable para el total del seguro
	DECLARE Var_SumSeguroVida	DECIMAL(14, 4);		-- Variable para el total del seguro de vida
	DECLARE Var_SumSaldoSeguro	DECIMAL(14, 4);		-- Variable para el total del saldo de seguro
	DECLARE Var_SumMontoSeguro	DECIMAL(14, 4);		-- Variable para el total del saldo de seguro
	DECLARE Var_SumSaldoSegVid	DECIMAL(14, 4);		-- Variable para el total del saldo de seguro de vida
	DECLARE Var_SumMontoSegVid	DECIMAL(14, 4);		-- Variable para el total del Monto de seguro de vida
	DECLARE Var_SumOtComisi		DECIMAL(14, 4);		-- Variable para el total del otras comisiones
	DECLARE Var_SumMontoComisi	DECIMAL(14, 4);		-- Variable para el total del monto de otras comisiones

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Entero cero
	DECLARE Salida_Si			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Act_EstAutorizado	CHAR(1);			-- Actualizacion de estatus del producto a autorizado
	DECLARE Est_Autorizado		CHAR(1);			-- Estado autorizado
	DECLARE Act_EstVigente		CHAR(1);			-- Actualizacion de estatus del producto a vigente
	DECLARE Est_Vigente			CHAR(1);			-- Estatus vigente
	DECLARE Est_PagareImpreso	CHAR(1);			-- Estado cuando el pagara ya fue impreso
	DECLARE Est_PagImpresoNo	CHAR(1);			-- Estado cuando el pagara no ha sido impreso
	DECLARE Act_PagareImpreso	INT(11);			-- Actualizacion cuando el pagara ya fue impreso
	DECLARE Act_PagoInicial		INT(11);			-- Actualizacion de estatus de pago inicial
	DECLARE Est_PagoInicial		CHAR(1);			-- Estatus de pago inicial
	DECLARE Act_Saldos			INT(11);			-- Actualizacion de los saldos de un arrendamiento

	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Salida_Si				:= 'S';				-- El SP si genera una salida
	SET	Act_EstAutorizado		:= 1;				-- Tipo de act. para autorizar arrendamiento.
	SET Est_Autorizado			:= 'A';				-- Estado autorizado = A
	SET	Act_EstVigente			:= 3;				-- Tipo de act. para entrega de arrendamiento.
	SET Est_Vigente				:= 'V';				-- Estado vigente = V
	SET	Act_PagareImpreso		:= 2;				-- Actualizacion 2 para cambiar estatus de impresion de pagare
	SET Est_PagareImpreso		:= 'S';				-- Estatus S = pagara impreso
	SET Est_PagImpresoNo		:= 'N';				-- Estatus N = pagara no impreso
	SET	Act_PagoInicial			:= 4;				-- Actualizacion 4 para cambiar estatus de pago inicial
	SET	Est_PagoInicial			:= 'S';				-- Estatus de pago inicial = S
	SET Act_Saldos				:= 5;				-- Actualizacion 4 para cambiar los saldos del arrendamiento

	-- Valores por default
	SET Par_ArrendaID			:= IFNULL(Par_ArrendaID, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRENDAMIENTOSACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Actualizar el estatus de producto a autorizado
		IF(Par_NumAct = Act_EstAutorizado) THEN

		IF(Par_ArrendaID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Numero de producto esta vacio';
			SET Var_Control := 'Par_ArrendaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaApertura
		  INTO	Var_FechaApertura
			FROM ARRENDAMIENTOS
			WHERE	ArrendaID = Par_ArrendaID;

		SELECT	FechaSucursal
		  INTO	Var_FechaSucursal
			FROM SUCURSALES
			WHERE	SucursalID = Aud_Sucursal;

		SELECT	PagareImpreso
		  INTO	Var_PagareImpreso
			FROM ARRENDAMIENTOS
			WHERE	ArrendaID = Par_ArrendaID;

		IF((Par_NumAct = Act_EstAutorizado) AND (Var_FechaApertura < Var_FechaSucursal)) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La fecha de apertura es menor que la fecha de sistema';
			SET Var_Control := 'Var_FechaApertura';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_NumAct = Act_EstAutorizado) AND (Var_PagareImpreso = Est_PagImpresoNo)) THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'Pagare no impreso';
			SET Var_Control := 'Var_PagareImpreso';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_NumAct = Act_EstVigente) AND (Var_FechaApertura != Var_FechaSucursal)) THEN
			SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'La fecha de apertura no corresponde con la fecha de sistema';
			SET Var_Control := 'Var_FechaApertura';
			LEAVE ManejoErrores;
		END IF;

			UPDATE ARRENDAMIENTOS SET
				Estatus		 	= Est_Autorizado,
				FechaAutoriza	= Aud_FechaActual,
				UsuarioAutoriza = Aud_Usuario,

				EmpresaID	 	= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ArrendaID = Par_ArrendaID;

			-- El registro se actualizo exitosamente.
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Arrendamiento autorizado exitosamente';
			SET Var_Control := 'ArrendaID';

		END IF;

		-- Actualizacion de estatus cuando el pagare ya fue impreso.
		 IF(Par_NumAct = Act_PagareImpreso) THEN
			IF(Par_ArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Numero de producto esta vacio';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	FechaApertura
			INTO	Var_FechaApertura
				FROM ARRENDAMIENTOS
				WHERE	ArrendaID = Par_ArrendaID;

			SELECT	FechaSucursal
			INTO	Var_FechaSucursal
				FROM SUCURSALES
				WHERE	SucursalID = Aud_Sucursal;

			SELECT	PagareImpreso
			INTO	Var_PagareImpreso
				FROM ARRENDAMIENTOS
				WHERE	ArrendaID = Par_ArrendaID;

			IF((Par_NumAct = Act_EstAutorizado) AND (Var_FechaApertura < Var_FechaSucursal)) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'La fecha de apertura es menor que la fecha de sistema';
				SET Var_Control := 'Var_FechaApertura';
				LEAVE ManejoErrores;
			END IF;

			IF((Par_NumAct = Act_EstAutorizado) AND (Var_PagareImpreso = Est_PagImpresoNo)) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'Pagare no impreso';
				SET Var_Control := 'Var_PagareImpreso';
				LEAVE ManejoErrores;
			END IF;

			IF((Par_NumAct = Act_EstVigente) AND (Var_FechaApertura != Var_FechaSucursal)) THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= 'La fecha de apertura no corresponde con la fecha de sistema';
				SET Var_Control := 'Var_FechaApertura';
				LEAVE ManejoErrores;
			END IF;

			UPDATE ARRENDAMIENTOS SET
				PagareImpreso 	= Est_PagareImpreso,

				EmpresaID	 	= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	ArrendaID = Par_ArrendaID
			  AND	PagareImpreso = Est_PagImpresoNo;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Actualizacion de Estatus de Impresion de Pagare Exitosa.';
			SET Var_Control := 'ArrendaID';
		END IF;
		-- Fin Actualizacion de estatus cuando el pagare ya fue impreso.

		-- Actualizar el estatus de producto a vigente
		IF(Par_NumAct = Act_EstVigente) THEN
			IF(Par_ArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Numero de producto esta vacio';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	FechaApertura
			INTO	Var_FechaApertura
				FROM ARRENDAMIENTOS
				WHERE	ArrendaID = Par_ArrendaID;

			SELECT	FechaSucursal
			INTO	Var_FechaSucursal
				FROM SUCURSALES
				WHERE	SucursalID = Aud_Sucursal;

			SELECT	PagareImpreso
			INTO	Var_PagareImpreso
				FROM ARRENDAMIENTOS
				WHERE	ArrendaID = Par_ArrendaID;

			IF((Par_NumAct = Act_EstAutorizado) AND (Var_FechaApertura < Var_FechaSucursal)) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'La fecha de apertura es menor que la fecha de sistema';
				SET Var_Control := 'Var_FechaApertura';
				LEAVE ManejoErrores;
			END IF;

			IF((Par_NumAct = Act_EstAutorizado) AND (Var_PagareImpreso = Est_PagImpresoNo)) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'Pagare no impreso';
				SET Var_Control := 'Var_PagareImpreso';
				LEAVE ManejoErrores;
			END IF;

			IF((Par_NumAct = Act_EstVigente) AND (Var_FechaApertura != Var_FechaSucursal)) THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= 'La fecha de apertura no corresponde con la fecha de sistema';
				SET Var_Control := 'Var_FechaApertura';
				LEAVE ManejoErrores;
			END IF;

			UPDATE ARRENDAAMORTI SET
				Estatus				= Est_Vigente,
				SaldoCapVigent		= CapitalRenta,
				SaldoInteresVigente	= InteresRenta,
				SaldoSeguro			= Seguro,
				SaldoSeguroVida		= SeguroVida,

				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ArrendaID = Par_ArrendaID;

			SELECT	SUM(SaldoCapVigent)
			  INTO	Var_SumSaldoCap
				FROM ARRENDAAMORTI
				WHERE	ArrendaID = Par_ArrendaID;

			SELECT	SUM(SaldoInteresVigente)
			  INTO	Var_SumSaldoInt
				FROM ARRENDAAMORTI
				WHERE	ArrendaID = Par_ArrendaID;

			SELECT	SUM(SaldoSeguro)
			  INTO	Var_SumSeguro
				FROM ARRENDAAMORTI
				WHERE	ArrendaID = Par_ArrendaID;

			SELECT	SUM(SaldoSeguroVida)
			  INTO	Var_SumSeguroVida
				FROM ARRENDAAMORTI
				WHERE	ArrendaID = Par_ArrendaID;

			SET Var_SumSaldoCap		:= IFNULL(Var_SumSaldoCap, Entero_Cero);
			SET Var_SumSaldoInt		:= IFNULL(Var_SumSaldoInt, Entero_Cero);
			SET Var_SumSeguro		:= IFNULL(Var_SumSeguro, Entero_Cero);
			SET Var_SumSeguroVida	:= IFNULL(Var_SumSeguroVida, Entero_Cero);

			UPDATE ARRENDAMIENTOS SET
				Estatus		 		= Est_Vigente,
				SaldoCapVigente		= Var_SumSaldoCap,
				SaldoInteresVigent	= Var_SumSaldoInt,
				SaldoSeguro			= Var_SumSeguro,
				SaldoSeguroVida		= Var_SumSeguroVida,

				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ArrendaID = Par_ArrendaID;

			-- El registro se actualizo exitosamente.
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Arrendamiento entregado exitosamente';
			SET Var_Control := 'ArrendaID';
		END IF;

		-- Actualizacion de estatus del pago inicial
		 IF(Par_NumAct = Act_PagoInicial) THEN
			IF(Par_ArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Numero de Arrendamiento no es valido';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(	SELECT ArrendaID
								FROM ARRENDAMIENTOS
								WHERE ArrendaID = Par_ArrendaID)) THEN
				SET Par_NumErr		:= 002;
				SET Par_ErrMen		:= 'El Arrendamiento no existe';
				SET Var_Control		:= 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE ARRENDAMIENTOS SET
				EsPagoInicial 	= Est_PagoInicial,

				EmpresaID	 	= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	ArrendaID = Par_ArrendaID;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Estatus de Pago Inicial actualizado exitosamente.';
			SET Var_Control := 'ArrendaID';
		END IF;

		-- Actualizar el valores de producto
		IF(Par_NumAct = Act_Saldos) THEN

			IF(Par_ArrendaID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Numero de producto esta vacio';
				SET Var_Control := 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(	SELECT ArrendaID
								FROM ARRENDAMIENTOS
								WHERE ArrendaID = Par_ArrendaID)) THEN
				SET Par_NumErr		:= 002;
				SET Par_ErrMen		:= 'El Producto no existe';
				SET Var_Control		:= 'Par_ArrendaID';
				LEAVE ManejoErrores;
			END IF;


			SELECT 	SUM(SaldoSeguro), 			SUM(MontoIVASeguro), 	SUM(SaldoSeguroVida),
					SUM(MontoIVASeguroVida), 	SUM(SaldoOtrasComis), 	SUM(MontoIVAComisi)
			  INTO	Var_SumSaldoSeguro,			Var_SumMontoSeguro,		Var_SumSaldoSegVid,
					Var_SumMontoSegVid,			Var_SumOtComisi,		Var_SumMontoComisi
			  FROM ARRENDAAMORTI
			  WHERE ArrendaID = Par_ArrendaID;




			UPDATE ARRENDAMIENTOS SET
				SaldoSeguro				= Var_SumSaldoSeguro,
				MontoIVASeguro			= Var_SumMontoSeguro,
				SaldoSeguroVida			= Var_SumSaldoSegVid,
				MontoIVASeguroVida		= Var_SumMontoSegVid,
				SaldoOtrasComis			= Var_SumOtComisi,
				MontoIVAComisi			= Var_SumMontoComisi,

				EmpresaID	 			= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual 			= Aud_FechaActual,
				DireccionIP 			= Aud_DireccionIP,
				ProgramaID  			= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE ArrendaID 			= Par_ArrendaID;

			-- El registro se actualizo exitosamente.
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Arrendamiento actualizado exitosamente';
			SET Var_Control := 'ArrendaID';

		END IF;

	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Par_ArrendaID AS consecutivo;
	END IF;

END TerminaStore$$