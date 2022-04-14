-- INDICENAPRECONSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INDICENAPRECONSALT`;
DELIMITER $$

CREATE PROCEDURE `INDICENAPRECONSALT`(
# ============================================================================
# ----------- REGISTRO DE INDICE NACIONAL DE PRECIOS AL CONSUMIDOR -----------
# ============================================================================
    Par_Anio   				INT(11),		-- Anio del registro
    Par_Mes					INT(11),		-- Mes del registro
	Par_ValorINPC 			DECIMAL(12,3),	-- Valor del INPC

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
)TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Var_Consecutivo		VARCHAR(100); 	-- Variable para el consecutivo
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_FecInicial		DATE;			-- Fecha inicial mes
	DECLARE Var_FecFinal		DATE;			-- Fecha final mes
	DECLARE Var_FechaSistema	DATE;			-- Fecha del sistema

    -- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena vacia ''
	DECLARE Entero_Cero		INT(11);			-- Entero Cero 0
    DECLARE Decimal_Cero    DECIMAL(12,2);		-- Decimal Cero 0.0
	DECLARE Salida_SI		CHAR(1);			-- Mensaje se salida: S
	DECLARE ValorUno		CHAR(2);			-- Valor: 01

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
    SET Decimal_Cero		:= 0.0;
	SET Salida_SI			:= 'S';
    SET ValorUno			:= '01';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
						concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-INDICENAPRECONSALT');
				SET Var_Control = 'sqlException' ;
		END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF (IFNULL(Par_Anio,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := "El Anio esta Vacio.";
			SET Var_Control	:= 'anio';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Mes,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := "El Mes esta Vacio.";
			SET Var_Control	:= 'mes';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_ValorINPC,Decimal_Cero) = Decimal_Cero)THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := "El Valor de IPNC esta Vacio.";
			SET Var_Control	:= 'valorINPC';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Anio = YEAR(Var_FechaSistema))THEN
			IF(Par_Mes >= MONTH(Var_FechaSistema))THEN
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := "No se puede registrar el valor del INPC del mes seleccionado.";
				SET Var_Control	:= 'mes';
				LEAVE ManejoErrores;
            END IF;
        END IF;

		-- Se obtiene la fecha inicial del mes
		SET Var_FecInicial  := DATE(CONCAT(Par_Anio,'-',Par_Mes,'-',ValorUno));

		-- Se obtiene la fecha final del mes
		SET Var_FecFinal 	:= (SELECT(LAST_DAY(Var_FecInicial)));

		SET Aud_FechaActual  := NOW();

		INSERT INTO INDICENAPRECONS(
			Anio,				Mes,			ValorINPC,			FechaFinMes,		FechaRegistro,
			EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion
		)VALUES(
			Par_Anio,			Par_Mes,		Par_ValorINPC,		Var_FecFinal,		Var_FechaSistema,
			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'INPC Grabado Exitosamente.';
		SET Var_Control	:= 'anio';
		SET Var_Consecutivo := Par_Anio;
		LEAVE ManejoErrores;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$