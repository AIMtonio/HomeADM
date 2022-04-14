-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGSERVICIOMOD`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGSERVICIOMOD`(
	-- Store procedure para modificar la configuracion de un Servicio en Linea
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_CContaServicio 				CHAR(25),		 		-- Cuenta contable para el cobro servicio.
	Par_CContaComision				CHAR(25),		 		-- Cuenta contable para las comisiones por el cobro servicio.
	Par_CContaIVAComisi				CHAR(25),		 		-- Cuenta contable para el IVA de la comision por el servicio.
	Par_NomenclaturaCC 				VARCHAR(3),		 		-- Nomenclatura del centro de costo,

	Par_VentanillaAct 				CHAR(1), 				-- Canal de ventanilla activa (S = SI, N = NO),
	Par_CobComVentanilla			CHAR(1), 				-- Cobrar comision por el uso del servicio en ventanilla (S = SI, N = NO),
	Par_MtoCteVentanilla 			DECIMAL(14,2), 			-- Monto de comision a clientes por el uso del servicio en ventanilla,
	Par_MtoUsuVentanilla 			DECIMAL(14,2), 			-- Monto de comision a usuarios por el uso del servicio en ventanilla,

	Par_BancaLineaAct 				CHAR(1), 			 	-- Canal de Banca en linea activa (S = SI, N = NO),
	Par_CobComBancaLinea			CHAR(1), 				-- Cobrar de comision por uso del servicio en Banca en linea (S = SI, N = NO),
	Par_MtoCteBancaLinea 			DECIMAL(14,2), 			-- Monto de comision a clientes por el uso del servicio,

	Par_BancaMovilAct 				CHAR(1), 				-- Canal de Banca movil activa (S = SI, N = NO),
	Par_CobComBancaMovil			CHAR(1), 				-- Cobrar de comision por uso del servicio en Banca movil (S = SI, N = NO),
	Par_MtoCteBancaMovil 			DECIMAL(14,2), 			-- Monto de comision a clientes por el uso del servicio en banca movil,

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_SI 					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO 					CHAR(1);				-- Variable con valor no

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11); 				-- Variable consecutivo
	DECLARE Var_ServicioID 			INT(11); 				-- ID del servicio
	DECLARE Var_TipoServicioID 		INT(11); 				-- ID del tipo de servicio
	DECLARE Var_CContaServicio 		VARCHAR(25);		 	-- Cuenta contable para el cobro servicio.
	DECLARE Var_CContaComision		VARCHAR(25);		 	-- Cuenta contable para las comisiones por el cobro servicio.
	DECLARE Var_CContaIVAComisi		VARCHAR(25);		 	-- Cuenta contable para el IVA de la comision por el servicio.
	DECLARE Var_Control 			VARCHAR(50); 			-- Nombre del control.

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI 						:= 'S';					-- Asignacion de salida si
	SET Var_NO 						:= 'N';					-- Asignacion de salida no


	-- Valores por default
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_ClasificacionServ 		:= IFNULL(Par_ClasificacionServ, Entero_Cero);
	SET Par_CContaServicio 			:= IFNULL(Par_CContaServicio, Cadena_Vacia);
	SET Par_CContaComision 			:= IFNULL(Par_CContaComision, Cadena_Vacia);
	SET Par_CContaIVAComisi 		:= IFNULL(Par_CContaIVAComisi, Cadena_Vacia);
	SET Par_NomenclaturaCC 			:= IFNULL(Par_NomenclaturaCC, Cadena_Vacia);

	SET Par_VentanillaAct 			:= IFNULL(Par_VentanillaAct, Cadena_Vacia);
	SET Par_CobComVentanilla 		:= IFNULL(Par_CobComVentanilla, Cadena_Vacia);
	SET Par_MtoCteVentanilla 		:= IFNULL(Par_MtoCteVentanilla, Decimal_Cero);
	SET Par_MtoUsuVentanilla 		:= IFNULL(Par_MtoUsuVentanilla, Decimal_Cero);

	SET Par_BancaLineaAct 			:= IFNULL(Par_BancaLineaAct, Cadena_Vacia);
	SET Par_CobComBancaLinea 		:= IFNULL(Par_CobComBancaLinea, Cadena_Vacia);
	SET Par_MtoCteBancaLinea 		:= IFNULL(Par_MtoCteBancaLinea, Decimal_Cero);

	SET Par_BancaMovilAct 			:= IFNULL(Par_BancaMovilAct, Cadena_Vacia);
	SET Par_CobComBancaMovil 		:= IFNULL(Par_CobComBancaMovil, Cadena_Vacia);
	SET Par_MtoCteBancaMovil 		:= IFNULL(Par_MtoCteBancaMovil, Decimal_Cero);

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
    SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
    SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCONFIGSERVICIOMOD');
			END;


		IF(Par_ServicioID = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'ID del servicio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'ServicioID';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_ClasificacionServ = Cadena_Vacia) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'Clasificacion del servicio no valido.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'nomClasificacion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CContaServicio = Cadena_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'Cuenta contable del Servicio no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaServicio';
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CuentaCompleta
			INTO 	Var_CContaServicio
			FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CContaServicio;

		SET Var_CContaServicio = IFNULL(Var_CContaServicio, Cadena_Vacia);

		IF(Var_CContaServicio = Cadena_Vacia) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'No se encontro la cuenta contable del Servicio.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaServicio';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_CContaComision = Cadena_Vacia) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Cuenta contable de la comision por el cobro de servicios no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaComision';
			LEAVE ManejoErrores;
		END IF;


		SELECT 		CuentaCompleta
			INTO 	Var_CContaComision
			FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CContaComision;

		SET Var_CContaComision = IFNULL(Var_CContaComision, Cadena_Vacia);

		IF(Var_CContaComision = Cadena_Vacia) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'No se encontro la contable de la comision.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaComision';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CContaIVAComisi = Cadena_Vacia) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Cuenta contable del IVA de la comision por el cobro de servicios no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaIVAComisi';
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CuentaCompleta
			INTO 	Var_CContaIVAComisi
			FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CContaIVAComisi;

		SET Var_CContaIVAComisi = IFNULL(Var_CContaIVAComisi, Cadena_Vacia);

		IF(Var_CContaIVAComisi = Cadena_Vacia) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'No se encontro la contable del IVA por Comision.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'cContaIVAComisi';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NomenclaturaCC = Cadena_Vacia) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'Nomenclatura del centro de costo no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'nomenclaturaCC';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_VentanillaAct NOT IN (Var_SI, Var_NO) ) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'Parametro de ventanilla activa no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'ventanillaAct';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_VentanillaAct = Var_SI) THEN
			IF(Par_CobComVentanilla NOT IN (Var_SI, Var_NO)) THEN
				SET Par_NumErr	:= 10;
				SET Par_ErrMen	:= 'Parametro de cobrar comision en ventanilla no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'cobComVentanilla';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MtoCteVentanilla < Decimal_Cero) THEN
				SET Par_NumErr	:= 11;
				SET Par_ErrMen	:= 'Monto de comision a clientes en ventanilla no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'mtoCteVentanilla';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MtoUsuVentanilla < Decimal_Cero) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= 'Monto de comision a usuarios en ventanilla no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'mtoUsuVentanilla';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_BancaLineaAct NOT IN (Var_SI, Var_NO) ) THEN
			SET Par_NumErr	:= 13;
			SET Par_ErrMen	:= 'Parametro de banca en linea activa no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'bancaLineaAct';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_BancaLineaAct = Var_SI) THEN
			IF(Par_CobComBancaLinea NOT IN (Var_SI, Var_NO)) THEN
				SET Par_NumErr	:= 14;
				SET Par_ErrMen	:= 'Parametro de cobrar comision en banca en linea no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'cobComBancaLinea';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MtoCteBancaLinea < Decimal_Cero) THEN
				SET Par_NumErr	:= 15;
				SET Par_ErrMen	:= 'Monto de comision a clientes en banca en linea no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'mtoCteBancaLinea';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_BancaMovilAct NOT IN (Var_SI, Var_NO) ) THEN
			SET Par_NumErr	:= 16;
			SET Par_ErrMen	:= 'Parametro de banca movil activa no valida.';
			SET Var_Consecutivo := Entero_Cero;
			SET Var_Control := 'bancaMovilAct';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_BancaMovilAct = Var_SI) THEN
			IF(Par_CobComBancaMovil NOT IN (Var_SI, Var_NO)) THEN
				SET Par_NumErr	:= 17;
				SET Par_ErrMen	:= 'Parametro de cobrar comision en banca movil no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'cobComBancaMovil';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MtoCteBancaMovil < Decimal_Cero) THEN
				SET Par_NumErr	:= 18;
				SET Par_ErrMen	:= 'Monto de comision a clientes en banca movil no valida.';
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'mtoCteBancaMovil';
				LEAVE ManejoErrores;
			END IF;
		END IF;



		UPDATE PSLCONFIGSERVICIO
			SET 	CContaServicio 		= Par_CContaServicio,
					CContaComision 		= Par_CContaComision,
					CContaIVAComisi 	= Par_CContaIVAComisi,
					NomenclaturaCC 		= Par_NomenclaturaCC,

					VentanillaAct 		= Par_VentanillaAct,
					CobComVentanilla 	= Par_CobComVentanilla,
					MtoCteVentanilla 	= Par_MtoCteVentanilla,
					MtoUsuVentanilla 	= Par_MtoUsuVentanilla,

					BancaLineaAct 		= Par_BancaLineaAct,
					CobComBancaLinea 	= Par_CobComBancaLinea,
					MtoCteBancaLinea 	= Par_MtoCteBancaLinea,

					BancaMovilAct 		= Par_BancaMovilAct,
					CobComBancaMovil 	= Par_CobComBancaMovil,
					MtoCteBancaMovil 	= Par_MtoCteBancaMovil,

					EmpresaID 			= Aud_EmpresaID,
					Usuario 			= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID 			= Aud_ProgramaID,
					Sucursal 			= Aud_Sucursal,
					NumTransaccion 		= Aud_NumTransaccion
			WHERE ServicioID = Par_ServicioID
			AND ClasificacionServ = Par_ClasificacionServ;

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Servicio actualizado correctamente';
		SET Var_Consecutivo := Par_ServicioID;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   Var_Control 		AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$