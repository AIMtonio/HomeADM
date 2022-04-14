-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOLAYOUTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOLAYOUTPRO`;

DELIMITER $$
CREATE PROCEDURE `ACTIVOLAYOUTPRO`(
	-- Store Procedure de Carga Masiva de Activos
	-- Modulo: Activos --> Registro --> Carga Masiva
	Par_ConsecutivoID 		INT(11),		-- Numero de Registro SAFI
	Par_RegistroID			INT(11),		-- Numero de Registro Cliente
	Par_TransaccionID		BIGINT(20),		-- Numero de Transaccion
	Par_SucursalID			INT(11),		-- ID de sucursal donde se da de alta el activo
	Par_TipoActivoID		INT(11), 		-- Idetinficador del tipo de activo

	Par_Descripcion			VARCHAR(300), 	-- Descripcion del activo
	Par_FechaAdquisicion 	DATE, 			-- Fecha de Adquisicion
	Par_NumFactura			VARCHAR(50), 	-- Numero de factura
	Par_NumSerie			VARCHAR(100), 	-- Numero de serie
	Par_Moi					DECIMAL(16,2), 	-- Monto Original Inversion(MOI)

	Par_DepreciadoAcumulado	DECIMAL(16,2),	-- Depreciado Acumulado
	Par_TotalDepreciar		DECIMAL(16,2),	-- Total por Depreciar
	Par_MesesUsos			INT(11), 		-- Meses de Uso
	Par_PolizaFactura		BIGINT(12), 	-- Poliza Factura
	Par_CentroCostoID		INT(11), 		-- ID de centro de costos

	Par_CtaContable			VARCHAR(25), 	-- Cuenta Contable Depreciacion
	Par_CtaContableRegistro	VARCHAR(50), 	-- Cuenta Contable Registro
	Par_PorDepFiscal		DECIMAL(16,2),	-- Porcentaje de depreciación fiscal para el activo.
	Par_DepFiscalSaldoInicio DECIMAL(16,2),	-- Saldo inicial de acuerdo a la depreciación fiscal.
	Par_DepFiscalSaldoFin	DECIMAL(16,2),	-- Saldo final de acuerdo a la depreciación fiscal.

	Par_FechaRegistro		DATE, 			-- Fecha de Adquisicion
	Par_NumProceso			TINYINT UNSIGNED,-- Numero de Proceso

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_TextoError				TEXT;			-- Texto de Error
	DECLARE Var_FechaAdquisicion		DATE;			-- Fecha de Adquisición del Activo
	DECLARE Var_MaxRegistroID			INT(11);		-- Numero Maximo de Registro
	DECLARE Var_Contador				INT(11);		-- Numero de Contador
	DECLARE Var_NumExitos				INT(11);		-- Numero de Registros Exitosos

	DECLARE Var_NumFallos				INT(11);		-- Numero de Registros Fallidos
	DECLARE Var_ActivoID 				INT(11);		-- Numero de Activo
	DECLARE Var_TipoActivoID			INT(11);		-- ID de TIPOSACTIVOS
	DECLARE Var_MesesUsos				INT(11);		-- Meses a amortizar del activo
	DECLARE Var_CentroCostoID			INT(11);		-- Centro de Costo

	DECLARE Var_NumeroError				INT(11);		-- Numero de Errores
	DECLARE Var_RegistroID				INT(11);		-- Numero de Registro
	DECLARE Var_SucursalID				INT(11);		-- Numero de Sucursal
	DECLARE Var_NumConsecutivo			INT(11);		-- Numero de Numero de Consecutivo

	DECLARE Var_Moi						DECIMAL(16,2);	-- Monto Original Inversion(MOI)
	DECLARE Var_DepreciadoAcumulado		DECIMAL(16,2);	-- Depreciado Acumulado
	DECLARE Var_TotalDepreciar			DECIMAL(16,2);	-- Total por Depreciar
	DECLARE Var_PorDepFiscal			DECIMAL(16,2);	-- Porcentaje de Depreciacion Fiscal
	DECLARE Var_DepFiscalSaldoInicio	DECIMAL(16,2);	-- Depreciacion Fiscal Inicial

	DECLARE Var_DepFiscalSaldoFin		DECIMAL(16,2);	-- Depreciacion Fiscal Final
	DECLARE Var_CuentaContable			CHAR(25);		-- Cuenta Contable
	DECLARE Var_CtaContableRegistro		CHAR(25);		-- Cuenta Contable registro
	DECLARE Var_NumFactura				VARCHAR(50);	-- Numero de factura
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Control

	DECLARE Var_NumSerie				VARCHAR(100);	-- Numero de serie
	DECLARE Var_Descripcion				VARCHAR(300);	-- Descripcion larga del tipo de activo
	DECLARE Var_PolizaFactura			BIGINT(12);		-- Poliza Factura
	DECLARE Var_TransaccionID			BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_Consecutivo				BIGINT(20);		-- Numero de Consecutivo

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante de salida SI

	DECLARE Salida_NO			CHAR(1);			-- Constante de salida NO
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Reg_ProMasivo		CHAR(1);			-- Registro Proceso masivo
	DECLARE Est_Vigente			CHAR(2);			-- Constante Vigente
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero

	-- Declaracion de Actualizaciones
	DECLARE Pro_ValidaLayout	TINYINT UNSIGNED;	-- Proceso de Validacion de Layout
	DECLARE Pro_AltaLayout		TINYINT UNSIGNED;	-- Proceso de Validacion de Layout

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Reg_ProMasivo			:= 'P';
	SET Est_Vigente				:= 'VI';
	SET Decimal_Cero			:= 0.0;

	-- Asignacion de Actualizaciones
	SET Pro_ValidaLayout		:= 1;
	SET Pro_AltaLayout			:= 2;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ACTIVOLAYOUTPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_TransaccionID	:= IFNULL(Par_TransaccionID, Entero_Cero);
		SET Par_RegistroID		:= IFNULL(Par_RegistroID, Entero_Cero);
		SET Par_SucursalID		:= IFNULL(Par_SucursalID, Entero_Cero);

		IF( Par_TransaccionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Transaccion esta Vacio.';
			SET Var_Control	:= 'transaccionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_RegistroID = Entero_Cero ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero Consecutivo del Cliente esta Vacio.';
			SET Var_Control	:= 'registroID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ConsecutivoID := IFNULL(Par_ConsecutivoID, Entero_Cero);
		IF( Par_ConsecutivoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Numero Consecutivo de SAFI Vacio.';
			SET Var_Control	:= 'consecutivoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumProceso = Pro_ValidaLayout ) THEN

			SET Par_TipoActivoID			:= IFNULL(Par_TipoActivoID, Entero_Cero);
			SET Par_Descripcion				:= IFNULL(Par_Descripcion, Cadena_Vacia);
			SET Par_FechaAdquisicion		:= IFNULL(Par_FechaAdquisicion, Fecha_Vacia);

			SET Par_NumFactura				:= IFNULL(Par_NumFactura, Cadena_Vacia);
			SET Par_NumSerie				:= IFNULL(Par_NumSerie, Cadena_Vacia);
			SET Par_Moi						:= IFNULL(Par_Moi, Decimal_Cero);
			SET Par_DepreciadoAcumulado		:= IFNULL(Par_DepreciadoAcumulado, Decimal_Cero);
			SET Par_TotalDepreciar			:= IFNULL(Par_TotalDepreciar, Decimal_Cero);

			SET Par_MesesUsos				:= IFNULL(Par_MesesUsos, Entero_Cero);
			SET Par_PolizaFactura			:= IFNULL(Par_PolizaFactura, Entero_Cero);
			SET Par_CentroCostoID			:= IFNULL(Par_CentroCostoID, Entero_Cero);
			SET Par_CtaContable				:= IFNULL(Par_CtaContable, Cadena_Vacia);
			SET Par_CtaContableRegistro		:= IFNULL(Par_CtaContableRegistro, Cadena_Vacia);

			SET Par_PorDepFiscal			:= IFNULL(Par_PorDepFiscal, Decimal_Cero);
			SET Par_DepFiscalSaldoInicio	:= IFNULL(Par_DepFiscalSaldoInicio, Decimal_Cero);
			SET Par_DepFiscalSaldoFin		:= IFNULL(Par_DepFiscalSaldoFin, Decimal_Cero);

			CALL ACTIVOLAYOUTVAL(
				Par_ConsecutivoID,			Par_RegistroID,		Par_TransaccionID,			Par_TipoActivoID,		Par_Descripcion,
				Par_FechaAdquisicion,		Par_NumFactura,		Par_NumSerie,				Par_Moi,				Par_DepreciadoAcumulado,
				Par_TotalDepreciar,			Par_MesesUsos,		Par_PolizaFactura,			Par_CentroCostoID,		Par_CtaContable,
				Par_CtaContableRegistro,	Par_PorDepFiscal,	Par_DepFiscalSaldoInicio,	Par_DepFiscalSaldoFin,
				Salida_NO,					Par_NumErr,			Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(MAX(RegistroID), Entero_Cero) + Entero_Uno
			INTO Var_RegistroID
			FROM TMPACTIVOS
			WHERE TransaccionID = Par_TransaccionID
			FOR UPDATE;

			SET Aud_FechaActual := NOW();
			INSERT INTO TMPACTIVOS (
				RegistroID,					TransaccionID,		ConsecutivoCliente,			TipoActivoID,			Descripcion,
				FechaAdquisicion,			NumFactura,			NumSerie,					Moi,					DepreciadoAcumulado,
				TotalDepreciar,				MesesUsos,			PolizaFactura,				CentroCostoID,			CuentaContable,
				CuentaContableRegistro,		PorDepFiscal,		DepFiscalSaldoInicio,		DepFiscalSaldoFin,
				EmpresaID,					Usuario,			FechaActual,				DireccionIP,			ProgramaID,
				Sucursal,					NumTransaccion)
			VALUES (
				Var_RegistroID,				Par_TransaccionID,	Par_RegistroID,				Par_TipoActivoID,		Par_Descripcion,
				Par_FechaAdquisicion,		Par_NumFactura,		Par_NumSerie,				Par_Moi,				Par_DepreciadoAcumulado,
				Par_TotalDepreciar,			Par_MesesUsos,		Par_PolizaFactura,			Par_CentroCostoID,		Par_CtaContable,
				Par_CtaContableRegistro,	Par_PorDepFiscal,	Par_DepFiscalSaldoInicio,	Par_DepFiscalSaldoFin,
				Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Proceso de Validacion Realizado Exitosamente:',CAST(Var_RegistroID AS CHAR));
			SET Var_Control	:= 'transaccionID';
			SET Var_Consecutivo := Var_RegistroID;
			LEAVE ManejoErrores;

		END IF;

		-- Alta del Layout
		IF( Par_NumProceso = Pro_AltaLayout ) THEN

			SELECT	TransaccionID
			INTO	Var_TransaccionID
			FROM TMPACTIVOS
			WHERE TransaccionID = Par_TransaccionID
			LIMIT Entero_Uno;

			IF( IFNULL(Var_TransaccionID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'El Numero de Transaccion no es Valido para la Operacion.';
				SET Var_Control	:= 'transaccionID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	RegistroID
			INTO	Var_RegistroID
			FROM TMPACTIVOS
			WHERE RegistroID = Par_ConsecutivoID
			  AND TransaccionID = Par_TransaccionID
			  AND ConsecutivoCliente = Par_RegistroID;

			IF( IFNULL(Var_RegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 4;
				SET Par_ErrMen	:= 'El Numero de Consecutivo Asociado a la Transaccion no Existe.';
				SET Var_Control	:= 'registroID';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_SucursalID = Entero_Cero ) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'El Numero de Sucursal esta Vacio.';
				SET Var_Control	:= 'registroID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	SucursalID
			INTO	Var_SucursalID
			FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID;

			IF( IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 5;
				SET Par_ErrMen	:= 'El Numero de Sucursal no Existe.';
				SET Var_Control	:= 'registroID';
				LEAVE ManejoErrores;
			END IF;

			SET Par_TipoActivoID			:= IFNULL(Par_TipoActivoID, Entero_Cero);
			SET Par_Descripcion				:= IFNULL(Par_Descripcion, Cadena_Vacia);
			SET Par_FechaAdquisicion		:= IFNULL(Par_FechaAdquisicion, Fecha_Vacia);
			SET Par_NumFactura				:= IFNULL(Par_NumFactura, Cadena_Vacia);

			SET Par_NumSerie				:= IFNULL(Par_NumSerie, Cadena_Vacia);
			SET Par_Moi						:= IFNULL(Par_Moi, Decimal_Cero);
			SET Par_DepreciadoAcumulado		:= IFNULL(Par_DepreciadoAcumulado, Decimal_Cero);
			SET Par_TotalDepreciar			:= IFNULL(Par_TotalDepreciar, Decimal_Cero);
			SET Par_MesesUsos				:= IFNULL(Par_MesesUsos, Entero_Cero);

			SET Par_PolizaFactura			:= IFNULL(Par_PolizaFactura, Entero_Cero);
			SET Par_CentroCostoID			:= IFNULL(Par_CentroCostoID, Entero_Cero);
			SET Par_CtaContable				:= IFNULL(Par_CtaContable, Cadena_Vacia);
			SET Par_CtaContableRegistro		:= IFNULL(Par_CtaContableRegistro, Cadena_Vacia);

			SET Par_PorDepFiscal			:= IFNULL(Par_PorDepFiscal, Decimal_Cero);
			SET Par_DepFiscalSaldoInicio	:= IFNULL(Par_DepFiscalSaldoInicio, Decimal_Cero);
			SET Par_DepFiscalSaldoFin		:= IFNULL(Par_DepFiscalSaldoFin, Decimal_Cero);
			SET Par_FechaRegistro			:= IFNULL(Par_FechaRegistro, Fecha_Vacia);

			SET Aud_FechaActual := NOW();
			CALL ACTIVOSALT (
				Par_TipoActivoID,	Par_Descripcion,		Par_FechaAdquisicion,		Entero_Cero,				Par_NumFactura,
				Par_NumSerie,		Par_Moi,				Par_DepreciadoAcumulado,	Par_TotalDepreciar,			Par_MesesUsos,
				Par_PolizaFactura,	Par_CentroCostoID,		Par_CtaContable,			Par_CtaContableRegistro,	Est_Vigente,
				Reg_ProMasivo,		Par_SucursalID,			Par_PorDepFiscal,			Par_DepFiscalSaldoInicio,	Par_DepFiscalSaldoFin,
				Par_FechaRegistro,	Var_ActivoID,
				Salida_NO,			Par_NumErr,				Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT RegistroID,			Act.ActivoID
			INTO Var_NumConsecutivo,	Var_ActivoID
			FROM ACTIVOS Act
			INNER JOIN RELACIONCTIVOS Rel ON Act.ActivoID = Rel.ActivoID
			INNER JOIN TIPOSACTIVOS Tip ON Act.TipoActivoID = Tip.TipoActivoID
			WHERE Act.TipoActivoID = Par_TipoActivoID
			  AND Rel.RegistroID = Par_RegistroID
			LIMIT Entero_Uno;

			SET Var_NumConsecutivo := IFNULL(Var_NumConsecutivo, Entero_Cero);
			SET Var_ActivoID 	 	:= IFNULL(Var_ActivoID, Entero_Cero);

			-- Validacion de Tipo de Activo
			IF( Var_NumConsecutivo <> Entero_Cero ) THEN

				SELECT MAX(RegistroID) + Entero_Uno
				INTO Var_NumConsecutivo
				FROM ACTIVOS Act
				INNER JOIN RELACIONCTIVOS Rel ON Act.ActivoID = Rel.ActivoID
				INNER JOIN TIPOSACTIVOS Tip ON Act.TipoActivoID = Tip.TipoActivoID
				WHERE Act.TipoActivoID = Par_TipoActivoID;

				SET Par_NumErr	:= 4;
				SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [A], favor de Revisar.<br>',
										  'Error: <b>El Consecutivo Relacionado al Tipo de Activo: ', Par_TipoActivoID,' ya esta Asignado: No. Activo Relacionado ',Var_ActivoID,
										  ' Prox. Folio: ',Var_NumConsecutivo,'</b>');
				SET Var_Control	:= 'tipoActivoID';
				LEAVE ManejoErrores;
			END IF;


			SET Var_RegistroID := Entero_Cero;

			SELECT IFNULL(MAX(ConsecutivoID), Entero_Cero) + Entero_Uno
			INTO Var_RegistroID
			FROM RELACIONCTIVOS
			FOR UPDATE;

			SET Aud_FechaActual := NOW();
			-- Insercion en la tabla de equivalencia
			INSERT INTO RELACIONCTIVOS (
				ConsecutivoID,		RegistroID,			ActivoID,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES(
				Var_RegistroID,		Par_RegistroID,		Var_ActivoID,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			DELETE FROM TMPACTIVOS
			WHERE RegistroID = Par_ConsecutivoID
			  AND TransaccionID = Par_TransaccionID
			  AND ConsecutivoCliente = Par_RegistroID;

			SET Par_NumErr		:= Entero_Cero;
			SET Par_ErrMen		:= CONCAT('Activo Agregado Exitosamente:',CAST(Var_ActivoID AS CHAR) );
			SET Var_Control		:= 'activoID';
			SET Var_Consecutivo	:= Var_ActivoID;
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$