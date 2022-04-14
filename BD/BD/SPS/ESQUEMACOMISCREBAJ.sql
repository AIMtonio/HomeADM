-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMISCREBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMISCREBAJ`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMISCREBAJ`(
	Par_ProducCreditoID INT(11),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore :BEGIN

    -- Declaracion de Variables
	DECLARE Var_Estatus			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion		VARCHAR(100);	-- Almacena la descripcion del producto de credito

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
    SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo

	SELECT 	Estatus,		Descripcion
	INTO 	Var_Estatus,	Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProducCreditoID;

	IF(IFNULL( Par_ProducCreditoID, Entero_Cero)) = Entero_Cero THEN
	SELECT  '001' AS NumErr,
			'El producto de Crédito esta vacio ' AS ErrMen,
			 'producCreditoID' AS control,
			Par_ProducCreditoID AS consecutivo;
			LEAVE TerminaStore;
	END IF;

	IF(Var_Estatus = Estatus_Inactivo) THEN
		SELECT '002' AS NumErr,
		CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
		'producCreditoID' AS control,
		 Par_ProducCreditoID AS consecutivo;
		 LEAVE TerminaStore;
	END IF;

	DELETE
		FROM 		ESQUEMACOMISCRE
		WHERE 	ProducCreditoID 	= Par_ProducCreditoID;

	SELECT  '000' AS NumErr,
			'Esquema del Producto de Crédito Eliminado Correctamente' AS ErrMen,
			 'producCreditoID' AS control,
			Par_ProducCreditoID AS consecutivo;

END TerminaStore$$