-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESDETACCESORIOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESDETACCESORIOSPRO`;
DELIMITER $$


CREATE PROCEDURE `RESDETACCESORIOSPRO`(
# ======================================================================================================
# ----- SP QUE REALIZA EL RESPALDO DE LA TABLA DETALLEACCESORIOS. (REVERSA)
# ======================================================================================================
	Par_CreditoID			BIGINT(12),		# Numero de Credito
    Par_AccesorioID			INT(11),		# Numero de Accesorio
    Par_AmortizacionID		INT(11),		# Numero de Amortizacion
	Par_Salida    			CHAR(1), 		# Indica la Salida S:Si  N:No

    INOUT	Par_NumErr 		INT(11),		# Numero de Error
    INOUT	Par_ErrMen  	VARCHAR(350),	# Mensaje de Error
	# Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore:BEGIN

	# Declaracion de variables
	DECLARE varControl			VARCHAR(100); 	# Variable Control Pantalla
	DECLARE Consecutivo			INT(11); 		# Variable Consecutivo

	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT(11); 		# Constante Entero Cero
	DECLARE Decimal_Cero    	DECIMAL(12,2); 	# Constante Decimal Cero
	DECLARE Salida_SI			CHAR(1); 		# Constante Salida Si

	-- Asignacion de constantes
	SET Entero_Cero     := 0;           # Entero en Cero
	SET Decimal_Cero    := 0.00;        # DECIMAL en Cero
	SET Salida_SI		:= 'S';			# Constante. SI


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  = 999;
		   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  'Disculpe las molestias que esto le ocasiona. Ref: SP-RESDETACCESORIOSPRO');
		   SET varControl  = 'SQLEXCEPTION';
		END;


		SET Consecutivo	:= (SELECT MAX(R.Consecutivo) FROM RESDETACCESORIOS R
								WHERE CreditoID = Par_CreditoID);

		SET Consecutivo := IFNULL(Consecutivo, Entero_Cero)  + 1;

		# Respaldo de la informacion  de la tabla DETALLEACCESORIOS antes del proceso de pago de credito
		INSERT INTO RESDETACCESORIOS (
					`TranRespaldo`,			`Consecutivo`,			`CreditoID`,			`SolicitudCreditoID`, 	`NumTransacSim`,
					`AccesorioID`,		    `PlazoID`,				`CobraIVA`,				`GeneraInteres`,		`CobraIVAInteres`,
					`TipoFormaCobro`,		`TipoPago`,				`BaseCalculo`,	        `Porcentaje`,			`AmortizacionID`,
					`MontoAccesorio`,		`MontoIVAAccesorio`,	`MontoInteres`,			`MontoIVAInteres`,		`MontoCuota`,
					`MontoIVACuota`,		`MontoIntCuota`,		`MontoIVAIntCuota`,		`SaldoVigente`,			`SaldoAtrasado`,
					`SaldoIVAAccesorio`,	`SaldoInteres`,			`SaldoIVAInteres`,		`MontoPagado`,		    `FechaLiquida`,
					`EmpresaID`,			`Usuario`,				`FechaActual`,			`DireccionIP`,          `ProgramaID`,
					`Sucursal`,				`NumTransaccion` )
			SELECT 	Aud_NumTransaccion,		Consecutivo,			`CreditoID`,			`SolicitudCreditoID`, 	`NumTransacSim`,
					`AccesorioID`,		    `PlazoID`,				`CobraIVA`,				`GeneraInteres`,		`CobraIVAInteres`,
					`TipoFormaCobro`,		`TipoPago`,				`BaseCalculo`,	        `Porcentaje`,			`AmortizacionID`,
					`MontoAccesorio`,		`MontoIVAAccesorio`,	`MontoInteres`,			`MontoIVAInteres`,		`MontoCuota`,
					`MontoIVACuota`,		`MontoIntCuota`,		`MontoIVAIntCuota`,		`SaldoVigente`,			`SaldoAtrasado`,
					`SaldoIVAAccesorio`,	`SaldoInteres`,			`SaldoIVAInteres`,		`MontoPagado`,		    `FechaLiquida`,
					`EmpresaID`,			`Usuario`,				`FechaActual`,			`DireccionIP`,          `ProgramaID`,
					`Sucursal`,				`NumTransaccion`
			FROM DETALLEACCESORIOS
					WHERE CreditoID = Par_CreditoID
					AND AccesorioID = Par_AccesorioID
					AND AmortizacionID = Par_AmortizacionID;


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Respaldo Realizado Exitosamente.';
		SET varControl := 'creditoID';

	END ManejoErrores;  # END Manejo de Errores

	IF(Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$