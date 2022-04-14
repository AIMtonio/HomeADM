-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACARGOSDISPBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACARGOSDISPBAJ`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMACARGOSDISPBAJ`(
/* SP DE BAJA PARA REFERENCIAS DE PAGO POR TIPO DE CANAL E INSTRUMENTO */
	Par_ProductoCreditoID		INT(11), 		-- ID del producto de Crédito.
	Par_InstitucionID			INT(11), 		-- ID de INSTITUCIONES.
	Par_TipoDispersion			CHAR(1),		-- Corresponde a lo parámetrizado en el  Esquema de Calendario por producto.
	Par_TipoCargo				CHAR(1),		-- Indica si el tipo de cargo es por monto o por porcentaje. M.- Monto P.- Porcentaje
	Par_Nivel					INT(11),		-- Nivel, corresponde al catálogo NIVELCREDITO.

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
DECLARE	Var_Control     		CHAR(50);
DECLARE	Var_Consecutivo 		INT(11);
DECLARE Var_EstatusProducCred	CHAR(2);			-- Estatus del Producto Credito
DECLARE Var_Descripcion			VARCHAR(100);		-- Descripcion Producto Credito


-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI        	CHAR(1);
DECLARE	SalidaNO        	CHAR(1);
DECLARE Estatus_Inactivo    CHAR(1); 			-- Estatus Inactivo


-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Estatus_Inactivo	:= 'I';
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMACARGOSDISPBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

    SELECT 	Estatus, 				Descripcion
    INTO	Var_EstatusProducCred,	Var_Descripcion
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = IFNULL(Par_ProductoCreditoID, Entero_Cero);

	IF(Var_EstatusProducCred = Estatus_Inactivo) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control:= 'productoCreditoID' ;
		LEAVE ManejoErrores;
	END IF;

	DELETE
      FROM ESQUEMACARGOSDISP
		WHERE ProductoCreditoID = IFNULL(Par_ProductoCreditoID,Entero_Cero)
			AND InstitucionID = IFNULL(Par_InstitucionID,Entero_Cero)
			AND TipoDispersion = IFNULL(Par_TipoDispersion, Cadena_Vacia)
			AND TipoCargo = IFNULL(Par_TipoCargo, Cadena_Vacia)
			AND Nivel = IFNULL(Par_Nivel, Entero_Cero);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Esquema de Cargos Eliminado Exitosamente.';
	SET Var_Control:= 'productoCreditoID' ;
	SET Var_Consecutivo:= Par_ProductoCreditoID ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$