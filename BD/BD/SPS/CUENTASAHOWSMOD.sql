-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOWSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOWSMOD`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOWSMOD`(
-- SP PARA MODIFICAR LA CUENTA DE AHORRO DEL WS
    Par_CtaAhoID		BIGINT(12),		-- Numero de Modificacion
    Par_Monto			DECIMAL(14,2),
    Par_NumMod			INT(2),

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
	DECLARE Var_Saldo			DECIMAL(14,2);
    DECLARE Var_SaldoBloq		DECIMAL(14,2);
    DECLARE Var_SaldoDispon		DECIMAL(14,2);
    DECLARE	Mod_Prin			INT(2);
    DECLARE	Mod_Desb			INT(2);

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

	SET Mod_Prin		:= 1;
    SET Mod_Desb		:= 2;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-CUENTASAHOWSMOD');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        SET Par_CtaAhoID	:= IFNULL(Par_CtaAhoID, Entero_Cero);
        SET Par_Monto		:= IFNULL(Par_Monto, Entero_Cero);
        SET Par_NumMod		:= IFNULL(Par_NumMod, Entero_Cero);

        IF(Par_CtaAhoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('La Cuenta Ahorro esta Vacia.');
			SET Var_Control := 'CtaAho';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_Monto = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('El Monto esta Vacio.');
			SET Var_Control := 'Monto';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_NumMod = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := CONCAT('El Numero de Modificacion esta Vacio.');
			SET Var_Control := 'Monto';
			LEAVE ManejoErrores;
		END IF;

		SET Var_Saldo		:= (SELECT Saldo FROM CUENTASAHO WHERE CuentaAhoID = Par_CtaAhoID);
        SET Var_SaldoBloq	:= (SELECT SaldoBloq FROM CUENTASAHO WHERE CuentaAhoID = Par_CtaAhoID);
        SET Var_SaldoDispon	:= (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = Par_CtaAhoID);

		SET Var_Saldo		:= IFNULL(Var_Saldo, Entero_Cero);
		SET Var_SaldoBloq	:= IFNULL(Var_SaldoBloq, Entero_Cero);
        SET Var_SaldoDispon	:= IFNULL(Var_SaldoDispon, Entero_Cero);

        IF(Par_NumMod = Mod_Prin) THEN
			SET Var_SaldoBloq	:= Var_SaldoBloq + Par_Monto;
            SET Var_Saldo	:= Var_Saldo + Par_Monto;

            UPDATE CUENTASAHO SET
				Saldo = Var_Saldo,
				SaldoBloq = Var_SaldoBloq
			WHERE	CuentaAhoID	= Par_CtaAhoID;
        END IF;

        IF(Par_NumMod = Mod_Desb) THEN
			IF(Var_SaldoBloq != Entero_Cero) THEN
				SET Var_SaldoBloq	:= Var_SaldoBloq - Par_Monto;
				SET Var_SaldoDispon	:= Var_SaldoDispon + Par_Monto;

                UPDATE CUENTASAHO SET
					SaldoDispon = Var_SaldoDispon,
					SaldoBloq = Var_SaldoBloq
				WHERE	CuentaAhoID	= Par_CtaAhoID;
            END IF;
        END IF;

		SET Par_NumErr  	:=  0;
		SET Par_ErrMen  	:=  CONCAT('Saldo Bloqueado Modificado Exitosamente. ', Par_CtaAhoID);
		SET Var_Control 	:=  'CtaAho';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS Control,
               Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
