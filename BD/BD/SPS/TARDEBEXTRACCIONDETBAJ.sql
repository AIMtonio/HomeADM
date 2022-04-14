-- TARDEBEXTRACCIONDETBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS TARDEBEXTRACCIONDETBAJ;
DELIMITER $$

CREATE PROCEDURE TARDEBEXTRACCIONDETBAJ(
	Par_TarDebExtraccionID 	INT(11),			-- Tipo de Archivo (E = Emi, S = Stats).

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
	DECLARE Var_NomArchivo 		VARCHAR(50);		-- Nombre del archivo
	DECLARE Var_TarDebExtID		INT(11);			-- ID de la extraccion de archivo

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
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-TARDEBEXTRACCIONDETBAJ');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(Par_TarDebExtraccionID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el ID de Extraccion de Archivo.';
			SET Var_Control := 'nombreArchivo';
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM TARDEBEXTRACCIONDET
			WHERE TarDebExtraccionID = Par_TarDebExtraccionID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Archivo de tarjeta eliminado correctamente.';
		SET Var_Control := 'tarDebExtraccionID';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$