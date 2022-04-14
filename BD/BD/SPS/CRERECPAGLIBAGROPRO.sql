-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRERECPAGLIBAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRERECPAGLIBAGROPRO`;DELIMITER $$

CREATE PROCEDURE `CRERECPAGLIBAGROPRO`(
 /* SP que consulta si el credito refinancia o no para llamar al simulador correspondiente */
	Par_Monto 					DECIMAL(12,2),		# Monto solicitado
	Par_Tasa 					DECIMAL(12,4), 		# Tasa fija
	Par_ProducCreditoID 		INT(11), 			# Producto de Credito sirve para determinar si paga o no iva
	Par_ClienteID 				INT(11), 			# Cliente sirve para determinar si paga o no iva
	Par_ComAper 				DECIMAL(12,2), 		# Monto de la comision por apertura

	Par_CobraSeguroCuota 		CHAR(1), 			# Cobra Seguro por cuota
	Par_CobraIVASeguroCuota 	CHAR(1), 			# Cobra IVA Seguro por cuota
	Par_MontoSeguroCuota		DECIMAL(12,2), 		# Monto Seguro por Cuota
	Par_SolicitudCreditoID		INT(11),			# Numero de Solicitud
	Par_CreditoID				BIGINT(12),			# Numero de Credito

    Par_ComAnualLin				DECIMAL(12,2),		# Monto de la Comsión Anual de Linea de Crédito
	Par_Salida 					CHAR(1), 			# Indica si hay una salida o no
	INOUT Par_NumErr	 		INT(11),

	INOUT   Par_ErrMen          VARCHAR(400),
    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),

    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(11)
	)
TerminaStore: BEGIN

	# Variables
	DECLARE Var_Control			VARCHAR(100);		# Variable de control
	DECLARE Var_Refinancia		CHAR(1);


	/* Declaracion de constantes */
	DECLARE Cadena_Vacia CHAR(1);
	DECLARE Var_SI CHAR(1);
	DECLARE Var_No CHAR(1);


	-- asignacion de constantes
    SET Cadena_Vacia := '';
	SET Var_SI := 'S';
	SET Var_No := 'N';



 ManejoErrores:BEGIN #bloque para manejar los posibles errores no controlados del codigo
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		 SET Par_NumErr := 999;
		 SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
		 'Disculpe las molestias que esto le ocasiona. Ref: SP-CRERECPAGLIBAGROPRO');
		 SET Var_Control := 'SQLEXCEPTION';
	END;

END ManejoErrores;

	SET Var_Refinancia := (SELECT Refinancia FROM CREDITOS WHERE CreditoID = Par_CreditoID);


	IF(IFNULL(Var_Refinancia, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Var_Refinancia := (SELECT Refinancia FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

		IF(IFNULL(Var_Refinancia, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Var_Refinancia := (SELECT Refinanciamiento FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);
		END IF;
	END IF;

	SET Var_Refinancia := (SELECT Refinanciamiento FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);
	#Refinancia intereses
	IF(Var_Refinancia = Var_SI) THEN
		CALL	`CRERECPAGLIBREFPRO`(
			Par_Monto,				Par_Tasa,				Par_ProducCreditoID,	Par_ClienteID,			Par_ComAper,
			Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,	Par_ComAnualLin,		Par_Salida,
            Par_NumErr, 			Par_ErrMen, 			Aud_EmpresaID , 		Aud_Usuario , 			Aud_FechaActual,
            Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion );
	ELSE
		#No refinancia
		CALL	`CRERECPAGLIBPRO`(
			Par_Monto,				Par_Tasa,				Par_ProducCreditoID,	Par_ClienteID,			Par_ComAper,
			Par_CobraSeguroCuota, 	Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,	Par_ComAnualLin,		Par_Salida,
            Par_NumErr , 			Par_ErrMen, 			Aud_EmpresaID , 		Aud_Usuario , 			Aud_FechaActual,
            Aud_DireccionIP , 		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion );
	END IF;

END TerminaStore$$