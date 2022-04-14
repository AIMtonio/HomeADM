-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVSCONCILIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOMOVSCONCILIACT`;DELIMITER $$

CREATE PROCEDURE `TESOMOVSCONCILIACT`(
# ==================================================================================
# ------------ SP PARA ACTUALIZAR LOS MOVIMIENTOS DE CONCILIACION ------------------
# ==================================================================================
    Par_FolioCarga		INT(11),
    Par_CuentaAhoID		BIGINT(12),
    Par_Estatus			CHAR(1),
    Par_NumeroMov		INT(11),
    Par_TipMovCon		CHAR(4),
    Par_NumAct			TINYINT UNSIGNED,

	Par_Salida         	CHAR(1),
	OUT	Par_NumErr		INT(11),
	OUT	Par_ErrMen		VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT(12),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE Est_Concilado  	CHAR(1);
	DECLARE Decimal_Cero  	DECIMAL(14,2);
	DECLARE ActConciliado  	INT(11);
	DECLARE Salida_SI     	CHAR(1);
	DECLARE Est_NoAplicaIN	CHAR(1);
	DECLARE Mov_PagNom		CHAR(4);

	-- Declaracion de Variables
	DECLARE Var_EstPagNom	CHAR(1);
    DECLARE VarControl 		VARCHAR(15);

	-- Asignacion de Constantes
	SET Entero_Cero     	:= 0;		-- entero en cero
	SET Est_Concilado	 	:= 'C';		-- indica valor para estatus conciliado
	SET Decimal_Cero 		:= 0.00;	-- decimal en cero
	SET ActConciliado	 	:= 1;		-- indica el numero de actualizacion para conciliacion de movimientos
	SET Salida_SI       	:= 'S';		-- Salida a Pantalla SI
	SET Aud_FechaActual		:= NOW();	-- Actualiza el valor de fecha de auditoria
	SET Est_NoAplicaIN		:= 'N';		-- Estatus de Pago no aplicado si es un pago de Credito Nomina
	SET Mov_PagNom			:= '501'; 	-- Numero de Movimiento de conciliacion para que se agregue EstatusConcilaIN
	SET Var_EstPagNom 		:= '';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= '999';
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								   'esto le ocasiona. Ref: SP-TESOMOVSCONCILIACT');
			SET VarControl	= 'sqlException';
		END;

		IF(Par_TipMovCon = Mov_PagNom)THEN
			SET Var_EstPagNom := Est_NoAplicaIN;
		END IF;


		IF(Par_NumAct = ActConciliado) THEN     -- Actualizacion a "Conciliado"
			UPDATE TESOMOVSCONCILIA SET
				NumeroMov      		= Par_NumeroMov,
				Status          	= Est_Concilado,
				TipoMov		     	= Par_TipMovCon,
				EstatusConciliaIN	= Est_NoAplicaIN,
				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal,
				NumTransaccion  	= Aud_NumTransaccion

			WHERE FolioCargaID = Par_FolioCarga;

		END IF;

		SET Par_NumErr      := '000';
		SET Par_ErrMen      := 'Movimiento Actualizado Exitosamente.';
		SET Par_Consecutivo := Entero_Cero;


    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'CuentaAhoID'	AS control,
				Par_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$