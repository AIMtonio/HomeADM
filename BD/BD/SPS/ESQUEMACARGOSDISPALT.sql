-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACARGOSDISPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACARGOSDISPALT`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMACARGOSDISPALT`(
/* SP DE ALTA EL ESQUEMA DE CARGOS POR DISPOSICION DE CREDITOS. */
	Par_ProductoCreditoID		INT(11), 		-- ID del producto de Crédito.
	Par_InstitucionID			INT(11), 		-- ID de INSTITUCIONES.
	Par_NombInstitucion			VARCHAR(100),	-- Nombre largo de la Institucion.
	Par_TipoDispersion			CHAR(1),		-- Corresponde a lo parámetrizado en el  Esquema de Calendario por producto.
	Par_TipoCargo				CHAR(1),		-- Indica si el tipo de cargo es por monto o por porcentaje. M.- Monto P.- Porcentaje

	Par_Nivel					INT(11),		-- Nivel, corresponde al catálogo NIVELCREDITO.
	Par_MontoCargo 				DECIMAL(14,2),	-- Monto del cargo por disposición.
    Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error

    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     		VARCHAR(50);
DECLARE Var_EstatusProducCred	CHAR(2);			-- Estatus del Producto Credito
DECLARE Var_Descripcion			VARCHAR(100);		-- Descripcion Producto Credito


-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE TipoMonto	 		CHAR(1);
DECLARE TipoPorcentaje		CHAR(1);
DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo


-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero				:= 0;				-- Entero Cero
SET	SalidaSI        		:= 'S';				-- Salida Si
SET	SalidaNO        		:= 'N'; 			-- Salida No
SET TipoMonto	 			:= 'M';				-- Tipo cargo por Monto.
SET TipoPorcentaje			:= 'P';				-- Tipo cargo por Porcentaje.
SET Estatus_Inactivo		:= 'I';
SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMACARGOSDISPALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ProductoCreditoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Producto de Credito esta Vacio.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID=IFNULL(Par_ProductoCreditoID, Entero_Cero))) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Producto de Credito No Existe.';
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'La Institucion Bancaria esta Vacia.';
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT InstitucionID FROM INSTITUCIONES WHERE InstitucionID=IFNULL(Par_InstitucionID, Entero_Cero))) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Institucion Bancaria No Existe o No es Valida.';
		SET Var_Control:= 'institucionID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_TipoDispersion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El Tipo de Dispersion esta vacio.';
		SET Var_Control:= 'tipoDispersion' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCargo, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'El Tipo de Cargo esta vacio.';
		SET Var_Control:= 'tipoCargo' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Nivel, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Nivel esta vacio.';
		SET Var_Control:= 'nivel' ;
		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT ProductoCreditoID FROM ESQUEMACARGOSDISP
		WHERE ProductoCreditoID=IFNULL(Par_ProductoCreditoID, Entero_Cero)
			AND InstitucionID = IFNULL(Par_InstitucionID, Entero_Cero)
			AND TipoDispersion = IFNULL(Par_TipoDispersion, Cadena_Vacia)
			AND TipoCargo = IFNULL(Par_TipoCargo, Cadena_Vacia)
			AND Nivel = IFNULL(Par_Nivel, Entero_Cero))) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := CONCAT('El Esquema de Cargos por Disposicion Ya Existe.');
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
    END IF;

	IF(IFNULL(Par_MontoCargo, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'El Monto debe ser Mayor a Cero.';
		SET Var_Control:= 'montoCargo' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCargo, Cadena_Vacia) = TipoPorcentaje)THEN
		IF(IFNULL(Par_MontoCargo, Entero_Cero) > 100)THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El Porcentaje de Cargo No debe ser Mayor al 100%.';
			SET Var_Control:= 'montoCargo' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_NombInstitucion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NombInstitucion := (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID=IFNULL(Par_InstitucionID, Entero_Cero));
		SET Par_NombInstitucion := IFNULL(Par_NombInstitucion, Cadena_Vacia);
	END IF;

	SELECT 	Estatus, 				Descripcion
    INTO	Var_EstatusProducCred,	Var_Descripcion
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = IFNULL(Par_ProductoCreditoID, Entero_Cero);

	IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO ESQUEMACARGOSDISP(
		ProductoCreditoID,		InstitucionID,			NombInstitucion,	TipoDispersion,			TipoCargo,
		Nivel,					MontoCargo,				EmpresaID,			Usuario,				FechaActual,
		DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
	VALUES(
		Par_ProductoCreditoID,	Par_InstitucionID,		Par_NombInstitucion,Par_TipoDispersion,		Par_TipoCargo,
		Par_Nivel,				Par_MontoCargo,			Aud_EmpresaID,		Aud_Usuario, 			Aud_FechaActual,
        Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Esquema de Cargo Grabado Exitosamente.';
	SET Var_Control:= 'productoCreditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_ProductoCreditoID AS Consecutivo;
END IF;

END TerminaStore$$