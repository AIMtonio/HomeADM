
-- TARBINPARAMSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBINPARAMSALT`;

DELIMITER $$
CREATE PROCEDURE `TARBINPARAMSALT`(
	# =====================================================================================
	# ------- STORED PARA ALTA DE BIN ---------
	# =====================================================================================
	Par_TarBinParamsID		INT(11), 		-- Idetinficador del bin
	Par_NumBIN				CHAR(8), 		-- Número de BIN
	Par_EsSubBin		 	CHAR(1), 		-- Identificador si aplica SubBin S-Si, N-No
	Par_EsBinMulEmp			CHAR(1), 		-- Identifica si es multibase S-Si, N-No
	Par_CatMarcaTarjetaID	INT(11), 		-- Numero de identificador de la tabla CATMARCATARJETA

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo			INT(14);		-- Variable consecutivo
	DECLARE Var_FolioTipoActivo		CHAR(11);		-- Consecutivo Interno
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Control
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema
	DECLARE Var_CatMarcaTarjetaID	INT(11);		-- Valida si existe en el cátalogo de la tabla CATMARCATARJETA
	DECLARE Var_NumBIN				CHAR(8);		-- variable para validar que no se duplique el BIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Cero			INT(1);				-- Constante Entero cero
	DECLARE Salida_SI			CHAR(1);			-- Parametro de salida SI
	DECLARE Salida_NO			CHAR(1);			-- Parametro de salida NO
	DECLARE CadenaN				CHAR(1);			-- Cadena N
	DECLARE CadenaS				CHAR(1);			-- Cadeba S
	DECLARE CadenaDosCeros		CHAR(2);			-- Cadena dos ceros

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET CadenaN					:= 'N';
	SET CadenaS					:= 'S';
	SET CadenaDosCeros			:= '00';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-TARBINPARAMSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Entero_Cero;
		SET Par_EsBinMulEmp := IFNULL(Par_EsBinMulEmp, CadenaN);
		SET Par_EsSubBin 	:= IFNULL(Par_EsSubBin, CadenaN);

		SET Var_NumBIN := (SELECT TarBinParamsID FROM TARBINPARAMS WHERE NumBIN = Par_NumBIN);

		IF(IFNULL(Var_NumBIN, Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Número de BIN ya existe';
			SET Var_Control		:= 'numBIN';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumBIN, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Número de BIN Esta Vacia';
			SET Var_Control		:= 'numBIN';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EsSubBin, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El Activador SubBin Esta Vacia';
			SET Var_Control		:= 'esSubBin';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EsSubBin NOT IN (CadenaN,CadenaS)) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El Activador SubBIN Con Valor Incorrecto';
			SET Var_Control		:= 'esBinMulEmp';
			LEAVE ManejoErrores;
		END IF;

		SELECT CatMarcaTarjetaID
			INTO Var_CatMarcaTarjetaID
		FROM CATMARCATARJETA
		WHERE CatMarcaTarjetaID = Par_CatMarcaTarjetaID;

		IF(IFNULL(Var_CatMarcaTarjetaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'La Marca de la Tarjeta no Éxiste en el Cátalogo';
			SET Var_Control		:= 'catMarcaTarjetaID';
			LEAVE ManejoErrores;
		END IF;

		-- Se evalua porque primero pasa por alta en base principal
		SET Aud_FechaActual := NOW();
		IF(IFNULL(Par_TarBinParamsID,Entero_Cero) = Entero_Cero)THEN
			SET Par_TarBinParamsID := (SELECT IFNULL(Max(TarBinParamsID),Entero_Cero) + 1 FROM TARBINPARAMS);
		END IF;

		INSERT INTO TARBINPARAMS (	TarBinParamsID, 		NumBIN, 			EsSubBin,			EsBinMulEmp,		CatMarcaTarjetaID,
									EmpresaID,				Usuario,			FechaActual,		DireccionIP,		ProgramaID,
									Sucursal,				NumTransaccion)
						VALUES(		Par_TarBinParamsID,		Par_NumBIN,			Par_EsSubBin,		Par_EsBinMulEmp,	Par_CatMarcaTarjetaID,
									Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
									Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('BIN Agregado Exitosamente:',CAST(Par_TarBinParamsID AS CHAR) );
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
