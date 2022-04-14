-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDATASASPRODUCTOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDATASASPRODUCTOS`;DELIMITER $$

CREATE PROCEDURE `VALIDATASASPRODUCTOS`(
# ========================================================================
# --- SP PARA VALIDAR SI EXISTE PARAMETRIZACION DE CEDES, APORTACIONES ---
# ========================================================================
	Par_ClienteID				INT(11),			# ID del Cliente
	Par_TipoProducto			INT(11),			# Tipo de Producto Safi
	Par_ProductoSAFI			INT(11),			# Total de Productos SAFI
	Par_SucursalID				INT(11),			# SucursalID
	Par_NumValidacion			INT(11),			# Numero de Validacion

	Par_Salida    				CHAR(1), 			# Salida en Pantalla
    INOUT Par_NumErr 			INT,				# Numero de Error
	INOUT Par_ErrMen  			VARCHAR(400),		# Mensaje de error
	Aud_EmpresaID        		INT(11),			# ID de la Empresa
	Aud_Usuario         	 	INT(11),			# ID del usuario

	Aud_FechaActual      		DATETIME,			# Fecha Actual
	Aud_DireccionIP      		VARCHAR(20),		# Direccion IP
	Aud_ProgramaID       		VARCHAR(50),		# ID del programa
	Aud_Sucursal         		INT(11),			# ID de la sucursal
	Aud_NumTransaccion   		BIGINT(20)			# Numero de transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Valid_Cedes			INT(11);
	DECLARE Valid_Aporta		INT(11);
	DECLARE NumCuentaAhoID		BIGINT(12);

	-- Declaracion de Variables
	DECLARE Var_Calif			CHAR(1);
	DECLARE Var_Sucursal		INT(5);

	-- Asignacion de Constantes
	SET	Cadena_Vacia 			:= '';					-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Constante Entero Cero
	SET SalidaSI				:= 'S';					-- Constante Salida SI
	SET Valid_Cedes				:= 4;					-- Constante
	SET Valid_Aporta			:= 5;					-- Validar aportaciones
	SET NumCuentaAhoID			:= 0;					-- CuentaAhoID

	SELECT 		CalificaCredito,	SucursalOrigen
		INTO 	Var_Calif,			Var_Sucursal
		FROM 	CLIENTES
		WHERE 	ClienteID	= Par_ClienteID;


	IF(Par_NumValidacion = Valid_Cedes)THEN
		IF NOT EXISTS ( SELECT DISTINCT(TA.TipoCedeID),	TA.Calificacion,TAS.SucursalID
							FROM TASASCEDES TA
								INNER JOIN TASACEDESUCURSALES TAS ON(TA.TipoCedeID = TAS.TipoCedeID)
							WHERE 	TA.TipoCedeID 	= Par_TipoProducto
							AND 	TAS.SucursalID 	= Par_SucursalID
							AND 	TA.Calificacion = Var_Calif)THEN


		SET Par_NumErr := 036;
		SET Par_ErrMen := CONCAT('No Existe una Tasa Parametrizada para las Condiciones Indicadas.');
		END IF;
	END IF;

	IF(Par_NumValidacion = Valid_Aporta)THEN
		IF NOT EXISTS ( SELECT DISTINCT(TA.TipoAportacionID),	TA.Calificacion,TAS.SucursalID
							FROM TASASAPORTACIONES TA
								INNER JOIN TASAAPORTSUCURSALES TAS ON(TA.TipoAportacionID = TAS.TipoAportacionID)
							WHERE TA.TipoAportacionID = Par_TipoProducto
							AND TAS.SucursalID 	= Par_SucursalID
							AND TA.Calificacion = Var_Calif)THEN


		SET Par_NumErr := 036;
		SET Par_ErrMen := CONCAT('No Existe una Tasa Parametrizada para las Condiciones Indicadas.');
		END IF;
	END IF;


	IF(Par_Salida = SalidaSI)THEN
		SELECT CONVERT(Par_NumErr, CHAR(10)),
			Par_ErrMen AS Par_ErrMen,
			'tipoCuentaID' AS control,
			NumCuentaAhoID AS consecutivo;
			LEAVE TerminaStore;
	END IF;

END TerminaStore$$