-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOPRODALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOPRODALT`;
DELIMITER $$

CREATE PROCEDURE `CALENDARIOPRODALT`(
/* ALTA DEL ESQUEMA DE CALENDARIOS DE PRODUCTO DE CREDITO.
 * */
	Par_ProduCredID			INT(11),		-- Numero de Producto de Credito
	Par_FecHabTom			CHAR(1),		-- Indica si se tomara la fecha habil
	Par_AjFecExVen			CHAR(1),		-- Ajustar Fecha Exigible a la fecha de vencimiento
	Par_PermCalIrr			CHAR(1),		-- Permite calendario irregular
	Par_AjFecUAmVe			CHAR(1),		-- Ajustar fecha de vencimiento de la ultima amortizacion a la fecha de vencimiento del credito

	Par_TipoPagCap			CHAR(15),		-- Tipo de pago de capital
	Par_IgCalInCap			CHAR(1),		-- Igualdad en calendario de capital e interes
	Par_Frecuenc			VARCHAR(200),	-- Frecuencia
	Par_PlazoID				TEXT,			-- Numero de plazo
	Par_DiaPagoCap			CHAR(1),		-- Dia de Pago de Capital

	Par_DiaPagoInt			CHAR(1),		-- Dia de Pago de Interes
	Par_TipoDisp			VARCHAR(100),	-- Tipo de disposicion
	Par_DiaPagoQuincenal	CHAR(1),		-- Dia de Pago solo para Frecuencia Quincenal.
	Par_DiasReqPrimerAmor	INT(11),		-- Dias requeridos para la primera amortizacion para Calendario Irregular de Frecuencia Libre
	Par_Salida				CHAR(1),		-- Salida S:SI  N:NO

    INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria ID de la Empresa
	Aud_Usuario				INT(11),		-- Parametro de Auditoria ID del Usuario
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP

	Aud_ProgramaID			VARCHAR(60),	-- Parametro de Auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria ID de la Sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Numero de la Transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Consecutivo	VARCHAR(50);
	DECLARE Var_NomControl  VARCHAR(50);
	DECLARE Var_Control		VARCHAR(100);
	DECLARE Var_NumPosicion	INT(11);
	DECLARE Var_Estatus		CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion	VARCHAR(100);	-- Almacena la descripcion del producto de credito

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	SalidaSI		CHAR(1);
	DECLARE	SalidaNO		CHAR(1);
	DECLARE	FrecQuinc		CHAR(1);
	DECLARE	CatDiaPagoQ		VARCHAR(50);
    DECLARE ConstanteSI		CHAR(1);
	DECLARE PagosLibres			CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	-- Asignacion  de constantes
	SET	Cadena_Vacia			:= '';		-- Constante Cadena Vacia
	SET	Entero_Cero				:= 0;		-- Constante Entero Cero
	SET	Decimal_Cero			:= 0.0;		-- Constante Decimal Cero
	SET	SalidaSI				:= 'S';		-- Constante SI
	SET	SalidaNO				:= 'N';		-- Constante NO
	SET	FrecQuinc				:= 'Q';		-- Frecuencia Quincenal.
	SET	CatDiaPagoQ				:= 'D,Q,I';	-- Tipos de día pago capital.
    SET ConstanteSI				:= 'S';		-- Constante: SI
	SET PagosLibres		   		:= 'L';		-- Tipo Pago Capital: LIBRES
	SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CALENDARIOPRODALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(IFNULL( Par_ProduCredID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'El Producto de Credito esta vacio';
			SET Var_NomControl  := 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

        IF (IFNULL( Par_FecHabTom, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 2;
			SET Par_ErrMen      := 'En Fecha Habil Tomar esta Vacia.';
			SET Var_NomControl  := 'fecHabilTomar';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL( Par_AjFecExVen, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'Ajustar Fecha Exigible a Vencimiento esta Vacia.';
			SET Var_NomControl  := 'ajusFecExigVenc';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL( Par_PermCalIrr, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 4;
			SET Par_ErrMen      := 'Permite Calendario Irregular esta Vacio.';
			SET Var_NomControl  := 'permCalenIrreg';
			LEAVE ManejoErrores;
		END IF;

        IF (IFNULL( Par_AjFecUAmVe, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 5;
			SET Par_ErrMen      := 'Ajustar fecha de ultima amortizacion a fecha de vencimiento del credito esta Vacio.';
			SET Var_NomControl  := 'ajusFecUlAmoVen';
			LEAVE ManejoErrores;
		END IF;

        IF (IFNULL( Par_TipoPagCap, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 6;
			SET Par_ErrMen      := 'Tipo Pago Capital esta Vacio.';
			SET Var_NomControl  := 'tipoPagoCapital';
			LEAVE ManejoErrores;
		END IF;


        IF (IFNULL( Par_IgCalInCap, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 7;
			SET Par_ErrMen      := 'Igualdad En Calendario De Interes y Capital esta Vacio.';
			SET Var_NomControl  := 'iguaCalenIntCap';
			LEAVE ManejoErrores;
		END IF;


		IF (IFNULL( Par_Frecuenc, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 8;
			SET Par_ErrMen      := 'La Frecuencia esta Vacia.';
			SET Var_NomControl  := 'frecuencias';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL( Par_PlazoID, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 9;
			SET Par_ErrMen      := 'El plazo esta Vacio.';
			SET Var_NomControl  := 'plazoID';
			LEAVE ManejoErrores;
		END IF;

        IF (IFNULL( Par_TipoDisp, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 10;
			SET Par_ErrMen      := 'El Tipo de Dispersion esta Vacio.';
			SET Var_NomControl  := 'plazoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Frecuenc, Cadena_Vacia) LIKE CONCAT('%',FrecQuinc,'%'))THEN
			IF(IFNULL(Par_DiaPagoQuincenal, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr      := 11;
				SET Par_ErrMen      := 'El Dia de Pago Quincenal esta Vacio.';
				SET Var_NomControl  := 'diaPagoQuincenal';
				LEAVE ManejoErrores;
			END IF;

			IF(FIND_IN_SET(IFNULL(Par_DiaPagoQuincenal, Cadena_Vacia),CatDiaPagoQ) = Entero_Cero)THEN
				SET Par_NumErr      := 12;
				SET Par_ErrMen      := 'El Dia de Pago Quincenal es Invalido.';
				SET Var_NomControl  := 'diaPagoQuincenal';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_DiaPagoQuincenal := Cadena_Vacia;
		END IF;

		SET Var_NumPosicion := (SELECT LOCATE(PagosLibres,Par_TipoPagCap));
        IF(Var_NumPosicion > Entero_Cero)THEN
            IF(IFNULL(Par_DiasReqPrimerAmor, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr      := 13;
				SET Par_ErrMen      := 'Dias Requeridos Primer Amortizacion esta Vacio.';
				SET Var_NomControl  := 'diasReqPrimerAmor';
				LEAVE ManejoErrores;
            END IF;
        END IF;

        SELECT 	Estatus,		Descripcion
		INTO 	Var_Estatus,	Var_Descripcion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Par_ProduCredID;

		IF(Var_Estatus = Estatus_Inactivo) THEN
			SET Par_NumErr 		:= 14;
			SET Par_ErrMen 		:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_NomControl	:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		INSERT CALENDARIOPROD (
			ProductoCreditoID, 	FecInHabTomar, 		AjusFecExigVenc,		PermCalenIrreg,			AjusFecUlAmoVen,
			TipoPagoCapital,	IguaCalenIntCap,	Frecuencias,			PlazoID,				DiaPagoCapital,
			DiaPagoInteres,		TipoDispersion, 	DiaPagoQuincenal,		DiasReqPrimerAmor,		EmpresaID,
            Usuario,			FechaActual,		DireccionIP, 			ProgramaID, 			Sucursal,
            NumTransaccion)
		VALUES (
			Par_ProduCredID,	Par_FecHabTom,		Par_AjFecExVen,			Par_PermCalIrr,			Par_AjFecUAmVe,
			Par_TipoPagCap,		Par_IgCalInCap,		Par_Frecuenc,			Par_PlazoID,			Par_DiaPagoCap,
			Par_DiaPagoInt,		Par_TipoDisp,		Par_DiaPagoQuincenal,	Par_DiasReqPrimerAmor,	Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
            Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Calendario por Producto Agregado Exitosamente: ' ,Par_ProduCredID) ;
		SET Var_Consecutivo := Par_ProduCredID;
		SET Var_NomControl	:= 'productoCreditoID';

	END ManejoErrores;

     IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$