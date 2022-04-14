-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOSALT`;

DELIMITER $$
CREATE PROCEDURE `ACTIVOSALT`(
	# =====================================================================================
	# ------- STORED PARA ALTA DE ACTIVOS ---------
	# =====================================================================================
	Par_TipoActivoID		INT(11), 		-- Idetinficador del tipo de activo
	Par_Descripcion			VARCHAR(300), 	-- Descripcion del activo
	Par_FechaAdquisicion 	DATE, 			-- Fecha de Adquisicion
	Par_ProveedorID			INT(11), 		-- ID  de proveedor
	Par_NumFactura			VARCHAR(50), 	-- Numero de factura

	Par_NumSerie			VARCHAR(100), 	-- Numero de serie
	Par_Moi					DECIMAL(16,2), 	-- Monto Original Inversion(MOI)
	Par_DepreciadoAcumu		DECIMAL(16,2),	-- Depreciado Acumulado
	Par_TotalDepreciar		DECIMAL(16,2),	-- Total por Depreciar
	Par_MesesUsos			INT(11), 		-- Meses de Uso

	Par_PolizaFactura		BIGINT(12), 	-- Poliza Factura
	Par_CentroCostoID		INT(11), 		-- ID de centro de costos
	Par_CtaContable			VARCHAR(50), 	-- Cuenta Contable Depreciacion
	Par_CtaContableRegistro	VARCHAR(50), 	-- Cuenta Contable Registro
	Par_Estatus				CHAR(2), 		-- Indica el estatus del activo, VI=VIGENTE, BA=BAJA, VE=VENDIDO

	Par_TipoRegistro		CHAR(1),		-- Indica cual fue el tipo de registro del activo, A=automatico o M=manual',
	Par_SucursalID			INT(11),		-- ID de sucursal donde se da de alta el activo
	Par_PorDepFiscal		 DECIMAL(14,2),	-- Porcentaje de depreciación fiscal para el activo.
	Par_DepFiscalSaldoInicio DECIMAL(14,2),	-- Saldo inicial de acuerdo a la depreciación fiscal.
	Par_DepFiscalSaldoFin	 DECIMAL(14,2),	-- Saldo final de acuerdo a la depreciación fiscal.

	Par_FechaRegistro		DATE,			-- Fecha de Registro del Activo
	INOUT Par_ActivoID		INT(11), 		-- Idetinficador del activo

	Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo			INT(14);		-- Variable consecutivo
	DECLARE Var_FolioTipoActivo		CHAR(11);		-- Consecutivo Interno
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Control
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema


	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Cero			INT(1);				-- Constante Entero cero
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Salida_SI			CHAR(1);			-- Parametro de salida SI

	DECLARE Salida_NO			CHAR(1);			-- Parametro de salida NO
	DECLARE Cons_NO				CHAR(1);			-- Constante NO
	DECLARE Grupo_Detalle		CHAR(1);			-- Cuenta contable grupo detalle
	DECLARE Reg_ProMasivo		CHAR(1);			-- Registro Proceso masivo
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo

	DECLARE Reg_Automatico		CHAR(1);			-- Registro Proceso Automatico
	DECLARE Llave_CentroCostoActivo	VARCHAR(50);	-- Centro de Costo por Defecto
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Cons_NO					:= 'N';
	SET Grupo_Detalle			:= 'D';
	SET Reg_ProMasivo			:= 'P';
	SET Est_Activo				:= 'A';

	SET Reg_Automatico			:= 'A';
	SET Llave_CentroCostoActivo := 'DefatulCentroCostoActivos';
	SET Decimal_Cero			:= 0.0;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ACTIVOSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Entero_Cero;
		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID) THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'No existe el Tipo de Activo';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Est_Activo <> ( SELECT Estatus FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID ) )THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:='El Tipo de Activo esta Inactivo.</b>';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Descripcion esta Vacia';
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAdquisicion, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Fecha de Adquisicion esta Vacia';
			SET Var_Control		:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAdquisicion, Fecha_Vacia) > Var_FechaSistema ) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Fecha de Adquisicion es Mayor a la Fecha del Sistema';
			SET Var_Control		:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoRegistro <> Reg_ProMasivo ) THEN
			IF NOT EXISTS(SELECT ProveedorID FROM PROVEEDORES WHERE ProveedorID = Par_ProveedorID) THEN
				SET Par_NumErr 		:= 4;
				SET Par_ErrMen 		:= 'No existe el Proveedor';
				SET Var_Control		:= 'proveedorID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumFactura, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr 		:= 5;
				SET Par_ErrMen 		:= 'El Numero de Factura esta Vacio';
				SET Var_Control		:= 'numFactura';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PolizaFactura, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 		:= 10;
				SET Par_ErrMen 		:= 'La Poliza Factura esta Vacia';
				SET Var_Control		:= 'polizaFactura';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Moi, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= 'El Monto Original Inversion esta Vacio';
			SET Var_Control		:= 'moi';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DepreciadoAcumu, Decimal_Cero) > Par_Moi) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El Monto Depresiado Acumulado no puede ser mayor al MOI';
			SET Var_Control		:= 'depreciadoAcumulado';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TotalDepreciar, Decimal_Cero) > Par_Moi) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'El Total por Depreciar no puede ser mayor al MOI';
			SET Var_Control		:= 'totalDepreciar';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MesesUsos, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'Los Meses de Uso esta Vacio';
			SET Var_Control		:= 'mesesUso';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoRegistro = Reg_ProMasivo ) THEN
			SET Par_CentroCostoID := IFNULL(Par_CentroCostoID, Entero_Cero);
			IF( Par_CentroCostoID = Entero_Cero ) THEN
				SET Par_CentroCostoID := IFNULL(FNPARAMGENERALES(Llave_CentroCostoActivo), Entero_Cero);
			END IF;
		END IF;

		IF(IFNULL(Par_CentroCostoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 11;
			SET Par_ErrMen 		:= 'El Centro de Costos esta Vacio';
			SET Var_Control		:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CentroCostoID FROM CENTROCOSTOS WHERE CentroCostoID = Par_CentroCostoID) THEN
			SET Par_NumErr 		:= 14;
			SET Par_ErrMen 		:= 'El Centro de Costos no Existe';
			SET Var_Control		:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CtaContable, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 12;
			SET Par_ErrMen 		:= 'La Cuenta Contable esta Vacia';
			SET Var_Control		:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 13;
			SET Par_ErrMen 		:= 'El estatus esta Vacio';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta =Par_CtaContable AND Grupo = Grupo_Detalle ) THEN
			SET Par_NumErr 		:= 15;
			SET Par_ErrMen 		:= CONCAT('La Cuenta Contable ',Par_CtaContable,' no es de Detalle o no Existe.');
			SET Var_Control		:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_DepreciadoAcumu + Par_TotalDepreciar) > Par_Moi) THEN
			SET Par_NumErr 		:= 16;
			SET Par_ErrMen 		:= 'La suma del Depreciado acumulado mas el Total por Depreciar, NO puede ser mayor al MOI.';
			SET Var_Control		:= 'moi';
			LEAVE ManejoErrores;
		END IF;

		SET Par_PorDepFiscal		 := IFNULL(Par_PorDepFiscal, Decimal_Cero);
		SET Par_DepFiscalSaldoInicio := IFNULL(Par_DepFiscalSaldoInicio, Decimal_Cero);
		SET Par_DepFiscalSaldoFin	 := IFNULL(Par_DepFiscalSaldoFin, Decimal_Cero);
		SET Par_NumSerie			:= IFNULL(Par_NumSerie, Cadena_Vacia);
		SET Par_CtaContableRegistro	:= IFNULL(Par_CtaContableRegistro, Cadena_Vacia);

		IF( Par_TipoRegistro NOT IN (Reg_Automatico, Reg_ProMasivo )) THEN
			IF( Par_PorDepFiscal <= Decimal_Cero ) THEN
				SET Par_NumErr 	:= 17;
				SET Par_ErrMen 	:= 'Porcentaje de depreciación fiscal para el activo. esta Vacio.';
				SET Var_Control	:= 'porDepFiscal';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_DepFiscalSaldoInicio <= Decimal_Cero ) THEN
				SET Par_NumErr 	:= 18;
				SET Par_ErrMen 	:= 'Saldo inicial de acuerdo a la depreciación fiscal esta Vacio.';
				SET Var_Control	:= 'depFiscalSaldoInicio';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_DepFiscalSaldoFin < Decimal_Cero ) THEN
				SET Par_NumErr 	:= 19;
				SET Par_ErrMen 	:= 'Saldo final de acuerdo a la depreciación fiscal esta Vacio.';
				SET Var_Control	:= 'depFiscalSaldoFin';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_ActivoID := (SELECT IFNULL(MAX(ActivoID),Entero_Cero) + Entero_Uno FROM ACTIVOS);
		SET Aud_FechaActual := NOW();

		IF( Par_TipoRegistro = Reg_ProMasivo ) THEN

			IF( IFNULL(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia) THEN
				SET Par_NumErr 	:= 20;
				SET Par_ErrMen 	:= 'La fecha de Registro es incorrecta';
				SET Var_Control	:= 'fechaRegistro';
				LEAVE ManejoErrores;
			END IF;

			SET Par_FechaRegistro := IFNULL(Par_FechaRegistro, Var_FechaSistema);
			SET Var_FechaSistema := Par_FechaRegistro;
		END IF;

		CALL FOLIOSACTIVOSPRO (
			Par_TipoActivoID,	Var_FechaSistema,	Var_FolioTipoActivo,
			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_FolioTipoActivo := IFNULL(Var_FolioTipoActivo, Cadena_Vacia );
		IF( Var_FolioTipoActivo = Cadena_Vacia ) THEN
			SET Par_NumErr 	:= 21;
			SET Par_ErrMen 	:= 'El consecutivo asignado al Activo no es valido.';
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO ACTIVOS (
			ActivoID, 			TipoActivoID,	 	Descripcion, 				FechaAdquisicion, 		ProveedorID,
			NumFactura, 		NumSerie, 			Moi, 						DepreciadoAcumulado, 	TotalDepreciar,
			MesesUso, 			PolizaFactura, 		CentroCostoID, 				CtaContable, 			CtaContableRegistro,
			Estatus,			TipoRegistro,		FechaRegistro,				EsDepreciado,			SucursalID,
			NumeroConsecutivo,	PorDepFiscal,		DepFiscalSaldoInicio,		DepFiscalSaldoFin,
			EmpresaID, 			Usuario, 			FechaActual, 				DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion)
		VALUES (
			Par_ActivoID,		Par_TipoActivoID,	Par_Descripcion,			Par_FechaAdquisicion,	Par_ProveedorID,
			Par_NumFactura,		Par_NumSerie,		Par_Moi,					Par_DepreciadoAcumu,	Par_TotalDepreciar,
			Par_MesesUsos,		Par_PolizaFactura,	Par_CentroCostoID,			Par_CtaContable,		Par_CtaContableRegistro,
			Par_Estatus,		Par_TipoRegistro,	Var_FechaSistema,			Cons_NO,				Par_SucursalID,
			Var_FolioTipoActivo,Par_PorDepFiscal,	Par_DepFiscalSaldoInicio,	Par_DepFiscalSaldoFin,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- ALTA BITACORA DE DEPRECIACION
		CALL BITACORADEPREAMORTIPRO(
			Par_ActivoID,		Par_TipoActivoID,		Par_FechaAdquisicion,	Par_ProveedorID,	Par_NumFactura,
			Par_Moi,			Par_DepreciadoAcumu,	Par_TotalDepreciar,		Par_MesesUsos,		Par_PolizaFactura,
			Entero_Uno,			Var_FechaSistema,
			Salida_NO,			Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('Activo Agregado Exitosamente:',CAST(Par_ActivoID AS CHAR) );
		SET Var_Control		:= 'activoID';
		SET Var_Consecutivo	:= Par_ActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$