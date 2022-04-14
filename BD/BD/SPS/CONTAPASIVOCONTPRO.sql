-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAPASIVOCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAPASIVOCONTPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTAPASIVOCONTPRO`(
# ==================================================================
# ----   STORE PARA CONTABILIDAD DE CREDITOS PASIVOS CONTINGENTES---
# ===================================================================
	Par_CreditoFondeoID		BIGINT(20),			-- ID del credito de fondeo
	Par_ConceptoOpera		INT,				-- Concepto de operacion, corresponde con la tabla CONCEPTOSFONDEO
	Par_MonedaID			INT,				-- Moneda o Divisa
	Par_DescripcionMov		VARCHAR(100),		-- Descripcion de la Operacion
	Par_FechaAplicacion		DATE,				-- Fecha de Aplicacion del Movimiento

	Par_Monto				DECIMAL(14,2),		-- Monto de la operacion
	Par_NatOpeFon			CHAR(1),			-- Indica la naturaleza operativa de fondeo

	Par_Salida				CHAR(1),
	INOUT	Par_Poliza		BIGINT,
	INOUT	Par_Consecutivo	BIGINT,
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Cargos  			DECIMAL(14,4);
	DECLARE Var_Abonos  			DECIMAL(14,4);
	DECLARE Var_CuentaStr   		VARCHAR(20);
	DECLARE Var_CreditoStr  		VARCHAR(20);
	DECLARE Var_Control				VARCHAR(100);				-- Variable de control
	DECLARE Var_ConGaranFira		INT(11);
	DECLARE Var_ExisteConcepto		INT(11);
	DECLARE	Var_Consecutivo			VARCHAR(20);				-- Variable consecutivo
	DECLARE Var_CreditoID 			BIGINT(12);
	DECLARE Var_ProdCreditoID		INT(11);
	DECLARE Var_Clasificacion		CHAR(1);            		-- clasificacion del credito
	DECLARE	Var_SucCliente			INT(11);
	DECLARE Var_SubClasifica		INT(11);
	DECLARE Var_NaturalezaCon		CHAR(11);
    DECLARE Var_EsContingente		CHAR(1);
    DECLARE Var_TipoGarantiaFIRAID	INT(11);
    DECLARE Var_ConGaranOrden		INT(11);
    DECLARE Var_ConGaranCor			INT(11);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Decimal_Cero    DECIMAL(12, 2);
	DECLARE AltaPoliza_SI   CHAR(1);
	DECLARE AltaMovAho_SI   CHAR(1);
	DECLARE AltaMovCre_SI   CHAR(1);
	DECLARE AltaPolCre_SI   CHAR(1);
	DECLARE Nat_Cargo       CHAR(1);
	DECLARE Nat_Abono       CHAR(1);
	DECLARE Pol_Automatica  CHAR(1);
	DECLARE Salida_No       CHAR(1);
	DECLARE Deudora		 	CHAR(1);
	DECLARE Acreedora       CHAR(1);
	DECLARE Con_AhoCapital  INT;
	DECLARE	Salida_SI		CHAR(1);
	DECLARE GarantiaFega	INT(11);
	DECLARE GarantiaFonaga	INT(11);
	DECLARE Entero_Cien		INT(11);
    DECLARE Constante_NO	CHAR(1);
    DECLARE Con_Capital		INT(11);
	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0.00;
	SET Entero_Cien		:= 100;
	SET AltaPoliza_SI	:= 'S';
	SET AltaMovAho_SI	:= 'S';
	SET AltaMovCre_SI	:= 'S';
	SET AltaPolCre_SI	:= 'S';
	SET Nat_Cargo		:= 'C';
	SET Nat_Abono		:= 'A';
	SET Pol_Automatica	:= 'A';
	SET Salida_No		:= 'N';
	SET Con_AhoCapital	:= 1;
	SET Salida_SI		:= 'S';
	SET Aud_FechaActual := NOW();
	SET GarantiaFega	:= 1;
	SET GarantiaFonaga	:= 2;
	SET Deudora			:= 'D';
	SET Acreedora		:= 'A';
    SET Constante_NO	:= 'N';
    SET Con_Capital		:= 1;

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAPASIVOCONTPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

        -- Verificamos que el credito es contingente
        SELECT EsContingente,	 TipoGarantiaFIRAID
			INTO Var_EsContingente, Var_TipoGarantiaFIRAID
		FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFondeoID;

		IF IFNULL(Var_EsContingente,Constante_NO)=Constante_NO THEN
        	SET Par_NumErr:= 1;
        	SET Par_ErrMen:= CONCAT('El Credito Pasivo no es Contingente.');
        	LEAVE ManejoErrores;
        END IF;

        -- tkt 16927 - se agrega cambio para aplicar el pago y contabilidad
        IF Var_TipoGarantiaFIRAID = 3 THEN
        	SET Var_TipoGarantiaFIRAID := 1;
        END IF;
        -- fin tkt 16927

        IF(Var_TipoGarantiaFIRAID <>GarantiaFega AND Var_TipoGarantiaFIRAID <>GarantiaFonaga)THEN
        	SET Par_NumErr:= 2;
        	SET Par_ErrMen:= 'El Tipo de Garantia Fira Aplicado No Existe.';
        	LEAVE ManejoErrores;
        END IF;

        -- obtener valores para poliza
		SELECT  Cre.CreditoID,  Cre.ProductoCreditoID,    Cre.ClasiDestinCred, 	Cli.SucursalOrigen,	Des.SubClasifID
			INTO Var_CreditoID,  Var_ProdCreditoID,        Var_Clasificacion,	Var_SucCliente,     Var_SubClasifica
		FROM  CLIENTES Cli,	DESTINOSCREDITO Des, CREDITOSCONT Cre
			WHERE Cre.CreditoFondeoID = Par_CreditoFondeoID
				AND Cre.ClienteID = Cli.ClienteID
				AND Cre.DestinoCreID = Des.DestinoCreID;

        -- Asignar naturalezas del movimiento
		IF(Par_NatOpeFon = Nat_Cargo) THEN
			SET	Var_Cargos		  := Par_Monto;
			SET	Var_Abonos		  := Decimal_Cero;
		ELSE
			SET	Var_Cargos		  := Decimal_Cero;
			SET	Var_Abonos	      := Par_Monto;
		END IF;

		SET Var_CreditoStr	:= CONCAT("Cred.",CONVERT(Par_CreditoFondeoID, CHAR(20)));

         IF (Par_ConceptoOpera != Con_Capital)THEN
			/* Se asignara el concepto de acuerdo al tipo de garantia aplicada
			y concepto de fondeo que se este evaluando */
			SET Var_ConGaranFira:= CASE WHEN Par_ConceptoOpera = 13 THEN 66
										WHEN Par_ConceptoOpera = 14 THEN 67
										WHEN Par_ConceptoOpera = 8 AND Var_TipoGarantiaFIRAID = GarantiaFonaga  THEN 68
										WHEN Par_ConceptoOpera = 8 AND Var_TipoGarantiaFIRAID = GarantiaFega    THEN 69
								   END;

			/*se hace llamado a POLIZASCREDITOSCONTPRO para realizar el armado de la cuenta con los parametros de cartera*/
			CALL POLIZASCREDITOCONTPRO(
				Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Var_CreditoID,      Var_ProdCreditoID,
				Var_SucCliente,     Var_ConGaranFira,   Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
				Var_Abonos,         Par_MonedaID,       Par_DescripcionMov,     Var_CreditoStr,     Salida_No,
				Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    	Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        ELSE
			IF(Var_TipoGarantiaFIRAID = GarantiaFonaga)THEN
				SET Var_ConGaranFira	:= 60;
                SET Var_ConGaranOrden	:= 62;
                SET Var_ConGaranCor		:= 63;
            ELSE
				SET Var_ConGaranFira	:= 61;
                SET Var_ConGaranOrden	:= 64;
                SET Var_ConGaranCor		:= 65;

            END IF;

			/*se hace llamado a POLIZASCREDITOSCONTPRO Aplicación de Garantias  (Resultados. Egresos - pago credito) CARGO */
            SET	Var_Cargos		  := Par_Monto;
			SET	Var_Abonos		  := Decimal_Cero;

			CALL POLIZASCREDITOCONTPRO(
				Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Var_CreditoID,      Var_ProdCreditoID,
				Var_SucCliente,     Var_ConGaranFira,   Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
				Var_Abonos,         Par_MonedaID,       Par_DescripcionMov,     Var_CreditoStr,     Salida_No,
				Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    	Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

            /*se hace llamado a POLIZASCREDITOSCONTPRO Cta. Orden Garantia FONAGA/FEGA ABONO */

            SET	Var_Cargos		  := Decimal_Cero;
			SET	Var_Abonos	      := Par_Monto;

			CALL POLIZASCREDITOCONTPRO(
				Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Var_CreditoID,      Var_ProdCreditoID,
				Var_SucCliente,     Var_ConGaranOrden,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
				Var_Abonos,         Par_MonedaID,       Par_DescripcionMov,     Var_CreditoStr,     Salida_No,
				Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    	Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

             /*se hace llamado a POLIZASCREDITOSCONTPRO Corr. Cta. Orden Garantia FONAGA/FEGA CARGO */
			SET	Var_Cargos		  := Par_Monto;
			SET	Var_Abonos		  := Decimal_Cero;

			CALL POLIZASCREDITOCONTPRO(
				Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Var_CreditoID,      Var_ProdCreditoID,
				Var_SucCliente,     Var_ConGaranCor,    Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
				Var_Abonos,         Par_MonedaID,       Par_DescripcionMov,     Var_CreditoStr,     Salida_No,
				Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    	Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

        SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Informacion Procesada Exitosamente.');
		SET Var_Control	:= 'creditoFondeoID' ;
		SET Var_Consecutivo := IFNULL(Par_Consecutivo, Entero_Cero);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$