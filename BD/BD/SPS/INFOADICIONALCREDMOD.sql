-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDMOD`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDMOD`(
-- SP PARA MODIFICAR LA INFORMACION ADICIONAL DE LOS CREDITOS WS
	Par_Placa			VARCHAR(7),	 	-- Placa del Automovil
    Par_CreditoID		BIGINT(20),		-- Numero de Credito
	Par_Recaudo		 	DECIMAL(14,4),	-- Recaudo del Vehiculo
	Par_Plazo			DECIMAL(14,2),	-- Plazo del Vehiculo
	Par_Vin				VARCHAR(250),	-- Vin del Vehiculo
    Par_NumMod			INT(2),			-- Numero de Modificacion

    Par_Salida			CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr	INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Control			VARCHAR(100);	-- Control de Retorno en pantalla
    DECLARE Var_Consecutivo		VARCHAR(200);	-- Numero consecutivo

    DECLARE EstAcep				CHAR(1);		-- Estatus Aceptado del WS
    DECLARE EstError			CHAR(1);		-- Estatus Error del WS
    DECLARE EstPend				CHAR(1);		-- Estatus Pendiente del WS
    DECLARE Var_Est				CHAR(1);		-- Estatus del WS

	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	-- Entero en cero
	DECLARE Salida_SI 		CHAR(1);	-- Salida SI

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria
	SET Var_Control		:= '';				-- Valor de auditoria
	SET Salida_SI		:= 'S';				-- Valor de auditoria

    SET EstAcep			:= 'A';				-- Valor del Estatus Aceptado
    SET EstError		:= 'E';				-- Valor del Estatus Error
    SET EstPend			:= 'P';				-- Valor del Estatus Pendiente

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-INFOADICIONALCREDMOD');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        SET Par_Placa		:= IFNULL(Par_Placa, Cadena_Vacia);
        SET Par_CreditoID	:= IFNULL(Par_CreditoID, Cadena_Vacia);
		SET Par_Recaudo		:= IFNULL(Par_Recaudo, Cadena_Vacia);
		SET Par_Plazo		:= IFNULL(Par_Plazo, Cadena_Vacia);
        SET Par_Vin			:= IFNULL(Par_Vin, Cadena_Vacia);
        SET Par_NumMod		:= IFNULL(Par_NumMod, Cadena_Vacia);

        IF(Par_Placa = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('La Placa esta Vacia.');
			SET Var_Control := 'Placa';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CreditoID = Cadena_Vacia) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('El Credito esta Vacio.');
			SET Var_Control := 'CreditoID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Recaudo = Cadena_Vacia) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := CONCAT('El Recaudo esta Vacio.');
			SET Var_Control := 'Recaudo';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Plazo = Cadena_Vacia) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := CONCAT('El Plazo esta Vacio.');
			SET Var_Control := 'Recaudo';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Vin = Cadena_Vacia) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := CONCAT('El Vin esta Vacio.');
			SET Var_Control := 'Vin';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumMod = Cadena_Vacia) THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := CONCAT('El Número de Modificación esta Vacio.');
			SET Var_Control := 'NumMod';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NumMod = 1) THEN
			SET Var_Est	 := EstAcep;
		ELSE
			IF(Par_NumMod = 2) THEN
				SET Var_Est	 := EstError;
			ELSE
				SET Var_Est	 := EstPend;
			END IF;
        END IF;

        UPDATE INFOADICIONALCRED SET
				EstatusWS	= Var_Est
			WHERE	Placa		= Par_Placa
				AND CreditoID	= Par_CreditoID
                AND Recaudo		= Par_Recaudo
                AND Plazo		= Par_Plazo
                AND Vin			= Par_Vin;

		SET Par_NumErr  	:=  0;
		SET Par_ErrMen  	:=  CONCAT('Estatus Modificado Exitosamente. ', Par_CreditoID);
		SET Var_Control 	:=  'CreditoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS Control,
               Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
