-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMATASASBAJ`;
DELIMITER $$

CREATE PROCEDURE `ESQUEMATASASBAJ`(
# =====================================================================================
# ------- STORED PARA BAJA DE ESQUEMA DE TASAS ---------
# =====================================================================================
	Par_SucursalID 			INT,
	Par_ProdCreID 			INT,
	Par_MinCredito			INT,
	Par_MaxCredito			INT,
	Par_Califi				VARCHAR(45),

    Par_MontoInf			DECIMAL(12,2),
	Par_MontoSup			DECIMAL(12,2),
	Par_PlazoID				VARCHAR(20),
	Par_TasaFija			DECIMAL(12,4),
	Par_SobreTasa			DECIMAL(12,4),

    Par_InstitNominaID		INT(11),				-- ID De la Institucion de Nomina
	Par_NivelID				INT(11), 				-- ID de nivel de credito

    Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT,
	INOUT Par_ErrMen    	VARCHAR(400),

    Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE 	Var_Control 	VARCHAR(50);
	DECLARE 	Var_Consecutivo	VARCHAR(50);
	DECLARE 	Var_Delnull		INT;
	DECLARE 	Var_Estatus		CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE 	Var_Descripcion	VARCHAR(100);	-- Almacena la descripcion del producto de credito

	-- Declaracion de constantes
	DECLARE		Cadena_Vacia	CHAR(1);
	DECLARE		Entero_Cero		INT;
	DECLARE		Float_Cero		FLOAT;
	DECLARE		Decimal_Cero	DECIMAL(12,2);
	DECLARE		SalidaSI		CHAR(1);
	DECLARE		SalidaNO		CHAR(1);
	DECLARE 	Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET	Float_Cero		:= 0.0;
	SET	Decimal_Cero	:= 0.0;
	SET	SalidaSI		:= 'S';
	SET	SalidaNO		:= 'N';
	SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMATASASBAJ');
			SET Var_Control = 'sqlException' ;
		END;

	SELECT SucursalID INTO Var_Delnull
			FROM ESQUEMATASAS
					WHERE  SucursalID 			= Par_SucursalID
					AND	   ProductoCreditoID 	= Par_ProdCreID
					AND    MinCredito			= Par_MinCredito
					AND    MaxCredito			= Par_MaxCredito
					AND    Calificacion			= Par_Califi
					AND    MontoInferior		= Par_MontoInf
					AND    MontoSuperior		= Par_MontoSup
					AND	   PlazoID				= Par_PlazoID
					AND    TasaFija				= Par_TasaFija
					AND    SobreTasa			= Par_SobreTasa
                    AND	   InstitNominaID		= Par_InstitNominaID
                    AND	   NivelID				= Par_NivelID;

	IF IFNULL(Var_Delnull, Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr 		:= 001;
		SET Par_ErrMen 		:= 'Esquema de Tasa no Encontrado';
		SET Var_Control		:= 'sucursalID';
		SET Var_Consecutivo	:= Par_SucursalID;
		LEAVE ManejoErrores;
	END IF;

	SELECT 	Estatus,		Descripcion
	INTO 	Var_Estatus,	Var_Descripcion
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProdCreID;

	IF(Var_Estatus = Estatus_Inactivo) THEN
		SET Par_NumErr 	:= 16;
		SET Par_ErrMen 	:= CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control	:= 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	DELETE
	FROM ESQUEMATASAS
			WHERE  SucursalID 			= Par_SucursalID
			AND	   ProductoCreditoID 	= Par_ProdCreID
			AND    MinCredito			= Par_MinCredito
			AND    MaxCredito			= Par_MaxCredito
			AND    Calificacion			= Par_Califi
			AND    MontoInferior		= Par_MontoInf
			AND    MontoSuperior		= Par_MontoSup
			AND	   PlazoID				= Par_PlazoID
			AND    TasaFija				= Par_TasaFija
			AND    SobreTasa			= Par_SobreTasa
			AND	   InstitNominaID  		= Par_InstitNominaID
			AND	   NivelID				= Par_NivelID;

	SET Par_NumErr := 0;
	SET Par_ErrMen := 'Esquema de Tasa Eliminado Exitosamente.';
	SET Var_Control:= 'sucursalID';
	SET Var_Consecutivo:= Par_SucursalID;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN

	SELECT
	    Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$