-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACOMDISPOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACOMDISPOSPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACOMDISPOSPRO`(
# =====================================================================================
# ----- SP QUE CANCELA LA COMISION POR DISPOSICION(Dispersion) DE UN CREDITO -----------------
# =====================================================================================
	Par_CreditoID			BIGINT(12),		# Numero de Credito
	Par_CuentaAhoID			BIGINT(12),		# Numero de Cuenta de Ahorro
	Par_ClienteID			INT(11),		# Numero de Cliente
	Par_InstitucionID		INT(11), 		# Numero de Institucion
	Par_Poliza				INT(11),		# Numero de Poliza

	Par_Salida    			CHAR(1), 		# Salida S:SI  N:NO
	INOUT Par_NumErr		INT,			# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),
	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_SucCliente			INT(11);			-- Sucursal del Cliente
    DECLARE Var_ProductoCreditoID	INT(11);			-- Producto de Credito
    DECLARE Var_TipoDispersion		CHAR(1);			-- Tipo de Dispersion
    DECLARE Var_ClasifCred			CHAR(1);			-- Clasificacion del Credito
	DECLARE Var_SubClasifID			INT(11);			-- Subclasificacion del Destino de Credito
    DECLARE Var_MontoCargoDisp		DECIMAL(14,2);		-- Monto del Cargo por Dispersion
    DECLARE Mon_Base				INT;				-- Moneda Base
	DECLARE Var_AltaMovAho			CHAR(1);    		-- Indica si se realizaran movimientos en las cuentas de ahorro
    DECLARE Fecha_Sistema			DATE;				-- Fecha del Sistema
	DECLARE Par_Consecutivo     	BIGINT(20);			-- Consecutivo
    DECLARE Var_Control         	VARCHAR(100);		-- Variable de Control
	DECLARE Var_NivelID				INT(11);			-- NivelId NIVELCREDITO.
	DECLARE Var_MontoCredito		DECIMAL(14,2);		-- Monto del Crédito
	DECLARE Var_TipoCargo			CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 			CHAR(1);
	DECLARE Entero_Cero  			INT(11);
	DECLARE Decimal_Cero 			DECIMAL(12,2);
    DECLARE DesCargoDisposicion		VARCHAR(100);
    DECLARE No_EmitePoliza      	CHAR(1);
    DECLARE AltaDetPol_Si			CHAR(1);
    DECLARE Var_NO					CHAR(1);
    DECLARE ConceptoCartera			INT(11);
    DECLARE Nat_Cargo           	CHAR(1);
    DECLARE Nat_Abono           	CHAR(1);
	DECLARE SI_AltaMovAho       	CHAR(1);
	DECLARE Tip_MovAhoCargoDisp    	CHAR(4);
    DECLARE Salida_NO				CHAR(1);
    DECLARE Salida_SI				CHAR(1);
    DECLARE TipoDisperOrden			CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
	SET Entero_Cero     			:= 0;		-- Constante Entero Cero
	SET Decimal_Cero    			:= 0;		-- Constante Decimal Cero
    SET DesCargoDisposicion			:= 'CANC. COMISION POR DISPOSICION DE CREDITO';
    SET No_EmitePoliza      		:= 'N';     -- NO Genera Encabezado de la Poliza Contable
    SET AltaDetPol_Si				:= 'S';		-- Indica si se realizan los detalles de la poliza
    SET Var_NO						:= 'N';		-- Constante NO
    SET ConceptoCartera				:= 59;		-- CONCEPTOSCARTERA: Cargo por Disposicion de Credito
	SET Nat_Abono					:= 'A';		-- Naturaleza del Movimiento: Abono
    SET Nat_Cargo					:= 'C';		-- Naturaleza del Movimiento: Cargo
    SET SI_AltaMovAho       		:= 'S';     -- Alta del Movimiento de Ahorro: SI
    SET Tip_MovAhoCargoDisp 		:= '228';   -- Tipo de Movimiento de Ahorro: CARGO POR DISPOSICION DE CREDITO
    SET Salida_NO           		:= 'N';     -- Llamada a Store Con Select de Salida
    SET Salida_SI           		:= 'S';     -- Llamada a Store sin Select de Salida
    SET TipoDisperOrden   			:= 'O';		-- Tipo de Dispersion por Orden de Pago

	SET Fecha_Sistema 	:= (SELECT  FechaSistema FROM PARAMETROSSIS);
    SET Mon_Base 		:= (SELECT  MonedaBaseID FROM PARAMETROSSIS);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELACOMDISPOSPRO');
				SET Var_Control := 'sqlexception';
			END;

		/* SE OBTIENE EL TIPO DE DISPERSION DEL CREDITO */
		SELECT
			Cli.SucursalOrigen,	Cre.ProductoCreditoID,	Cre.TipoDispersion,	Des.Clasificacion,	Des.SubClasifID
		INTO
			Var_SucCliente,		Var_ProductoCreditoID,	Var_TipoDispersion,	Var_ClasifCred,		Var_SubClasifID
		FROM CREDITOS Cre INNER JOIN
			CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID INNER JOIN
			DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE CreditoID = Par_CreditoID;

		/* SI EXISTE UN CARGO POR DISPOSICIÓN DE CRÉDITO APLICADO
		 * ENTONCES SE REALIZA EL MOVIMIENTO DE REVERSA AL COBRO. */
		IF(EXISTS(SELECT CreditoID FROM CARGOXDISPOSCRED
						WHERE CreditoID = Par_CreditoID AND Naturaleza = Nat_Cargo LIMIT 1))THEN
			/* SE OBTIENE EL MONTO DEL CARGO */
			SET Var_MontoCargoDisp	:= (SELECT MontoCargo FROM CARGOXDISPOSCRED WHERE CreditoID = Par_CreditoID
												AND Naturaleza = Nat_Cargo LIMIT 1);
			SET Var_MontoCargoDisp	:= IFNULL(Var_MontoCargoDisp, Entero_Cero);

            SET Var_AltaMovAho		:= SI_AltaMovAho;

            CALL CONTACREDITOSPRO (
				Par_CreditoID,				Entero_Cero,				Par_CuentaAhoID,		Par_ClienteID,			Fecha_Sistema,
				Fecha_Sistema,				Var_MontoCargoDisp,			Mon_Base,				Var_ProductoCreditoID,	Var_ClasifCred,
				Var_SubClasifID, 			Var_SucCliente,				DesCargoDisposicion,	DesCargoDisposicion,	No_EmitePoliza,
				Entero_Cero,				Par_Poliza, 				AltaDetPol_Si,			Var_NO,					ConceptoCartera,
				Entero_Cero,				Nat_Cargo,					Var_AltaMovAho,			Tip_MovAhoCargoDisp,	Nat_Abono,
				Cadena_Vacia,				Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,				Cadena_Vacia, 				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,				Aud_Sucursal,		 		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/* SE GUARDA EL MOVIMIENTO DEL CARGO POR DISPOSICION DEL CREDITO */
			CALL CARGOXDISPOSCREDALT(
				Par_CreditoID,		Par_CuentaAhoID,	Par_ClienteID,		Var_MontoCargoDisp,		Fecha_Sistema,
				Par_InstitucionID,	Cadena_Vacia,		Nat_Abono,			Salida_NO,				Par_NumErr,
                Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Comision por Disposicion Cancelada Exitosamente.';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
                    Var_Control 	AS control,
					Par_CreditoID AS consecutivo;
		END IF;

END TerminaStore$$