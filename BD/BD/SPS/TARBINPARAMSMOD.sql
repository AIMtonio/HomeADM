
-- TARBINPARAMSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBINPARAMSMOD`;

DELIMITER $$
CREATE PROCEDURE `TARBINPARAMSMOD`(
	# =====================================================================================
	# ------- STORED PARA MODIFICACION DE TARBINPARAMSMOD ---------
	# =====================================================================================
	Par_TarBinParamsID		INT(11), 		-- Idetinficador del bin
	Par_NumBIN				CHAR(8), 		-- Número de BIN
	Par_EsSubBin		 	CHAR(1), 		-- Identificador si aplica SubBin S-Si, N-No
	Par_EsBinMulEmp			CHAR(1), 		-- Identifica si es multibase S-Si, N-No, nota: ya Activo no se puede desactivar desde pantalla
	Par_CatMarcaTarjetaID	INT(11), 		-- Numero de identificador de la tabla CATMARCATARJETA

	Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Consecutivo			INT(14);   		-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   -- Variable de Control
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_EsDepreciado		CHAR(1);
	DECLARE Var_FechaRegistro		DATE;
 	DECLARE Var_PorDepFiscal		DECIMAL(16,2);	-- Porcentaje de Depreciacion Fiscal
	DECLARE Var_NumMeses			INT(11);		-- Numero de Meses
	DECLARE Var_EsBinMulEmp			CHAR(1);		-- Variable se obtiene de la tabla
	DECLARE Var_CatMarcaTarjetaID	INT(11);		-- Valida si existe en el cátalogo de la tabla CATMARCATARJETA

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Con_BinActivo		CHAR(1);

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Entero_Dos      	INT(11);      		-- Entero Dos
	DECLARE Cons_SI 			CHAR(1);
	DECLARE Cons_NO 			CHAR(1);
	DECLARE Reg_ProMasivo		CHAR(1);			-- Registro Proceso masivo
	DECLARE Reg_Automatico		CHAR(1);			-- Registro Proceso Automatico

	DECLARE Est_Baja			CHAR(2);
	DECLARE Llave_PorDepFiscalActivos	VARCHAR(50);	-- Porcentaue Depreciacion Fical para Activo
	DECLARE Llave_CentroCostoActivo		VARCHAR(50);	-- Centro de Costo por Defecto

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Entero_Dos          	:= 2;
	SET Cons_SI 				:= 'S';
	SET Cons_NO 				:= 'N';
	SET Reg_ProMasivo			:= 'P';
	SET Reg_Automatico			:= 'A';
	SET Con_BinActivo			:= 'S';

	SET Est_Baja 				:= 'BA';
	SET Llave_PorDepFiscalActivos	:= 'MaxPorDepFiscalActivos';
	SET Llave_CentroCostoActivo 	:= 'DefatulCentroCostoActivos';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-TARBINPARAMSMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Entero_Cero;
		IF(IFNULL(Par_NumBIN, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Número de BIN Esta Vacia';
			SET Var_Control		:= 'numBIN';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EsSubBin, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Activador SubBin Esta Vacia';
			SET Var_Control		:= 'esSubBin';
			LEAVE ManejoErrores;
		END IF;

		SELECT CatMarcaTarjetaID
			INTO Var_CatMarcaTarjetaID
		FROM CATMARCATARJETA
		WHERE CatMarcaTarjetaID = Par_CatMarcaTarjetaID;

		IF(IFNULL(Var_CatMarcaTarjetaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'La Marca de la Tarjeta no Éxiste en el Cátalogo';
			SET Var_Control		:= 'catMarcaTarjetaID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE TARBINPARAMS SET
			NumBIN 				= Par_NumBIN,
			EsSubBin 			= Par_EsSubBin,
			-- EsBinMulEmp 		= Par_EsBinMulEmp,
			CatMarcaTarjetaID 	= Par_CatMarcaTarjetaID,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE TarBinParamsID 	= Par_TarBinParamsID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('BIN Modificado Exitosamente:',CAST(Par_TarBinParamsID AS CHAR) );
		SET Var_Control		:= 'tarBinParamsID';
		SET Var_Consecutivo	:= Par_TarBinParamsID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
