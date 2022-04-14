-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREDIARIOAHORRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREDIARIOAHORRO`;

DELIMITER $$
CREATE PROCEDURE `CIERREDIARIOAHORRO`(
	Par_FechaOperacion	DATE,			-- Fecha de Operacion
	Par_FechaAplicacion	DATE,  			-- Fecha de Aplicacion

	Par_Salida			CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_NumErr	INT(11),		-- Numero de Error
    INOUT Par_ErrMen	VARCHAR(400),	-- Descripcion de Error

    Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_FecActual		DATETIME;
	DECLARE Var_FecBitaco		DATETIME;
	DECLARE Var_MinutosBit		INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE ProcesoCierreDiaAho	INT(11);

	DECLARE Fecha_Vacia			DATE;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Estatus_Activa		CHAR(1);
	DECLARE InstrumentoCta		INT(11);

	-- Asignacaion de constantes
	SET Entero_Cero			:= 0;			-- Entero Cero
	SET SalidaSI			:= 'S';			-- Salida SI
	SET SalidaNO			:= 'N';			-- Salida NO
	SET Decimal_Cero		:= 0.00;		-- Decimal en Ceros
	SET ProcesoCierreDiaAho	:= 420; 		-- Proceso Batch de Cierre Diario de Ahorro

	SET Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
	SET Cadena_Vacia		:= '';			-- Cadena vacia
	SET Estatus_Activa		:= 'A';			-- Esatus Activa
	SET InstrumentoCta		:= 2;			-- Tipo de Instrumento: Cuentas

	ManejoErrores:BEGIN

		SET	Var_FecBitaco		:= NOW();
		SELECT FechaSistema	 INTO Var_FecActual
		FROM PARAMETROSSIS;

		SET Var_FecActual	:=IFNULL(Var_FecActual,Fecha_Vacia);

		-- Inicializamos los abonos y cargos del Dia en Ceros
		UPDATE CUENTASAHO SET
			AbonosDia		= Decimal_Cero,
			CargosDia		= Decimal_Cero
		WHERE Estatus = Estatus_Activa;

		--  Proceso para el Calculo del Interes Real
		CALL CALCULOINTERESREALPRO (
			Par_FechaOperacion,	InstrumentoCta,		SalidaNO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			ProcesoCierreDiaAho,	Var_FecActual,      Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Cierre de Ahorro Realizado';

	END ManejoErrores;  -- End del Handler de Errores.

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$