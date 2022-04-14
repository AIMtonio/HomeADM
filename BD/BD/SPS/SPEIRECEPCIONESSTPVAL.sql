-- SPEIRECEPCIONESSTPVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESSTPVAL`;
DELIMITER $$


CREATE PROCEDURE `SPEIRECEPCIONESSTPVAL`(

	Par_FolioBanxico		BIGINT(20),		-- Folio Banxico (Aca se almacenara el Folio recibido por STP[idAbono])
	Par_FechaCaptura		DATETIME,		-- Fecha de Captura

	Par_Salida				CHAR(1),		-- Indica Salida

	INOUT Par_NumErr		INT(11),		-- Inout NumErr
	INOUT Par_ErrMen		VARCHAR(400),	-- Inout ErrMen

	Aud_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion

)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_FolioBanxExist	BIGINT(20);			-- Almacena el Folio de la Recepcion para validarlo
	DECLARE Var_Control			VARCHAR(50);

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

     -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;


    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESSTPVAL');
			SET Var_Control:= 'sqlException' ;
		END;

		 SELECT FolioBanxico INTO Var_FolioBanxExist
			FROM SPEIRECEPCIONESPEN
			WHERE FolioBanxico = Par_FolioBanxico
				AND FechaCaptura = Par_FechaCaptura;

		SET Var_FolioBanxExist := IFNULL(Var_FolioBanxExist,0);

		IF(Var_FolioBanxExist <> 0)THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := CONCAT('Folio Registrado Previamente ',CAST(Var_FolioBanxExist AS CHAR));
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Validacion Exitosa.';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'folioBanxico' AS control;
	END IF;

END TerminaStore$$
