-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOSMOD`;

DELIMITER $$
CREATE PROCEDURE `ACTIVOSMOD`(
	# =====================================================================================
	# ------- STORED PARA MODIFICACION DE ACTIVOS ---------
	# =====================================================================================
	Par_ActivoID			INT(11), 		-- Idetinficador del activo
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
	Par_CtaContable			VARCHAR(50), 	-- Cuenta Contable
	Par_Estatus				CHAR(2), 		-- Indica el estatus del activo, VI=VIGENTE, BA=BAJA, VE=VENDIDO

	Par_TipoRegistro		CHAR(1),		-- Indica cual fue el tipo de registro del activo, A=automatico o M=manual',
	Par_PorDepFiscal		 DECIMAL(14,2),	-- Porcentaje de depreciación fiscal para el activo.
	Par_DepFiscalSaldoInicio DECIMAL(14,2),	-- Saldo inicial de acuerdo a la depreciación fiscal.
	Par_DepFiscalSaldoFin	 DECIMAL(14,2),	-- Saldo final de acuerdo a la depreciación fiscal.

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

	-- DECLARACION DE VARIABLES

	DECLARE Var_Consecutivo		INT(14);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_EsDepreciado	CHAR(1);
	DECLARE Var_FechaRegistro	DATE;
 	DECLARE Var_PorDepFiscal	DECIMAL(16,2);	-- Porcentaje de Depreciacion Fiscal
	DECLARE Var_NumMeses		INT(11);			-- Numero de Meses

	-- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Entero_Dos      	INT(11);      		-- Entero Dos
	DECLARE Cons_SI 			CHAR(1);
	DECLARE Cons_NO 			CHAR(1);
	DECLARE Reg_ProMasivo		CHAR(1);			-- Registro Proceso masivo
	DECLARE Reg_Automatico		CHAR(1);			-- Registro Proceso Automatico

	DECLARE Est_Baja			CHAR(2);
	DECLARE Llave_PorDepFiscalActivos	VARCHAR(50);	-- Porcentaue Depreciacion Fical para Activo
	DECLARE Llave_CentroCostoActivo		VARCHAR(50);	-- Centro de Costo por Defecto

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Entero_Dos          	:= 2;
	SET Cons_SI 				:= 'S';
	SET Cons_NO 				:= 'N';
	SET Reg_ProMasivo			:= 'P';
	SET Reg_Automatico			:= 'A';

	SET Est_Baja 				:= 'BA';
	SET Llave_PorDepFiscalActivos	:= 'MaxPorDepFiscalActivos';
	SET Llave_CentroCostoActivo 	:= 'DefatulCentroCostoActivos';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ACTIVOSMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Entero_Cero;
		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF NOT EXISTS(SELECT ActivoID FROM ACTIVOS WHERE ActivoID = Par_ActivoID) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'No existe el Activo';
			SET Var_Control		:= 'activoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'No existe el Tipo de Activo';
			SET Var_Control		:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Descripcion esta Vacia';
			SET Var_Control		:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAdquisicion, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Fecha de Adquisicion esta Vacia';
			SET Var_Control		:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAdquisicion, Fecha_Vacia) > Var_FechaSistema ) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Fecha de Adquisicion es Mayor a la Fecha del Sistema';
			SET Var_Control		:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoRegistro <> Reg_ProMasivo ) THEN

			IF NOT EXISTS(SELECT ProveedorID FROM PROVEEDORES WHERE ProveedorID = Par_ProveedorID) THEN
				SET Par_NumErr 		:= 5;
				SET Par_ErrMen 		:= 'No existe el Proveedor';
				SET Var_Control		:= 'proveedorID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumFactura, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr 		:= 6;
				SET Par_ErrMen 		:= 'El Numero de Factura esta Vacio';
				SET Var_Control		:= 'numFactura';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PolizaFactura, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 		:= 11;
				SET Par_ErrMen 		:= 'La Poliza Factura esta Vacia';
				SET Var_Control		:= 'polizaFactura';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Moi, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El Monto Original Inversion esta Vacio';
			SET Var_Control		:= 'moi';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DepreciadoAcumu, Decimal_Cero) > Par_Moi) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'El Monto Depresiado Acumulado no puede ser mayor al MOI';
			SET Var_Control		:= 'depreciadoAcumulado';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TotalDepreciar, Decimal_Cero) > Par_Moi) THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'El Total por Depreciar no puede ser mayor al MOI';
			SET Var_Control		:= 'totalDepreciar';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MesesUsos, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 10;
			SET Par_ErrMen 		:= 'Los Meses de Uso esta Vacio';
			SET Var_Control		:= 'mesesUso';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CentroCostoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 12;
			SET Par_ErrMen 		:= 'El Centro de Costos esta Vacio';
			SET Var_Control		:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CtaContable, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 13;
			SET Par_ErrMen 		:= 'La Cuenta Contable esta Vacia';
			SET Var_Control		:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 14;
			SET Par_ErrMen 		:= 'El estatus esta Vacio';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CentroCostoID FROM CENTROCOSTOS WHERE CentroCostoID = Par_CentroCostoID) THEN
			SET Par_NumErr 		:= 15;
			SET Par_ErrMen 		:= 'El Centro de Costos no Existe';
			SET Var_Control		:= 'centroCostoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta =Par_CtaContable AND Grupo ='D' ) THEN
			SET Par_NumErr 		:= 16;
			SET Par_ErrMen 		:= 'La Cuenta Contable no es de Detalle o no Existe.';
			SET Var_Control		:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_DepreciadoAcumu + Par_TotalDepreciar) > Par_Moi) THEN
			SET Par_NumErr 		:= 17;
			SET Par_ErrMen 		:= 'La suma del Depreciado acumulado mas el Total por Depreciar, NO puede ser mayor al MOI.';
			SET Var_Control		:= 'moi';
			LEAVE ManejoErrores;
		END IF;

		SET Par_PorDepFiscal		 := IFNULL(Par_PorDepFiscal, Decimal_Cero);
		SET Par_DepFiscalSaldoInicio := IFNULL(Par_DepFiscalSaldoInicio, Decimal_Cero);
		SET Par_DepFiscalSaldoFin	 := IFNULL(Par_DepFiscalSaldoFin, Decimal_Cero);

		IF( Par_TipoRegistro NOT IN (Reg_Automatico, Reg_ProMasivo )) THEN

			IF( Par_PorDepFiscal <= Decimal_Cero ) THEN
				SET Par_NumErr 	:= 18;
				SET Par_ErrMen 	:= 'Porcentaje de depreciación fiscal para el activo. esta Vacio.';
				SET Var_Control	:= 'porDepFiscal';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_DepFiscalSaldoInicio <= Decimal_Cero ) THEN
				SET Par_NumErr 	:= 19;
				SET Par_ErrMen 	:= 'Saldo inicial de acuerdo a la depreciación fiscal esta Vacio.';
				SET Var_Control	:= 'depFiscalSaldoInicio';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_DepFiscalSaldoFin < Decimal_Cero ) THEN
				SET Par_NumErr 	:= 20;
				SET Par_ErrMen 	:= 'Saldo final de acuerdo a la depreciación fiscal esta Vacio.';
				SET Var_Control	:= 'depFiscalSaldoFin';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_PorDepFiscal := IFNULL(FNPARAMGENERALES(Llave_PorDepFiscalActivos), Decimal_Cero);
		IF( Par_PorDepFiscal > Var_PorDepFiscal ) THEN
			SET Par_NumErr	:= 21;
			SET Par_ErrMen	:= CONCAT('El Porcentaje de depreciación fiscal supera lo parametrizado: ',Var_PorDepFiscal);
			SET Var_Control	:= 'porDepFiscal';
			LEAVE ManejoErrores;
		END IF;

		SELECT MesesUso
		INTO Var_NumMeses
		FROM ACTIVOS
		WHERE ActivoID = Par_ActivoID;

		SET Var_NumMeses := IFNULL(Var_NumMeses, Entero_Cero);

		SET Var_EsDepreciado := (SELECT EsDepreciado FROM ACTIVOS WHERE ActivoID = Par_ActivoID);
		SET Var_EsDepreciado := IFNULL(Var_EsDepreciado, Cons_NO);

		IF(Var_EsDepreciado = Cons_SI) THEN
			IF(Par_MesesUsos != Var_NumMeses ) THEN
				SET Par_NumErr	:= 22;
				SET Par_ErrMen	:= 'No es posible modificar los Meses Ya que se ha Despreciado el Activo.';
				SET Var_Control	:= 'mesesUso';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE ACTIVOS SET
			TipoActivoID		= Par_TipoActivoID,
			Descripcion			= Par_Descripcion,
			FechaAdquisicion	= Par_FechaAdquisicion,
			ProveedorID			= Par_ProveedorID,
			NumFactura			= Par_NumFactura,

			NumSerie			= Par_NumSerie,
			Moi					= Par_Moi,
			DepreciadoAcumulado	= Par_DepreciadoAcumu,
			TotalDepreciar		= Par_TotalDepreciar,
			MesesUso			= Par_MesesUsos,

			PolizaFactura		= Par_PolizaFactura,
			CentroCostoID		= Par_CentroCostoID,
			CtaContable			= Par_CtaContable,
			Estatus				= Par_Estatus,
			TipoRegistro		= Par_TipoRegistro,

			PorDepFiscal		= Par_PorDepFiscal,
			DepFiscalSaldoInicio = Par_DepFiscalSaldoInicio,
			DepFiscalSaldoFin	= Par_DepFiscalSaldoFin,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE ActivoID = Par_ActivoID;

		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- SI EL ACTIVO NO SE HA DEPRECIADO SE CREA LA BITACORA DE DEPRECIACION DEL ACTIVO
		IF(Var_EsDepreciado = Cons_NO)THEN
			SET Var_FechaRegistro := (SELECT FechaRegistro FROM ACTIVOS WHERE ActivoID = Par_ActivoID);

			-- ALTA BITACORA DE DEPRECIACION
			CALL BITACORADEPREAMORTIPRO(
				Par_ActivoID,		Par_TipoActivoID,	Par_FechaAdquisicion,	Par_ProveedorID,	Par_NumFactura,
				Par_Moi,			Par_DepreciadoAcumu,Par_TotalDepreciar,		Par_MesesUsos,		Par_PolizaFactura,
				Entero_Dos,			Var_FechaRegistro,
				Salida_NO,    		Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 		Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- CUANDO SE CAMBIA EL ESTATUS DEL ACTIVO A BAJA- EL ACTIVO SE DEPRECIARA POR EL TOTAL QUE FALTA POR DEPRECIAR
		IF(Par_Estatus = Est_Baja)THEN

			-- SE REALIZA UN REGISTRO POR EL TOTAL FALTANTE A DEPRECIAR, SE ELIMINAN LOS MESES FALTANTES POR DEPRECIAR
			CALL ACTIVOSBAJAPRO(
				Par_ActivoID,		Par_TipoActivoID,	Par_FechaAdquisicion,	Par_Moi,			Par_DepreciadoAcumu,
				Par_TotalDepreciar,	Var_EsDepreciado,	Var_FechaSistema,
				Salida_NO,    		Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 		Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		CALL VALIDAOPEACTIVOSBAJ(
				Par_ActivoID,		Salida_NO,    		Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Activo Modificado Exitosamente:',CAST(Par_ActivoID AS CHAR) );
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