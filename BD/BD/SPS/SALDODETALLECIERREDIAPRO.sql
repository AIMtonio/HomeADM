-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDODETALLECIERREDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDODETALLECIERREDIAPRO`; 

DELIMITER $$
CREATE PROCEDURE `SALDODETALLECIERREDIAPRO`(
# ===============================================================================
# ------ SP PARA CALCULAR LOS SALDOS DE DETALLES POLIZAS POR DIA DURANTE LOS CIERRES DE DIA------
# ===============================================================================
	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE Var_Control		  VARCHAR(100);	 -- Control de errores
    DECLARE Var_FechaSis      DATE;          -- Fecha del sistema
    DECLARE Var_FechaUltima   DATE;          -- Fecha Ultima  regsitrada en SALDOSDETALLLEPOLIZA 

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	  CHAR(1);	     -- Constante Cadena Vacia
	DECLARE Entero_Cero		  INT(11);		 -- Constante Entero cero
	DECLARE Decimal_Cero      DECIMAL(12,2); -- Constante Decimal cero
	DECLARE Salida_SI		  CHAR(1);		 -- Constante Salida SI
	DECLARE Salida_NO		  CHAR(1);		 -- Constante Salida NO

	DECLARE Fecha_Vacia		  DATE;			 -- Constante Fecha Vacia
	DECLARE Consecutivo	      INT(11);		 -- Numero de Consecutivo



	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';

	SET Fecha_Vacia 		:= '1900-01-01';
	SET Consecutivo 		:= Entero_Cero;

	-- Bloque para manejar los posibles errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-SALDODETALLECIERREDIAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual := NOW();

		SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

		SET  Var_FechaUltima:=(SELECT MAX(Fecha) FROM SALDOSDETALLEPOLIZA);
		SET  Var_FechaUltima:=IFNULL(Var_FechaUltima,Fecha_Vacia);

		
		SET  Var_FechaUltima:=DATE_ADD(Var_FechaUltima,INTERVAL 1 DAY);
	
        WHILE (Var_FechaUltima < Var_FechaSis) DO
            CALL SALDOSDETALLEPOLIZADIAPRO( Var_FechaUltima,	      Par_Salida,        Par_NumErr,             Par_ErrMen,	      Aud_EmpresaID,		
                                            Aud_Usuario,			  Aud_FechaActual,   Aud_DireccionIP,		 Aud_ProgramaID,       Aud_Sucursal,
                                            Aud_NumTransaccion);

            IF( Par_NumErr <> Entero_Cero ) THEN
                LEAVE ManejoErrores;
            END IF;

            SET  Var_FechaUltima:=DATE_ADD(Var_FechaUltima,INTERVAL 1 DAY);

        END WHILE;


		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Saldos  Registrados.';
		SET Var_Control	:= 'saldosD';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$