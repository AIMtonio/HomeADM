-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGSERVICIOALT`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGSERVICIOALT`(
	-- Stored procedure para dar de alta la configuracion de un servicio en linea
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

	Par_NumAlt 						INT(11), 				-- Numero de alta

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
	DECLARE Est_Activo 				CHAR(1);				-- Estatus activo
	DECLARE Var_AltPrincipal 		TINYINT;				-- Alta de la configuracion del servicio
	DECLARE Var_AltValDef 			TINYINT;				-- Alta de la configuracion del servicio con valores por defecto

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11); 				-- Variable consecutivo
	DECLARE Var_TipoServicioID 		INT(11); 				-- ID del tipo de servicio
	DECLARE Var_ServicioID 			INT(11); 				-- ID del tipo de servicio

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI 						:= 'S';					-- Asignacion de salida si
	SET Var_NO 						:= 'N';					-- Asignacion de salida no
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Var_AltValDef 				:= 1; 					-- Alta de la configuracion del servicio con valores por defecto


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
				SET Par_NumErr := 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCONFIGSERVICIOALT');
			END;

		IF(Par_NumAlt = Var_AltValDef) THEN
			IF(Par_ServicioID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'ID del servicio no valido.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ClasificacionServ = Cadena_Vacia) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'Clasificacion del servicio no valido.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT ServicioID INTO Var_ServicioID
				FROM PSLCONFIGSERVICIO
				WHERE ServicioID = Par_ServicioID
				AND ClasificacionServ = Par_ClasificacionServ;

			IF(Var_ServicioID IS NOT NULL) THEN
				SET Par_NumErr	:= 5;
				SET Par_ErrMen	:= 'El servicio ya se encuentra registrado.';
				SET Var_Consecutivo := Par_ServicioID;
				LEAVE ManejoErrores;
			END IF;

			INSERT INTO PSLCONFIGSERVICIO (	ServicioID,				ClasificacionServ,		CContaServicio,			CContaComision,			CContaIVAComisi,
											NomenclaturaCC,			VentanillaAct,			CobComVentanilla,		MtoCteVentanilla,		MtoUsuVentanilla,
											BancaLineaAct,			CobComBancaLinea,		MtoCteBancaLinea,		BancaMovilAct,			CobComBancaMovil,
											MtoCteBancaMovil,		Estatus, 				EmpresaID,				Usuario,				FechaActual,
											DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion
				)
				VALUES (					Par_ServicioID,			Par_ClasificacionServ,	Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
											Cadena_Vacia,			Var_NO,					Var_NO,					Entero_Cero,			Entero_Cero,
											Var_NO,					Var_NO,					Entero_Cero, 			Var_NO,					Var_NO,
											Entero_Cero,			Est_Activo,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
											Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
				);

			-- El registro se inserto exitosamente
			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Servicio registrado correctamente';
			SET Var_Consecutivo := Par_ServicioID;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 1;
		SET Par_ErrMen		:= 'Opcion de alta no valida';
		SET Var_Consecutivo := Par_ServicioID;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'servicioID' 	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$