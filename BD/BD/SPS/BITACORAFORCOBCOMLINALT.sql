-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAFORCOBCOMLINEAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS BITACORAFORCOBCOMLINALT;

DELIMITER $$
CREATE PROCEDURE `BITACORAFORCOBCOMLINALT`(
	-- Store Procedure: De Alta para la bitacora de forma de cobro de comisiones por linea de credito
	-- Modulo Cartera
	Par_CreditoID				BIGINT(12),		-- Numero de Credito
	Par_LineaCreditoID			BIGINT(20),		-- ID de linea de Credito
	Par_TipoComision			CHAR(1),		-- Tipo de Comision

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Par_RegistroID			INT(11);		-- ID de Tabla
	DECLARE Var_LineaCreditoID		BIGINT(20);		-- ID de linea de Credito
	DECLARE Var_CreditoID			BIGINT(12);		-- ID de Credito
	DECLARE Var_FechaSistema		DATE;			-- Fecha de Sistema

	DECLARE Var_ComLinPrevLiq		CHAR(1);		-- Comisión que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobCom			CHAR(1);		-- Forma de Cobro Comisión \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición
	DECLARE Var_ForPagCom			CHAR(1);		-- Forma de Pago Comisión  \n"".- No aplica \nD.- Deducción \nF.- Financiado
	DECLARE Var_MontoPagCom			DECIMAL(14,2);	-- Monto a Pagar por Comisión por
	DECLARE Var_PorcentajeCom		DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Var_FechaUltimoCobro	DATE;			-- Fecha de Ultimo cobro de Comision

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Tip_ComAdmon		CHAR(1);		-- Constante Tipo Comision Admon
	DECLARE	Tip_ComGarantia		CHAR(1);		-- Constante Tipo Comision Garantia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Tip_ComAdmon	:= 'A';
	SET	Tip_ComGarantia	:= 'G';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORAFORCOBCOMLINALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_LineaCreditoID := IFNULL(Par_LineaCreditoID, Entero_Cero);

		-- Validacion para la Sucursal este Vacio
		IF( Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_CreditoID := IFNULL(Var_CreditoID , Entero_Cero);
		IF( Var_CreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Credito ',Par_CreditoID,' no Existe.');
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoComision = Tip_ComAdmon ) THEN
			SELECT 	ComAdmonLinPrevLiq,		ForCobComAdmon,		ForPagComAdmon,
					PorcentajeComAdmon,		MontoPagComAdmon
			INTO 	Var_ComLinPrevLiq,		Var_ForCobCom,		Var_ForPagCom,
					Var_PorcentajeCom,		Var_MontoPagCom
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;
		END IF;

		IF( Par_TipoComision = Tip_ComGarantia ) THEN
			SELECT 	ComGarLinPrevLiq,		ForCobComGarantia,	ForPagComGarantia,
					PorcentajeComGarantia,	MontoPagComGarantia
			INTO 	Var_ComLinPrevLiq,		Var_ForCobCom,		Var_ForPagCom,
					Var_PorcentajeCom,		Var_MontoPagCom
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;
		END IF;

		IF( Par_LineaCreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= CONCAT('La Linea de Credito ',Par_LineaCreditoID,' esta Vacia.');
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS( SELECT * FROM LINEASCREDITO WHERE LineaCreditoID = Par_LineaCreditoID) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('La Linea de Credito ',Par_LineaCreditoID,' no Existe.');
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaSistema
		INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Var_FechaUltimoCobro := DATE_ADD(Var_FechaSistema, INTERVAL 1 YEAR);
		CALL FOLIOSAPLICAACT('BITACORAFORCOBCOMLIN', Par_RegistroID);
		SET Aud_FechaActual := NOW();

		INSERT INTO BITACORAFORCOBCOMLIN (
			RegistroID,				CreditoID,			LineaCreditoID,			FechaRegistro,		TipoComision,
			ComLinPrevLiq,			ForCobCom,			ForPagCom,				PorcentajeCom,		MontoPagCom,
			FechaProximoCobro,
			EmpresaID,				Usuario,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES(
			Par_RegistroID,			Par_CreditoID,		Par_LineaCreditoID,		Var_FechaSistema,	Par_TipoComision,
			Var_ComLinPrevLiq,		Var_ForCobCom,		Var_ForPagCom,			Var_PorcentajeCom,	Var_MontoPagCom,
			Var_FechaUltimoCobro,
			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Almacen Registrado Correctamente.';
		SET Var_Control	:= 'almacenID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_AlmacenID AS Consecutivo;
	END IF;

END TerminaStore$$