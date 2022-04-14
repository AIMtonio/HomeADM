-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDWSALT`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDWSALT`(
-- SP PARA DAR DE ALTA LA INFORMACION ADICIONAL DE LOS CREDITOS
	Par_CreditoID		BIGINT(20),		-- Numero de Credito
	Par_Institucion		INT(11),	 	-- Numero de la institucion Bancaria donde se recibe el pago
	Par_Cuenta		 	BIGINT(11),		-- Numero de la Cuenta de Banco donde se recibe el pago
	Par_Fecha			DATE,			-- Fecha de recaudacion
    Par_PreConsumidos	DECIMAL(14,2),	-- Precio por litro por los litros consumidos (monto recaudado, monto de pago del credito)
    Par_LitConsumidos	DECIMAL(14,2),		-- Consumo total de litros

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

	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);		-- Entero en cero
	DECLARE Salida_SI 		CHAR(1);		-- Salida SI

    DECLARE Var_InfoAdicWSID	INT(11);		-- ID de la tabla

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria
	SET Var_Control		:= '';				-- Valor de auditoria
	SET Salida_SI		:= 'S';				-- Valor de auditoria
    SET Aud_FechaActual	:= NOW();			-- Valor de la Fecha Actual

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-INFOADICIONALCREDWSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        SET Par_CreditoID		:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_Institucion		:= IFNULL(Par_Institucion, Entero_Cero);
		SET Par_Cuenta			:= IFNULL(Par_Cuenta, Entero_Cero);
		SET Par_Fecha			:= IFNULL(Par_Fecha, Cadena_Vacia);
        SET Par_PreConsumidos	:= IFNULL(Par_PreConsumidos, Entero_Cero);
        SET Par_LitConsumidos	:= IFNULL(Par_LitConsumidos, Entero_Cero);

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El Credito esta Vacio.');
			SET Var_Control := 'CreditoID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Institucion = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('La Institucion esta Vacia.');
			SET Var_Control := 'Institucion';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Cuenta = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := CONCAT('El Cuenta esta Vacio.');
			SET Var_Control := 'Cuenta';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Fecha = Cadena_Vacia) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := CONCAT('El Fecha esta Vacio.');
			SET Var_Control := 'Fecha';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_PreConsumidos = Entero_Cero) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := CONCAT('El Precio Consumido esta Vacio.');
			SET Var_Control := 'PreConsumidos';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LitConsumidos = Entero_Cero) THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := CONCAT('El Litro Consumido esta Vacio');
			SET Var_Control := 'LitConsumidos';
			LEAVE ManejoErrores;
		END IF;

        SET Var_InfoAdicWSID	:=(SELECT IFNULL(MAX(InfoAdicionalWSID),Entero_Cero)+1 FROM INFOADICIONALCREDWS);

        INSERT INTO INFOADICIONALCREDWS (
			InfoAdicionalWSID,	CreditoID,			Institucion,		Cuenta,				Fecha,
            PreConsumidos,      LitConsumidos,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,         Sucursal,			NumTransaccion)
		VALUES(
			Var_InfoAdicWSID,	Par_CreditoID,		Par_Institucion,	Par_Cuenta,			Par_Fecha,
            Par_PreConsumidos,	Par_LitConsumidos,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  	:=  0;
		SET Par_ErrMen  	:=  CONCAT('Agregada Exitosamente. ', Var_InfoAdicWSID);
		SET Var_Control 	:=  'InfoAdicWSID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS Control,
               Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
