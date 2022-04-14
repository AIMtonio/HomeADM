-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDALT`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDALT`(
-- SP PARA DAR DE ALTA LA INFORMACION ADICIONAL DE LOS CREDITOS
	Par_CreditoID		BIGINT(20),		-- Numero de Credito
	Par_Placa			VARCHAR(7),	 	-- Placa del Automovil
	Par_GNV		 		INT(11),		-- Litros Consumidos del Vehiculo
	Par_Vin				VARCHAR(250),	-- Vin del Vehiculo
    Par_EstatusWS		CHAR(1),		-- Estatus del WS

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
    DECLARE Decimal_Cero	DECIMAL(14,2);	-- Decimal Cero
    DECLARE Milesimo_Cero	DECIMAL(14,4);	-- Milesimo Cero

    DECLARE	Var_Plazo		DECIMAL(14,2);	-- Variable del Plazo
    DECLARE	Var_MontoCuota	DECIMAL(14,2);	-- Variable del Monto Cuota
    DECLARE Var_Recaudo		DECIMAL(14,4);	-- Variable del Recaudo
    DECLARE Var_InfoAdicID	INT(11);		-- ID de la tabla

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria
	SET Var_Control		:= '';				-- Valor de auditoria
	SET Salida_SI		:= 'S';				-- Valor de auditoria
    SET Aud_FechaActual	:= NOW();			-- Valor de la Fecha Actual

    SET Decimal_Cero	:= 0.00;			-- Valor del decimal cero
    SET Milesimo_Cero	:= 0.0000;			-- Valor del milesimo cero

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-INFOADICIONALCREDALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        SET Par_CreditoID	:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_Placa		:= IFNULL(Par_Placa, Cadena_Vacia);
		SET Par_GNV			:= IFNULL(Par_GNV, Entero_Cero);
		SET Par_Vin			:= IFNULL(Par_Vin, Cadena_Vacia);
        SET Par_EstatusWS	:= IFNULL(Par_EstatusWS, Cadena_Vacia);

		IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El Credito esta Vacio.');
			SET Var_Control := 'CreditoID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Placa = Cadena_Vacia) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('La Placa esta Vacia.');
			SET Var_Control := 'Placa';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_GNV = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := CONCAT('El GNV esta Vacio.');
			SET Var_Control := 'GNV';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Vin = Cadena_Vacia) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := CONCAT('El Vin esta Vacio.');
			SET Var_Control := 'Vin';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EstatusWS = Cadena_Vacia) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := CONCAT('El Estado del WS esta Vacio.');
			SET Var_Control := 'EstatusWS';
			LEAVE ManejoErrores;
		END IF;

        -- Sacar el Plazo del Credito
        SET Var_Plazo	:= (SELECT NumAmortizacion FROM CREDITOS WHERE CreditoID = Par_CreditoID);

        -- Sacar el Monto Cuota del Credito
        SET Var_MontoCuota	:= (SELECT MontoCuota FROM CREDITOS WHERE CreditoID = Par_CreditoID);

        -- Sacar el Recaudo del Credito
		SET Var_Recaudo	:= (Var_MontoCuota / Par_GNV);
        SET Var_Recaudo := (SELECT CAST(Var_Recaudo AS DECIMAL));

		SET Var_Plazo		:= IFNULL(Var_Plazo, Decimal_Cero);
		SET Var_MontoCuota	:= IFNULL(Var_MontoCuota, Decimal_Cero);
        SET Var_Recaudo		:= IFNULL(Var_Recaudo, Milesimo_Cero);

		IF(Var_Plazo = Decimal_Cero) THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := CONCAT('El Credito no tiene Plazo');
			SET Var_Control := 'Plazo';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_MontoCuota = Decimal_Cero) THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := CONCAT('El Credito no tiene Monto de Cuota');
			SET Var_Control := 'MontoCuota';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Recaudo = Milesimo_Cero) THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := CONCAT('El Credito no tiene Valor de Recaudo');
			SET Var_Control := 'Recaudo';
			LEAVE ManejoErrores;
		END IF;

        SET Var_InfoAdicID	:=(SELECT IFNULL(MAX(InfoAdicionalID),Entero_Cero)+1 FROM INFOADICIONALCRED);

        INSERT INTO INFOADICIONALCRED (
			InfoAdicionalID,	CreditoID,			Placa,				GNV,			Vin,
            EstatusWS,          Plazo,				Recaudo,			EmpresaID,		Usuario,
            FechaActual,		DireccionIP,		ProgramaID,         Sucursal,		NumTransaccion)
		VALUES(
			Var_InfoAdicID,	Par_CreditoID,		Par_Placa,			Par_GNV,		Par_Vin,
            Par_EstatusWS,		Var_Plazo,			Var_Recaudo,		Aud_EmpresaID,	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr  	:=  0;
		SET Par_ErrMen  	:=  CONCAT('Agregada Exitosamente. ', Var_InfoAdicID);
		SET Var_Control 	:=  'InfoAdicID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS Control,
               Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
