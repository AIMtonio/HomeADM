-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOLAYOUTVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVOLAYOUTVAL`;

DELIMITER $$
CREATE PROCEDURE `ACTIVOLAYOUTVAL`(
	-- Store Procedure de Validacion de Carga Masiva de Activos
	-- Modulo: Activos --> Registro --> Carga Masiva

	Par_ConsecutivoID 		INT(11),		-- Numero de Registro SAFI
	Par_RegistroID			INT(11),		-- Numero de Registro Cliente
	Par_TransaccionID		BIGINT(20),		-- Numero de Transaccion
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
	Par_CtaContable			VARCHAR(25), 	-- Cuenta Contable

	Par_CtaContableRegistro	VARCHAR(50), 	-- Cuenta Contable
	Par_PorDepFiscal		DECIMAL(16,2),	-- Porcentaje de depreciación fiscal para el activo.
	Par_DepFiscalSaldoInicio DECIMAL(16,2),	-- Saldo inicial de acuerdo a la depreciación fiscal.
	Par_DepFiscalSaldoFin	DECIMAL(16,2),	-- Saldo final de acuerdo a la depreciación fiscal.

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
 	DECLARE Var_PorDepFiscal			DECIMAL(16,2);	-- Porcentaje de Depreciacion Fiscal
	DECLARE Var_NumConsecutivo			INT(11);		-- Numero de Numero de Consecutivo
	DECLARE Var_ActivoID				INT(11);		-- Numero de ACtivo
	DECLARE Var_Control					VARCHAR(50);	-- Retorno de Control a Pantalla
    DECLARE Var_FechaSistema			DATE;			-- Fecha de Sistema

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante de salida SI

	DECLARE Salida_NO			CHAR(1);			-- Constante de salida NO
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Est_Activo			CHAR(1);			-- Constante Estatus Activo
	DECLARE Grupo_Detalle		CHAR(1);			-- Cuenta contable grupo detalle

	DECLARE Llave_PorDepFiscalActivos	VARCHAR(50);	-- Porcentaue Depreciacion Fiscal para Activo
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Est_Activo				:= 'A';
	SET Grupo_Detalle			:= 'D';
	SET Llave_PorDepFiscalActivos	:= 'MaxPorDepFiscalActivos';

	SET Decimal_Cero			:= 0.00;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-ACTIVOLAYOUTVAL');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_ConsecutivoID 			:= IFNULL(Par_ConsecutivoID, Entero_Cero);
		SET Par_RegistroID 				:= IFNULL(Par_RegistroID, Entero_Cero);
		SET Par_TransaccionID 			:= IFNULL(Par_TransaccionID, Entero_Cero);
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
		SET Var_FechaSistema			:= IFNULL((SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1), Fecha_Vacia);

		IF( Par_TransaccionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Transaccion esta Vacio.';
			SET Var_Control	:= 'transaccionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ConsecutivoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero Consecutivo de SAFI Vacio.';
			SET Var_Control	:= 'consecutivoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_ConsecutivoID := Par_ConsecutivoID + Entero_Uno;

		IF( Par_RegistroID = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [A], favor de Revisar.<br>','Error: <b>El Numero de Consecutivo del Activo esta Vacío.</b>');
			SET Var_Control	:= 'registroID';
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

		-- Validacion de Tipo de Activo
		IF( Par_TipoActivoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [B], favor de Revisar.<br>','Error: <b>El Tipo de Activo esta Vacío.</b>');
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS( SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID ) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [B], favor de Revisar.<br>','Error: <b>El Tipo de Activo no Existe.</b>');
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Est_Activo <> ( SELECT Estatus FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID ) )THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [B], favor de Revisar.<br>','Error: <b>El Tipo de Activo esta Inactivo.</b>');
			SET Var_Control	:= 'tipoActivoID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de Descripcion
		IF( Par_Descripcion = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [C], favor de Revisar.<br>','Error: <b>La Descripción del Activo esta Vacía.</b>');
			SET Var_Control	:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el numero de meses
		IF( Par_MesesUsos = Entero_Cero ) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [D], favor de Revisar.<br>','Error: <b>El tiempo de Amortización esta Vacio.</b>');
			SET Var_Control	:= 'mesesUsos';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la fecha de Adquisicion
		IF( Par_FechaAdquisicion = Fecha_Vacia) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [E], favor de Revisar.<br>','Error: <b>La Fecha de Adquisición esta Vacía.</b>');
			SET Var_Control	:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la fecha de Adquisicion
		IF( Par_FechaAdquisicion > Var_FechaSistema) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [E], favor de Revisar.<br>','Error: <b>La Fecha de Adquisición esta Mayor a la Fecha del Sistema.</b>');
			SET Var_Control	:= 'fechaAdquisicion';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Monto de Inversion
		IF( Par_Moi <= Decimal_Cero ) THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [H], favor de Revisar.<br>','Error: <b>El Monto Original Inversión esta Vacío.</b>');
			SET Var_Control	:= 'moi';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Monto de Inversion
		IF( Par_DepreciadoAcumulado < Decimal_Cero ) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [I], favor de Revisar.<br>','Error: <b>El Monto Depresiado Acumulado no puede ser negativo.</b>');
			SET Var_Control	:= 'depreciadoAcumulado';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Monto de Inversion
		IF( Par_TotalDepreciar < Decimal_Cero ) THEN
			SET Par_NumErr	:= 13;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [J], favor de Revisar.<br>','Error: <b>El Total por Depreciar no puede ser negativo.</b>');
			SET Var_Control	:= 'totalDepreciar';
			LEAVE ManejoErrores;
		END IF;

		-- Valor de la Depresiacion Acumulada
		IF( Par_DepreciadoAcumulado > Par_Moi ) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [I], favor de Revisar.<br>','Error: <b>El Monto Depresiado Acumulado no puede ser mayor al MOI.</b>');
			SET Var_Control	:= 'depreciadoAcumulado';
			LEAVE ManejoErrores;
		END IF;

		-- Valor de la Depresiacion Total
		IF( Par_TotalDepreciar > Par_Moi ) THEN
			SET Par_NumErr	:= 15;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [J], favor de Revisar.<br>','Error: <b>El Total por Depreciar no puede ser mayor al MOI.</b>');
			SET Var_Control	:= 'totalDepreciar';
			LEAVE ManejoErrores;
		END IF;

		IF( (Par_DepreciadoAcumulado + Par_TotalDepreciar) > Par_Moi ) THEN
			SET Par_NumErr	:= 16;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [J], favor de Revisar.<br>','Error: <b>La suma del Depreciado acumulado mas el Total por Depreciar, NO puede ser mayor al MOI.</b>');
			SET Var_Control	:= 'totalDepreciar';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion del Procentaje de Deprecicacion Fiscal
		IF( Par_PorDepFiscal <= Decimal_Cero ) THEN
			SET Par_NumErr	:= 17;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [K], favor de Revisar.<br>','Error: <b>Porcentaje de depreciación fiscal esta Vacío.</b>');
			SET Var_Control	:= 'porDepFiscal';
			LEAVE ManejoErrores;
		END IF;

		SET Var_PorDepFiscal := IFNULL(FNPARAMGENERALES(Llave_PorDepFiscalActivos), Decimal_Cero);
		IF( Par_PorDepFiscal > Var_PorDepFiscal ) THEN
			SET Par_NumErr	:= 18;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [K], favor de Revisar.<br>','Error: <b>Porcentaje de depreciación fiscal supera lo parametrizado: ',Var_PorDepFiscal,'.</b>');
			SET Var_Control	:= 'porDepFiscal';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el Centro de costos
		IF( Par_CentroCostoID <> Entero_Cero ) THEN
			IF NOT EXISTS( SELECT CentroCostoID FROM CENTROCOSTOS WHERE CentroCostoID = Par_CentroCostoID ) THEN
				SET Par_NumErr	:= 19;
				SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [M], favor de Revisar.<br>','Error: <b>El Centro de Costos No Existe.</b>');
				SET Var_Control	:= 'centroCostoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Validacion para la cuenta Contable
		IF( Par_CtaContableRegistro = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 20;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [N], favor de Revisar.<br>','Error: <b>La Cuenta Contable de Registro esta Vacía.</b>');
			SET Var_Control	:= 'ctaContableRegistro';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS( SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CtaContableRegistro ) THEN
			SET Par_NumErr	:= 21;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [N], favor de Revisar.<br>','Error: <b>La Cuenta Contable de Registro: ',Par_CtaContableRegistro,' No Existe.</b>');
			SET Var_Control	:= 'ctaContableRegistro';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la cuenta Contable
		IF( Par_CtaContable = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 22;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [O], favor de Revisar.<br>','Error: <b>La Cuenta Contable de Depreciación esta Vacía.</b>');
			SET Var_Control	:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS( SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CtaContable ) THEN
			SET Par_NumErr	:= 23;
			SET Par_ErrMen	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [O], favor de Revisar.<br>','Error: <b>La Cuenta Contable de Depreciación: ',Par_CtaContable,' No Existe.</b>');
			SET Var_Control	:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta =Par_CtaContable AND Grupo = Grupo_Detalle ) THEN
			SET Par_NumErr 	:= 24;
			SET Par_ErrMen 	:= CONCAT('Se encontró un error en la Fila: [',Par_ConsecutivoID,'] Columna [O], favor de Revisar.<br>','Error: <b>La Cuenta Contable ',Par_CtaContable,' no es de Detalle.');
			SET Var_Control	:= 'ctaContable';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Validacion del Registro: ',CAST(Par_RegistroID AS CHAR),' Realizado Correctamente.' );
		SET Var_Control	:= 'transaccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_RegistroID AS consecutivo,
				Par_TransaccionID AS consecutivoInt;

	END IF;

END TerminaStore$$