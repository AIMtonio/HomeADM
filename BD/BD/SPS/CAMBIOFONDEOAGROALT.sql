-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOFONDEOAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOFONDEOAGROALT`;
DELIMITER $$

CREATE PROCEDURE `CAMBIOFONDEOAGROALT`(
# =====================================================================================
# ----- STORE PARA ALTRA CAMBIO DE FUENTE DE FONDEADOR DE UN CREDITO AGROPECUARIO---
# =====================================================================================
    Par_CreditoID		    BIGINT(12),			-- ID del credito
    Par_FechaRegistro		DATE,				-- Fecha de registro del cambio
	Par_Monto				DECIMAL(16,2),		-- adeudo del credito al momento del cambio
    Par_LineaFondeoIDAnt   	INT(11),			-- Linea de Fondeo anterior, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondIDAnt	INT(11),			-- id de institucion anterior de fondeo corresponde con la tabla INSTITUTFONDEO

	Par_CreditoPasIDAnt		BIGINT(12),			-- ID del credito pasivo anterior
	Par_LineaFondeoID   	INT(11),			-- Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondID		INT(11),			-- id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	Par_CreditoPasivoID		BIGINT(12),			-- ID del credito pasivo nuevo
	Par_UsuarioID			INT(11),			-- ID usuario que realiza autorizacion

	Par_Salida 				CHAR(1),    		-- indica una salida
	INOUT	Par_NumErr	 	INT(11),			-- parametro numero de error
	INOUT	Par_ErrMen	 	VARCHAR(400),		-- mensaje de error

    Par_EmpresaID	    	INT(11),			-- parametros de auditoria
    Aud_Usuario	       		INT(11),			-- parametros de auditoria
    Aud_FechaActual			DATETIME ,			-- parametros de auditoria
    Aud_DireccionIP			VARCHAR(15),		-- parametros de auditoria
    Aud_ProgramaID	    	VARCHAR(70),		-- parametros de auditoria
    Aud_Sucursal	    	INT(11),			-- parametros de auditoria
    Aud_NumTransaccion		BIGINT(20)			-- parametros de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_FechaSis 			DATE;				-- Fecha del sistema
	DECLARE Var_CreditoID			BIGINT(12);			-- ID del credito
	DECLARE Var_EstatusC			CHAR(1);			-- Estatus del credito
	DECLARE Var_CuentaID			BIGINT(12);			-- ID de la cuenta
	DECLARE Var_ClienteID			INT(11);			-- Id del cliente
	DECLARE Var_SaldoDispo			DECIMAL(12,2);		-- Saldo disponible de la cuenta
	DECLARE Var_Consecutivo			BIGINT(12);			-- Consecutivo
    DECLARE Var_Control				VARCHAR(100);		-- control de pantalla
    DECLARE Var_LineaFondeoID		INT(11);			-- ID linea de fondeo
	DECLARE Var_InstitutFondID		INT(11);			-- ID instituto de fondeo

	-- Declaracion de Constantes
    DECLARE Entero_Cero 		INT(11);			-- entero cero
    DECLARE Entero_Uno	 		INT(11);			-- entero uno
    DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL Cero
    DECLARE Salida_SI 			CHAR(1);			-- salida SI
    DECLARE Fecha_Vacia 		DATE;				-- Fecha vacia
    DECLARE Cadena_Vacia 		CHAR(1);			-- cadena vacia
    DECLARE ConstanteNo			CHAR(1);			-- Constamnte no

    -- Asignacion de constantes
    SET Entero_Cero 	:= 0;
    SET Entero_Uno		:= 1;
    SET Decimal_Cero	:= 0.00;
    SET Salida_SI		:= 'S';
	SET Fecha_Vacia		:= '1900-01-01';
    SET Cadena_Vacia 	:= '';
    SET ConstanteNo		:= 'N';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
			concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CAMBIOFONDEOAGROALT');
		SET Var_Control := 'sqlexception';
	END;

		-- Asignamos valor a varibles
		SET Aud_FechaActual  	:= NOW();
		SET Var_FechaSis 	 	:= (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
									WHERE EmpresaID = Par_EmpresaID);
		SET Var_Consecutivo		:= Entero_Cero;


		-- validaciones
		IF(IFNULL(Par_CreditoID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen 		:= 'El Numero de Credito Esta Vacio.';
            SET Var_Control  	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitutFondID,Entero_Cero))!= Entero_Cero THEN
			IF(IFNULL(Par_LineaFondeoID,Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 		:= 2;
				SET	Par_ErrMen 		:= 'La Linea de Fondeo esta Vacia.';
				SET Var_Control  	:= 'lineaFondeoID';
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_CreditoPasivoID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'El Numero de Credito Pasivo esta Vacio';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_CreditoPasivoID:=IFNULL(Par_CreditoPasivoID,Entero_Cero);
		END IF;

		IF(IFNULL(Par_UsuarioID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Usuario esta Vacio';
			SET Var_Control := 'claveUsuarioAut';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaRegistro,Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Fecha esta Vacia';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr  := 9;
			SET Par_ErrMen  := 'El Saldo Total del Credito debe ser Mayor a Cero.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaRegistro> Var_FechaSis)THEN
			SET Par_NumErr  := 10;
			SET Par_ErrMen  := 'La Fecha es Mayor a la del Sistema.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

         INSERT INTO CAMBIOFONDEOAGRO(
			CreditoID, 			FechaRegistro,		MontoCredito, 		InstitFondeoIDAnt, 	LineaFondeoAnt,
            CreditoPasivoIDAnt, InstitFondeoID, 	LineaFondeo, 		CreditoPasivoID, 	UsuarioAutoriza,
            EmpresaID,			Usuario, 			FechaActual, 		DireccionIP, 		ProgramaID,
            Sucursal, 			NumTransaccion)
		VALUES (
			Par_CreditoID,			Par_FechaRegistro, 		Par_Monto, 			Par_InstitutFondIDAnt, 		Par_LineaFondeoIDAnt,
            Par_CreditoPasIDAnt,	Par_InstitutFondID,		Par_LineaFondeoID, 	Par_CreditoPasivoID, 		Par_UsuarioID,
            Par_EmpresaID, 			Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP, 			Aud_ProgramaID,
            Aud_Sucursal, 			Aud_NumTransaccion );

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Cambio Fondeador Registrado Exitosamente';
        SET Var_Consecutivo	:= Par_CreditoID;
        SET Var_Control		:= 'creditoID';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
				Par_NumErr          AS NumErr,
                Par_ErrMen          AS ErrMen,
                Var_Control         AS control,
                Var_Consecutivo     AS consecutivo;

	END IF;

END TerminaStore$$