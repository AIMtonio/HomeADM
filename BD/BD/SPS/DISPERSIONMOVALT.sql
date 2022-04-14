-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVALT`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOVALT`(
# =========================================================================
# ----------SP PARA DAR DE ALTA LOS DETALLES DE LAS DISPERSIONES-----------
# =========================================================================
    Par_FolioOperacion			INT(11),
    Par_CuentaAhoID				BIGINT(12),
    Par_CuentaContable			VARCHAR(25),
    Par_Descripcion				VARCHAR(50),
    Par_Referencia				VARCHAR(50),

    Par_TipoMov					CHAR(4),
    Par_FormaPago				INT(1),
    Par_Monto					DECIMAL(12,2),
    Par_CuentaClabe				VARCHAR(25),
    Par_NombreBenefi    		VARCHAR(250),

    Par_FechaEnvio				DATETIME,
    Par_RFC						VARCHAR(16),
    Par_Status					VARCHAR(2),
    Par_Salida					CHAR(1),
    Par_SucursalID				INT(11),

	Par_CreditoID 				BIGINT(12),
	Par_ProveedorID 			INT(11),
	Par_FacturaProvID 			VARCHAR(20),
	Par_DetReqGasID 			INT(11),
	Par_TipoGastoID 			INT(11),

	Par_CatalogoServID			INT(11),	/* ID de catalogo de servicios requerido solo para pagos de servicios*/
	Par_AnticipoFact			CHAR(1),
    Par_TipoChequera			CHAR(2),

    INOUT Par_NumErr	 		INT(11),
    INOUT Par_ErrMen	 		VARCHAR(400),
    INOUT Par_RegistroSalida	INT(11),

	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_Estatus				VARCHAR(1);
	DECLARE consecutivo 			INT(11);
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Var_Vacio				CHAR(1);
	DECLARE Tipo_ChequeIndividual 	CHAR(4);
	DECLARE Tipo_SpeiIndividual 	CHAR(4);
	DECLARE Tipo_Tarjeta			CHAR(4);
	DECLARE Cheque					INT(11);
	DECLARE FechaSis				DATE;
	DECLARE Var_CadenaCero			CHAR(1); 


	DECLARE Var_Control		VARCHAR(100);

	-- Asignacion de constantes
	SET Var_Estatus					:= '';
	SET Entero_Cero					:= 0;
	SET SalidaSi					:= 'S';
	SET SalidaNo					:= 'N';
	SET Var_Vacio					:= '';
	SET Cheque						:= 2;
	-- tipos de movimientos de la tabla TIPOSMOVTESO
	SET Tipo_ChequeIndividual		:= '4';
	SET Tipo_SpeiIndividual			:= '3';
	SET Tipo_Tarjeta				:='26';

	SET Var_CadenaCero				:= '0'; 


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONMOVALT');
				SET Var_Control := 'sqlexception';
			END;

		SET Par_CuentaContable 	:= IFNULL(Par_CuentaContable,Entero_Cero);
		SET Par_CuentaAhoID 	:= IFNULL(Par_CuentaAhoID,Entero_Cero);

        SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01') INTO FechaSis
				FROM PARAMETROSSIS;

		IF(IFNULL(Par_CuentaAhoID,Entero_Cero)>Entero_Cero)THEN

			IF YEAR(Par_FechaEnvio)<=YEAR(FechaSis)THEN
				IF(MONTH(Par_FechaEnvio)<MONTH(FechaSis))THEN
					SET Par_NumErr := 3;
					SET Par_ErrMen := 'El Mes no Puede ser Menor al del Sistema';
                    SET Var_Control:= 'fechaActual';
                    SET consecutivo:= Entero_Cero;
                    LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

       	IF( Par_TipoMov = Tipo_ChequeIndividual OR  Par_TipoMov = Tipo_SpeiIndividual OR Par_TipoMov=Tipo_Tarjeta) THEN
			IF(Par_CuentaContable IN (Entero_Cero, Var_Vacio, Var_CadenaCero) AND Par_CuentaAhoID = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'No ha elegido ninguna Cuenta';
				SET Var_Control:= 'CuentaAhoID';
				SET consecutivo:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			
			IF (Par_CuentaContable NOT IN( Var_Vacio , Entero_Cero, Var_CadenaCero)) THEN
					-- valida la Cuenta Constable
					CALL CUENTASCONTABLESVAL(	Par_CuentaContable,	SalidaNo,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
												Aud_NumTransaccion);
					-- Validamos la respuesta
					IF(Par_NumErr <> Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
			END IF;
		END IF;


		IF(IFNULL(Par_NombreBenefi,Var_Vacio)) = Var_Vacio THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'El Nombre de Beneficiario esta vacio.';
			SET Var_Control	:= 'nombreBenefi1';
			SET consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('DISPERSIONMOV', consecutivo);

		SET Aud_FechaActual := NOW();

		INSERT INTO DISPERSIONMOV(
			DispersionID,			CuentaCargo,		CuentaContable,		Descripcion,		Referencia,
			TipoMovDIspID,			FormaPago,			Monto,				CuentaDestino,		Identificacion,
			Estatus,				NombreBenefi,		FechaEnvio,			SucursalID,			EmpresaID,
			Usuario,				FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
			NumTransaccion,			ClaveDispMov, 		CreditoID,			ProveedorID,		FacturaProvID,
			DetReqGasID,			TipoGastoID,		CatalogoServID,		AnticipoFact,		TipoChequera)
		VALUES(
			Par_FolioOperacion,		Par_CuentaAhoID,	Par_CuentaContable,	Par_Descripcion,	Par_Referencia,
			Par_TipoMov,			Par_FormaPago,		Par_Monto,			Par_CuentaClabe,	Par_RFC,
			Par_Status,				Par_NombreBenefi, 	Par_FechaEnvio,  	Par_SucursalID,		Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion,		consecutivo,		Par_CreditoID,		Par_ProveedorID,	Par_FacturaProvID,
			Par_DetReqGasID,		Par_TipoGastoID,	Par_CatalogoServID, Par_AnticipoFact,	Par_TipoChequera);

		SET Par_NumErr 			:= 0;
		SET Par_ErrMen 			:= 'Datos insertados';
        SET Var_Control			:= 'CuentaAhoID';
		SET Par_RegistroSalida 	:= consecutivo;

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control,
			   		consecutivo AS consecutivo;
		END IF;

END TerminaStore$$
