-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGCREDITOCONTALT`;DELIMITER $$

CREATE PROCEDURE `RESPAGCREDITOCONTALT`(
/*SP para el Respaldo de Pagos de Creditos Contingentes*/
	Par_TranRespaldo		BIGINT,
	Par_CuentaAhoID			BIGINT(12),
	Par_CreditoID			BIGINT(12),
	Par_MontoPagado			DECIMAL(14,2),

    Par_Salida              CHAR(1),
	INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID			INT(11),
    Aud_Usuario				INT(11),
    Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de Variables.
	DECLARE Var_FechaSistema	DATE;
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE Salida_NO           CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Fecha_Vacia			DATE;
	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Salida_SI			:= 'S';				-- Salida Si
	SET Salida_NO           := 'N';
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Decimal_Cero		:= 0.0;				-- DECIMAL Cero
    SET Fecha_Vacia			:= '1900-01-01';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-RESPAGCREDITOCONTALT');
		END;

		IF(Par_TranRespaldo = Entero_Cero)THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Numero de Transaccion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CreditoID = Entero_Cero)THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Credito esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MontoPagado = Decimal_Cero)THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= 'El Monto esta vacio';
			LEAVE ManejoErrores;
		END IF;

		SET Var_FechaSistema:= (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);


		INSERT INTO RESPAGCREDITOCONT (
			TranRespaldo,	CuentaAhoID,	CreditoID,		MontoPagado,	FechaPago,
			EmpresaID,		Usuario,		FechaActual,	DireccionIP,	ProgramaID,
			Sucursal,		NumTransaccion)
		VALUES	(
			Par_TranRespaldo,	Par_CuentaAhoID,	Par_CreditoID,		Par_MontoPagado,	Var_FechaSistema,
			Par_EmpresaID,		Aud_Usuario ,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

			SET	Par_NumErr 	:= Entero_Cero;
			SET	Par_ErrMen	:= 'Respaldado Realizado Existosamente';

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$