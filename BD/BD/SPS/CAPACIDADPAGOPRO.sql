-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAPACIDADPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAPACIDADPAGOPRO`;
DELIMITER $$


CREATE PROCEDURE `CAPACIDADPAGOPRO`(
	/* declaracion de parametros */
	Par_ClienteID			INT(11),		# ID del cliente
	Par_Sucursal			INT(11),		# sucursal donde se esta realizando la estimacion
	Par_IngresoMensual		DECIMAL(14,2),	# ingreso mensual del cliente
	Par_GastoMensual		DECIMAL(14,2),	# gasto mensual del cliente
	Par_MontoSolicitado		DECIMAL(14,2),	# monto del credito solicitado por el cliente
	Par_ProductoCredito1	INT(11),		# producto de credito 1
	Par_ProductoCredito2	INT(11),		# producto de credito 2
	Par_ProductoCredito3	INT(11),		# producto de credito 3z
	Par_Plazos				VARCHAR(200),
	Par_Salida				CHAR(1),		# Salida S:Si N:No
	INOUT Par_NumErr		INT(11),		# Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de error

	/* parametros de auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore:BEGIN 	#bloque main del sp


	/* declaracion de variables*/
	DECLARE PorcentajeCob			DECIMAL(12,2); 	# porcentaje de cobertura que se aumenta al gasto mensual del cliente
	DECLARE CoberturaMin			DECIMAL(12,2);	# cobertura minima que debe alcanzar el cliente para tener cobertura positiva
	DECLARE Var_IngresosGastos		DECIMAL(14,2);	# ingreso mensual - (gasto mensual + porcentaje de cobertura)
	DECLARE Var_CobSinPrestamo		DECIMAL(14,2);	# ( gastos mensual  + porcentaje de cobertura) / ingreso
	DECLARE Var_TasaInteres1		DECIMAL(14,2);  # Tasa de interes para producto de credito 1
	DECLARE Var_TasaInteres2		DECIMAL(14,2);  # Tasa de interes para producto de credito 2
	DECLARE Var_TasaInteres3		DECIMAL(14,2);  # Tasa de interes para producto de credito 3
	DECLARE Var_NumCreditos			INT;			# numero de creditos del cliente
	DECLARE Var_NumCreditosG		INT;			# numero de creditos grupales
	DECLARE Var_NivelID				INT(11);		# Nivel del crédito (NIVELCREDITO).


	/* declaracion de constantes*/
	DECLARE Entero_Cero			INT;			# entero cero
	DECLARE SalidaSI			CHAR(1);			# entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	# decimal cero
	DECLARE Salida_NO			CHAR(1);		# Salida NO
	DECLARE CalifCliente		CHAR(1);		# calificacion del cliente

	/* asignacion de constantes*/
	SET Entero_Cero			:= 0;
	SET Salida_NO			:= 'N';
	SET SalidaSI			:= 'S';
	SET CalifCliente  := (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID = Par_ClienteID);

	/* Asignacion de Variables */
	SELECT IFNULL(Caj.PorcentajeCob,Decimal_Cero), IFNULL(Caj.CoberturaMin,Decimal_Cero)
		FROM PARAMETROSCAJA Caj,
			 PARAMETROSSIS Sis
		WHERE Caj.EmpresaID = Sis.EmpresaID
	INTO PorcentajeCob, CoberturaMin;


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CAPACIDADPAGOPRO');
		END;

		SET Var_IngresosGastos  := Par_IngresoMensual - (Par_GastoMensual + ((Par_GastoMensual * PorcentajeCob) / 100 ));
		SET Var_CobSinPrestamo  := (Par_GastoMensual + (( Par_GastoMensual * PorcentajeCob) / 100)) / Par_IngresoMensual;


		/* =========== Calcula las tasas de interes para cada producto de credito =========== */

		CALL CRECALCULOCICLOPRO(
			Par_ClienteID,		 Entero_Cero,		 Par_ProductoCredito1,		 Entero_Cero,		 Var_NumCreditos,
			Var_NumCreditosG,	 Salida_NO,			 Aud_Empresa,		 		 Aud_Usuario,		 Aud_FechaActual,
			Aud_DireccionIP,	 Aud_ProgramaID,	 Aud_Sucursal,				 Aud_NumTransaccion);

		CALL ESQUEMATASACALPRO(
			Par_Sucursal,		Par_ProductoCredito1,			Var_NumCreditos,		Par_MontoSolicitado,		CalifCliente,
			Var_TasaInteres1,	Par_Plazos,						Entero_Cero,			Entero_Cero,				Var_NivelID,			
			Salida_NO,			Par_NumErr,						Par_ErrMen,				Aud_Empresa,				Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr!= Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL CRECALCULOCICLOPRO(
			Par_ClienteID,		 Entero_Cero,		 Par_ProductoCredito2,		 Entero_Cero,		 Var_NumCreditos,
			Var_NumCreditosG,	 Salida_NO,			 Aud_Empresa,		 		 Aud_Usuario,		 Aud_FechaActual,
			Aud_DireccionIP,	 Aud_ProgramaID,	 Aud_Sucursal,				 Aud_NumTransaccion);

		CALL ESQUEMATASACALPRO(
			Par_Sucursal,		Par_ProductoCredito2,		Var_NumCreditos,		Par_MontoSolicitado,		CalifCliente,
			Var_TasaInteres2,	Par_Plazos,					Entero_Cero,			Entero_Cero,				Var_NivelID,			
            Salida_NO,			Par_NumErr,					Par_ErrMen,				Aud_Empresa,				Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!= Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL CRECALCULOCICLOPRO(
			Par_ClienteID,		 Entero_Cero,		 Par_ProductoCredito3,		 Entero_Cero,		 Var_NumCreditos,
			Var_NumCreditosG,	 Salida_NO,			 Aud_Empresa,		 		 Aud_Usuario,		 Aud_FechaActual,
			Aud_DireccionIP,	 Aud_ProgramaID,	 Aud_Sucursal,				 Aud_NumTransaccion);

		CALL ESQUEMATASACALPRO(
			Par_Sucursal,		Par_ProductoCredito3,		Var_NumCreditos,		Par_MontoSolicitado,		CalifCliente,
			Var_TasaInteres3,	Par_Plazos,					Entero_Cero,			Entero_Cero,				Var_NivelID,			
            Salida_NO,			Par_NumErr,					Par_ErrMen,				Aud_Empresa,				Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr!= Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_CobSinPrestamo	:= Var_CobSinPrestamo*100.00;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Capacidad de Pago realizada Exitosamente.';
		SET PorcentajeCob := IFNULL(PorcentajeCob, Entero_Cero);
		SET CoberturaMin := IFNULL(CoberturaMin, Entero_Cero);
		SET Var_IngresosGastos := IFNULL(Var_IngresosGastos, Entero_Cero);
		SET Var_CobSinPrestamo := IFNULL(Var_CobSinPrestamo, Entero_Cero);
		SET Var_TasaInteres1 := IFNULL(Var_TasaInteres1, Entero_Cero);
		SET Var_TasaInteres2 := IFNULL(Var_TasaInteres2, Entero_Cero);
		SET Var_TasaInteres3 := IFNULL(Var_TasaInteres3, Entero_Cero);

	END ManejoErrores; #fin del manejador de errores
	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_ClienteID  		AS ClienteID,
				FORMAT(PorcentajeCob,2) 		AS PorcentajeCob,
				FORMAT(CoberturaMin,2)  		AS CoberturaMin,
				FORMAT(Var_IngresosGastos,2)	AS IngresosGastos,
				FORMAT(Var_CobSinPrestamo,2)	AS CobSinPrestamo,
				FORMAT(Var_TasaInteres1,2)		AS TasaInteres1,
				FORMAT(Var_TasaInteres2,2)		AS TasaInteres2,
				FORMAT(Var_TasaInteres3,2)		AS TasaInteres3,
				Par_NumErr	  AS NumErr,
				Par_ErrMen	  AS ErrMen;
	END IF;
END TerminaStore$$