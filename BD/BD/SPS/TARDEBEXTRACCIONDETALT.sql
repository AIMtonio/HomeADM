-- TARDEBEXTRACCIONDETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS TARDEBEXTRACCIONDETALT;
DELIMITER $$

CREATE PROCEDURE TARDEBEXTRACCIONDETALT(
	Par_TarDebExtraccionID 	INT(11),			-- ID de la tabla de Extraccion.

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen	  	VARCHAR(400),		-- Parametro de salida mensaje de error

    Aud_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		BIGINT;   			-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_TarDebExtID		INT(11);			-- ID del extraccion de archivo
	DECLARE Var_TipoArchivo		CHAR(1);			-- Tipo de Archivo (E = EMI, S = STATS)
	DECLARE Var_Tarjeta 		VARCHAR(18);		-- Numero de tarjeta
	DECLARE Var_Bin 			VARCHAR(8);			-- Bin de la tarjeta
	DECLARE Var_SubBin 			VARCHAR(2);			-- SubBin de la tarjeta
	DECLARE Var_TipoTarjetaID	INT(11);			-- Id del Tipo de tarjeta
	DECLARE Var_NomArchivo 		VARCHAR(50);		-- Nombre de Archivo
	DECLARE Var_RutaArchivos	VARCHAR(150);		-- Carpeta de archivos

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Arch_EMI 			CHAR(1);			-- Tipo de archivo EMI
	DECLARE Arch_STATS 			CHAR(1);			-- Tipo de archivo STATS

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';				-- Constante cadena vacia ''
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha vacia 1900-01-01
	SET Entero_Cero         	:= 0;				-- Constante Entero cero 0
	SET Decimal_Cero			:= 0.0;				-- DECIMAL cero
	SET Salida_SI          		:= 'S';				-- Parametro de salida SI
	SET Salida_NO           	:= 'N';				-- Parametro de salida NO
	SET Entero_Uno          	:= 1;				-- Entero Uno
	SET Arch_EMI 				:= 'E';				-- Tipo de archivo EMI
	SET Arch_STATS 				:= 'S';				-- Tipo de archivo STATS

	-- Asignacion de valores por Defecto
	SET Par_TarDebExtraccionID := IFNULL(Par_TarDebExtraccionID, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-TARDEBEXTRACCIONDETALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(Par_TarDebExtraccionID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el ID de la Extraccion de archivo.';
			SET Var_Control := 'tarDebExtraccionID';
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		TarDebExtraccionID,			Tipo,					NomArchivo
			INTO 	Var_TarDebExtID,			Var_TipoArchivo,		Var_NomArchivo
			FROM TARDEBEXTRACCION
			WHERE TarDebExtraccionID = Par_TarDebExtraccionID;

		IF(IFNULL(Var_TarDebExtID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'No se encontro informacion del ID de Extraccion de archivo.';
			SET Var_Control := 'tarDebExtraccionID';
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		DROP TABLE IF EXISTS TMP_TARDEBEXTRACCION;
		CREATE TEMPORARY TABLE TMP_TARDEBEXTRACCION(
			TarDebExtraccionID 	INT(11),
			Bin 				VARCHAR(8),
			SubBin 				VARCHAR(2),
			NomArchivo 			VARCHAR(70),

			PRIMARY KEY (Bin, SubBin)
		);

		INSERT INTO TMP_TARDEBEXTRACCION
			SELECT 		Var_TarDebExtID,		Bin, 		SubBin,		CONCAT(Var_NomArchivo, '_', Bin, SubBin)
				FROM TMPTARDEBEXTRACCION
				WHERE TarDebExtraccionID = Par_TarDebExtraccionID
				AND TipoTarjetaDebID <> Entero_Cero
				GROUP BY TarDebExtraccionID, Bin, SubBin;

		SELECT 	EXT.TarDebExtraccionID,	TMP.Bin, 				TMP.SubBin,				TMP.NomArchivo,			EXT.EmpresaID,
					EXT.Usuario,			EXT.FechaActual,		EXT.DireccionIP,		EXT.ProgramaID,			EXT.Sucursal,
					EXT.NumTransaccion
				FROM TARDEBEXTRACCION EXT
				INNER JOIN TMP_TARDEBEXTRACCION TMP ON TMP.TarDebExtraccionID = EXT.TarDebExtraccionID
				WHERE EXT.TarDebExtraccionID = Par_TarDebExtraccionID;


		INSERT INTO TARDEBEXTRACCIONDET (
				TarDebExtraccionID,			Bin,					SubBin,					NomArchivoExt,			EmpresaID,
				Usuario,					FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
				NumTransaccion
			)
			SELECT 	EXT.TarDebExtraccionID,	TMP.Bin, 				TMP.SubBin,				TMP.NomArchivo,			EXT.EmpresaID,
					EXT.Usuario,			EXT.FechaActual,		EXT.DireccionIP,		EXT.ProgramaID,			EXT.Sucursal,
					EXT.NumTransaccion
				FROM TARDEBEXTRACCION EXT
				INNER JOIN TMP_TARDEBEXTRACCION TMP ON TMP.TarDebExtraccionID = EXT.TarDebExtraccionID
				WHERE EXT.TarDebExtraccionID = Par_TarDebExtraccionID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Archivo extraido registrado correctamente.';
		SET Var_Control := 'tarDebExtraccionDetID';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$