-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBDESEMBOLSOCREDWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBDESEMBOLSOCREDWSPRO`;
DELIMITER $$


CREATE PROCEDURE `CRCBDESEMBOLSOCREDWSPRO`(
# =====================================================================================
# ----- STORE PARA AUTORIZAR IMPRIMIR PAGARE Y DESEMBOLSAR UN CREDITO WS ------
# =====================================================================================
    Par_CreditoID		    BIGINT(12),				-- ID del credito
    Par_FechaInicioAmo		DATE,					-- FEcha de inicio de amortizaciones
    Par_FechaSis	        DATE,					-- Fecha del sistema
    Par_TipoPrepago 		CHAR(1),				-- Tipo de prepago de credito
    Par_PolizaID			BIGINT(20),				-- ID de la poliza

	Par_Salida 				CHAR(1),    			-- indica una salida
	INOUT	Par_NumErr	 	INT(11),				-- parametro numero de error
	INOUT	Par_ErrMen	 	VARCHAR(400),			-- mensaje de error

    Par_EmpresaID	    	INT(11),				-- parametros de auditoria
    Aud_Usuario	       		INT(11),				-- parametros de auditoria
    Aud_FechaActual			DATETIME ,				-- parametros de auditoria
    Aud_DireccionIP			VARCHAR(15),			-- parametros de auditoria
    Aud_ProgramaID	    	VARCHAR(70),			-- parametros de auditoria
    Aud_Sucursal	    	INT(11),				-- parametros de auditoria
    Aud_NumTransaccion		BIGINT(20)				-- parametros de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Poliza				BIGINT(12);			-- Numero de Poliza
	-- Declaracion de Constantes
    DECLARE Entero_Cero 		INT(11);				-- entero cero
    DECLARE Entero_Uno	 		INT(11);				-- entero uno
    DECLARE Decimal_Cero		DECIMAL(14,2);			-- DECIMAL Cero
    DECLARE Salida_SI 			CHAR(1);				-- salida SI
    DECLARE Fecha_Vacia 		DATE;					-- Fecha vacia
    DECLARE Cadena_Vacia 		CHAR(1);				-- cadena vacia
    DECLARE ConstanteNo			CHAR(1);				-- Constamnte no
    DECLARE ImprimePagare		INT(11);				-- numero de actualizacion para imprimir pagare de credito
    DECLARE AutorizaCredWS 		INT(11);				-- numero de actualizacion para actualizacion de credito
    DECLARE Var_Sucursal 		INT(11);			    -- Declaramos la variable Var_Sucursal para almacenar la variable encontrda en la consulta por el Crédito
    -- Asignacion de constantes
    SET Entero_Cero 		:= 0;
    SET Entero_Uno			:= 1;
    SET Decimal_Cero		:= 0.00;
    SET Salida_SI			:= 'S';
	SET Fecha_Vacia			:= '1900-01-01';
    SET Cadena_Vacia 		:= '';
    SET ConstanteNo			:= 'N';
 	SET ImprimePagare		:= 2;
    SET AutorizaCredWS 		:= 11;

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	    BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CRCBDESEMBOLSOCREDWSPRO');
		END;

		-- Asignamos valor a varibles
		SET Aud_FechaActual  	:= NOW();
		SET Var_Poliza			:= Par_PolizaID;

		-- Consultamos la Sucursal ID del Crédito
		SELECT Su.SucursalID INTO Var_Sucursal FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN SUCURSALES Su ON Cli.SucursalOrigen = Su.SucursalID
		WHERE CreditoID = Par_CreditoID;

		SET Aud_Sucursal := Var_Sucursal;

		-- Se genera llamda para generacion de pagare
		CALL CREGENAMORTIZAPRO(
			Par_CreditoID,		Par_FechaSis,		Par_FechaInicioAmo,	Par_TipoPrepago,	ConstanteNo,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se imprime pagare de credito
		CALL CREDITOSACT(
			Par_CreditoID,		Entero_Cero,			Fecha_Vacia,		Entero_Cero,		ImprimePagare,
			Fecha_Vacia,		Fecha_Vacia,			Decimal_Cero,		Decimal_Cero,		Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,			Entero_Cero,		ConstanteNo,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Autorizacion del credito Sin Checklist
		CALL CREDITOSACT(
			Par_CreditoID,		Entero_Cero,			Par_FechaSis,		Aud_Usuario,		AutorizaCredWS,
			Fecha_Vacia,		Fecha_Vacia,			Decimal_Cero,		Decimal_Cero,		Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,			Entero_Cero,		ConstanteNo,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Desembolso del credito 
		CALL MINISTRACREPRO(
			Par_CreditoID,		Var_Poliza,			ConstanteNo,		Par_NumErr,			Par_ErrMen,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Credito Desembolsado Exitosamente';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr			AS NumErr,
			Par_ErrMen			AS ErrMen;

	END IF;

END TerminaStore$$